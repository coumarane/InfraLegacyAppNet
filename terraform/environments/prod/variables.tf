variable "subscription_id" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "legacyapp"
}

variable "vm_admin_username" {
  type = string
}

variable "vm_admin_password" {
  type      = string
  sensitive = true
}

## State storage variables
variable "state_resource_group_name" {
  type    = string
  default = ""
}

variable "state_storage_account_name" {
  type    = string
  default = ""
}

variable "state_container_name" {
  type    = string
  default = ""
}

variable "state_key" {
  type      = string
  default   = ""
  sensitive = true
}
