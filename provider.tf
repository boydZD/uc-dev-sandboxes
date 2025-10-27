
terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {
  #alias    = "mws"
  host     = var.workspace_url
  client_id = var.client_id
  client_secret = var.client_secret
}