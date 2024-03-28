variable "resource_group" {
  type        = string
  description = "Name of the resource group to use"
  default     = "JKM"
}

variable "app_service_name" {
  type        = string
  description = "Name to use for the App Service"
  default     = "da4-pgadmin"
}

variable "storage_account_name" {
    type        = string
  description = "Name to use for the Storage Account"
  default     = "da4pgadmin"
}

variable "default_admin_email" {
  type        = string
  description = "Email address for the default admin user"
  default     = "da4-admin@corndel.com"
}

variable "default_admin_password" {
  type        = string
  description = "Password for the default admin user"
  sensitive   = true
}