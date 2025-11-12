
terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {
  host     = var.workspace_url
  client_id = var.client_id
  client_secret = var.client_secret
}