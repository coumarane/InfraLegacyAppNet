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
