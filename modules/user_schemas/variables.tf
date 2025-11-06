variable "catalog_name" {
  description = "Name of the sandbox catalog to create"
  type        = string
  default     = "sandbox"
}

variable "users_csv_path" {
  description = "Path to CSV file containing user emails. CSV must have an 'email' column."
  type        = string
}

variable "workspace_id" {
  description = "Workspace ID where the catalog will be isolated"
  type        = string
  nullable    = false
}

variable "s3_base_path" {
  description = "Base S3 path for the managed catalog storage location"
  type        = string
  nullable    = false
}
