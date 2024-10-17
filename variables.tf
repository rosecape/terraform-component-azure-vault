variable "admin_users" {
  type        = list(string)
  description = "List of users that should have admin access to the key vault"
  default     = []
}

variable "admin_service_principals" {
  type        = list(string)
  description = "List of service principals that should have admin access to the key vault"
  default     = []
}

variable "full_access_service_principals" {
  type        = list(string)
  description = "List of service principals that should have full access to the key vault"
  default     = []
}

variable "full_access_users" {
  type        = list(string)
  description = "List of users that should have full access to the key vault"
  default     = []
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault"
}

variable "read_only_users" {
  type        = list(string)
  description = "List of users that should have read-only access to the key vault"
  default     = []
}

variable "read_only_service_principals" {
  type        = list(string)
  description = "List of service principals that should have read-only access to the key vault"
  default     = []
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "resource_group_location" {
  type        = string
  description = "Location of the resource group"
}
