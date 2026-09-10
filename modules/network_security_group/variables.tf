variable "name" {
  description = "The name of the network security group"
  type        = string
}

variable "location" {
  description = "The Azure region where the network security group should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the network security group"
  type        = string
}

variable "subnet_id" {
  description = "Optional subnet ID to associate with the NSG"
  type        = string
  default     = null
}

variable "security_rules" {
  description = "List of security rules to apply to the network security group"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = optional(string, "*")
    destination_port_range     = optional(string)
    destination_port_ranges    = optional(list(string))
    source_address_prefix      = optional(string, "*")
    destination_address_prefix = optional(string, "*")
    description                = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "A mapping of tags to assign to the network security group"
  type        = map(string)
  default     = {}
}
