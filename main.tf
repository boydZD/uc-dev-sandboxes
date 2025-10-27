module "sandbox_catalog" {
  for_each = var.tenant_map
  source = "./modules/sandbox_catalog"
  tenant_name = each.key
  catalog_admin = each.value.catalog_admin
  workspace_id = var.workspace_id
  s3_base_path = var.s3_sandbox_base_path
  storage_credential_id = var.storage_credential_id
}