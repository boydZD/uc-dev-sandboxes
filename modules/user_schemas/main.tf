locals {
  # Read and parse the CSV file
  users_csv = csvdecode(file(var.users_csv_path))

  # Create a map of users with sanitized username as key (replace . with _)
  users_map = {
    for user in local.users_csv :
      replace(split("@", user.email)[0], ".", "_") => user.email
  }
}

# Create users in the workspace if they don't exist
resource "databricks_user" "sandbox_users" {
  for_each = local.users_map

  user_name = each.value
  force     = true
}

# Create the main sandbox catalog (managed storage at specified location)
resource "databricks_catalog" "sandbox" {
  name           = var.catalog_name
  comment        = "Sandbox catalog for user schemas with managed storage"
  isolation_mode = "ISOLATED"
  storage_root   = var.s3_base_path
  properties = {
    purpose = "User sandbox schemas"
  }
}

# Bind catalog to workspace
resource "databricks_workspace_binding" "sandbox" {
  securable_name = databricks_catalog.sandbox.name
  workspace_id   = var.workspace_id
}

# Create managed schema for each user
resource "databricks_schema" "user_schema" {
  for_each = local.users_map

  catalog_name   = databricks_catalog.sandbox.name
  name           = each.key
  comment        = "Managed sandbox schema for user ${each.value}"

  properties = {
    owner_email = each.value
  }

  depends_on = [
    databricks_workspace_binding.sandbox
  ]
}

# Grant schema ownership and full privileges to user
resource "databricks_grant" "user_schema_grants" {
  for_each = local.users_map

  schema = "${databricks_catalog.sandbox.name}.${each.key}"

  principal  = each.value
  privileges = [
    "ALL_PRIVILEGES"
  ]

  depends_on = [
    databricks_schema.user_schema,
    databricks_user.sandbox_users
  ]
}

# Grant USE_CATALOG permission on catalog so users can access their schemas
# Note: Users with ALL_PRIVILEGES on a schema automatically get catalog access,
# but this grant makes it explicit
resource "databricks_grant" "user_catalog_usage" {
  for_each = local.users_map

  catalog = databricks_catalog.sandbox.name

  principal  = each.value
  privileges = ["USE_CATALOG"]

  depends_on = [
    databricks_workspace_binding.sandbox,
    databricks_user.sandbox_users
  ]
}

# Create a managed volume for each user in their schema
resource "databricks_volume" "user_volume" {
  for_each = local.users_map

  catalog_name = databricks_catalog.sandbox.name
  schema_name  = databricks_schema.user_schema[each.key].name
  name         = "my_volume"
  volume_type  = "MANAGED"
  comment      = "Managed volume for user ${each.value}"

  depends_on = [
    databricks_schema.user_schema,
    databricks_grant.user_schema_grants
  ]
}
