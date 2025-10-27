# variable "aws_account_id" {
#   type        = string
#   description = "ID of the AWS account."
# }

# variable "cmk_admin_arn" {
#   description = "Amazon Resource Name (ARN) of the CMK admin."
#   type        = string
# }

variable "resource_prefix" {
  description = "Prefix for the resource names."
  type        = string
  default     = "sandbox"
}

variable "tenant_name" {
  description = "Name of the tenant that will own this catalog."
  type        = string
}

variable "catalog_admin" {
  description = "Catalog owner user/group name"
  type        = string
}

variable "workspace_id" {
  description = "Workspace ID of the dev workspace. The catalog will be isolated to this workspace."
  type        = string
}

variable "s3_base_path" {
  type        = string
  description = "Base path for the sandbox external locations. A tenant-specific external location will be created for each tenant. This will be used to store the sandbox catalog data and isolate direct operations on files in S3."
  default     = "s3://<my-bucket>/sandboxes/"
}

variable "storage_credential_id" {
  description = "Storage Credential ID to be used for the sandbox external location."
  type        = string
}