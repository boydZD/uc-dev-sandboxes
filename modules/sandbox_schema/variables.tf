variable "catalog_name" {
  description = "Name of the sandbox catalog to create"
  type        = string
  default     = "sandbox"
}

variable "workspace_id" {
  description = "Workspace ID where the catalog will be isolated"
  type        = string
  nullable    = false
}

variable "user_email" {
  description = "Email of the user to create the sandbox for"
  type        = string
}