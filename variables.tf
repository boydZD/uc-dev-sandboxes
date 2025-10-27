#use env.sh to set this var in your shell
variable "workspace_url" {
  nullable = false
  description = "Target Workspace URL"
}

variable "workspace_id" {
  nullable = false
  description = "Target Workspace ID"
}

variable "client_id" {
  nullable = false
  sensitive = true
  description = "Client ID for the deployment Service Principal"
}

variable "client_secret" {
  nullable = true
  sensitive = true
  description = "Client Secret for the deployment Service Principal"
}

variable "s3_sandbox_base_path" {
  type        = string
  description = "Base path for the sandbox external locations."
  default     = "s3://<my-bucket>/sandboxes/"
}

variable "storage_credential_id" {
  description = "Storage Credential ID to be used for the sandbox external location."
  type        = string
}

variable "tenant_map" {
  type = map(object({
    #name = string
    catalog_admin = string
  }))
  description = "Map of tenant names to tenant details"
  default = {
    "demo-tenant1" = {
      #name = "irs-demo"
      catalog_admin = "irs-sa"
    },
    "demo-tenant2" = {
      #name = "irs-demo"
      catalog_admin = "irs-sa"
    },
  }
}