module "sandbox_catalog" {
  for_each = var.tenant_map
  source = "./modules/sandbox_catalog"
  tenant_name = each.key
  catalog_admin = each.value.catalog_admin
  workspace_id = var.workspace_id
  s3_base_path = var.s3_sandbox_base_path
  storage_credential_id = var.storage_credential_id
}

# ============================================================================
# User Schemas Module (Managed User Sandboxes)
# ============================================================================

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

# User schemas module - creates one managed sandbox catalog with user-specific managed schemas
module "user_schemas" {
  source         = "./modules/user_schemas"
  catalog_name   = var.user_catalog_name
  users_csv_path = var.users_csv_path
  workspace_id   = var.workspace_id
  s3_base_path   = var.user_s3_base_path

  depends_on = [
    databricks_grant.sp_external_location
  ]
}
