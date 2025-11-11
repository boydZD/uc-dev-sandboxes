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
  nullable = false
  sensitive = true
  description = "Client Secret for the deployment Service Principal"
}

variable "s3_sandbox_base_path" {
  nullable = false
  type        = string
  description = "Base path for the sandbox external locations."
  default     = "s3://<my-bucket>/sandboxes/"
}

variable "storage_credential_id" {
  nullable = false
  description = "Storage Credential ID to be used for the sandbox external location."
  type        = string
}

variable "tenant_map" {
  type = map(object({
    catalog_admin = string
  }))
  description = "Map of tenant names to tenant details"
  default = {
    "demo-tenant1" = {
      catalog_admin = "some-group"
    },
    "demo-tenant2" = {
      catalog_admin = "another-group"
    },
  }
}

# ============================================================================
# Variables for user_schemas module (managed user sandboxes)
# ============================================================================

variable "user_catalog_name" {
  type        = string
  description = "Name of the managed user sandbox catalog"
  default     = "user_sandboxes"
}

variable "users_csv_path" {
  type        = string
  description = "Path to CSV file containing user emails for user_schemas module. CSV must have an 'email' column."
  default     = "./users.csv"
}

variable "user_s3_base_path" {
  type        = string
  description = "Base S3 path for the managed user catalog storage location (e.g., 's3://my-bucket/user-sandboxes/')"
  default     = "s3://<my-bucket>/user-sandboxes/"
}

variable "external_location_name" {
  type        = string
  description = "Name of the existing external location that covers the S3 base path. Required for CREATE_MANAGED_STORAGE permissions."
  nullable    = false
}
