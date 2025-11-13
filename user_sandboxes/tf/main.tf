# ============================================================================
# User Schemas Module (Managed User Sandboxes)
# ============================================================================

locals {
  # Read and parse the CSV file
  users_csv = csvdecode(file(var.users_csv_path))

  # Create a map of users with sanitized username as key (replace . with _)
  users_map = {
    for user in local.users_csv :
      #replace(split("@", user.email)[0], ".", "_") => user.sanitized_name,
      user.email => user.email
  }
}


# Get current service principal info for user_schemas module
data "databricks_current_user" "deployment_sp" {}

# Get the external location that covers our S3 path for user_schemas
data "databricks_external_location" "sandbox_location" {
  name = var.external_location_name
}

# Grant CREATE_MANAGED_STORAGE permission to the service principal on the external location
# This is required to create catalogs with storage_root for user_schemas module
resource "databricks_grant" "sp_external_location" {
  external_location = data.databricks_external_location.sandbox_location.name

  principal  = data.databricks_current_user.deployment_sp.user_name
  privileges = ["CREATE_MANAGED_STORAGE"]
}

# Create the main sandbox catalog (managed storage at specified location)
resource "databricks_catalog" "user_sandbox_catalog" {
  name           = var.user_catalog_name
  comment        = "Sandbox catalog for user schemas with managed storage"
  isolation_mode = "ISOLATED"
  storage_root   = var.user_s3_base_path
  properties = {
    purpose = "User sandbox schemas"
  }
  depends_on = [
    databricks_grant.sp_external_location
  ]
}

# Bind catalog to workspace
resource "databricks_workspace_binding" "user_sandbox_catalog" {
  securable_name = databricks_catalog.user_sandbox_catalog.name
  workspace_id   = var.workspace_id
}


# User schemas module - creates one managed sandbox catalog with user-specific managed schemas
module "user_schemas" {
  for_each = local.users_map

  source         = "../../modules/sandbox_schema"
  catalog_name   = databricks_catalog.user_sandbox_catalog.name
  #users_csv_path = var.users_csv_path
  workspace_id   = var.workspace_id
  #s3_base_path   = var.user_s3_base_path
  user_email     = local.users_map[each.value]

  depends_on = [
    databricks_grant.sp_external_location,
    databricks_workspace_binding.user_sandbox_catalog
  ]
}
