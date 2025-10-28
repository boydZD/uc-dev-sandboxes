locals {
  tenant_catalog_name = "${var.resource_prefix}_${replace(var.tenant_name, "-", "_")}"
  storage_root     = "${trimsuffix(var.s3_base_path, "/")}/${replace(var.tenant_name, "-", "_")}"
}

# External Location
resource "databricks_external_location" "sandbox_external_location" {
  name            = "${local.tenant_catalog_name}-external-location"
  url             = local.storage_root
  credential_name = var.storage_credential_id
  comment         = "External location for catalog ${local.tenant_catalog_name}"
  isolation_mode  = "ISOLATION_MODE_ISOLATED"
}

# Workspace Catalog
resource "databricks_catalog" "sandbox_catalog" {
  name           = local.tenant_catalog_name
  comment        = "This catalog is a sandbox for tenant ${var.tenant_name}"
  isolation_mode = "ISOLATED"
  storage_root   = local.storage_root
  properties = {
    purpose = "Sandbox catalog for ${var.tenant_name}"
  }
  depends_on = [databricks_external_location.sandbox_external_location]
}

resource "databricks_workspace_binding" "sandbox" {
  securable_name = databricks_catalog.sandbox_catalog.name
  workspace_id   = var.workspace_id
}

# Grant Admin Catalog Perms
resource "databricks_grant" "sandbox_catalog" {
  catalog = databricks_catalog.sandbox_catalog.name

  principal  = var.catalog_admin
  privileges = ["ALL_PRIVILEGES"]
  depends_on = [databricks_catalog.sandbox_catalog, databricks_workspace_binding.sandbox]
}

# Grant external location perms

resource "databricks_grant" "sandbox_external_location" {
  external_location = databricks_external_location.sandbox_external_location.id

  principal  = var.catalog_admin
  privileges = ["WRITE_FILES", "READ_FILES"]
  depends_on = [databricks_external_location.sandbox_external_location]
}