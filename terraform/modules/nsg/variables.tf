variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type    = string
  default = null

  validation {
    condition     = !var.associate_with_subnet || (var.subnet_id != null && var.subnet_id != "")
    error_message = "subnet_id must be provided when associate_with_subnet is true."
  }
}

variable "associate_with_subnet" {
  type        = bool
  description = "Whether to associate this NSG with the provided subnet_id."
  default     = true
}

variable "security_rules" {
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
    description                  = optional(string)
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
