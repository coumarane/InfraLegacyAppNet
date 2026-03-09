
variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "access_tier" {
  type    = string
  default = "Hot"
}

variable "min_tls_version" {
  type    = string
  default = "TLS1_2"
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "infrastructure_encryption_enabled" {
  type    = bool
  default = false
}

variable "blob_versioning_enabled" {
  type    = bool
  default = true
}

variable "container_names" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
