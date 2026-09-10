variable "name" {
  description = "The name of the subnet"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to which the subnet belongs"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network to which the subnet belongs"
  type        = string
}

variable "address_prefixes" {
  description = "The address prefixes for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}
