
variable "name" {
  type = string
}

variable "computer_name" {
  type    = string
  default = null
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "size" {
  type    = string
  default = "Standard_B2ms"
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "create_public_ip" {
  type    = bool
  default = false
}

variable "encryption_at_host_enabled" {
  type    = bool
  default = false
}

variable "os_disk_storage_account_type" {
  type    = string
  default = "StandardSSD_LRS"
}

variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}

variable "image_publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "image_offer" {
  type    = string
  default = "WindowsServer"
}

variable "image_sku" {
  type    = string
  default = "2022-datacenter-azure-edition"
}

variable "image_version" {
  type    = string
  default = "latest"
}

variable "tags" {
  type    = map(string)
  default = {}
}
