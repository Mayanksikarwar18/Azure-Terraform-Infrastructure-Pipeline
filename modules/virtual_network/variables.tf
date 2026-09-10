variable "name" {
  description = "The name of the virtual network"
  type        = string
}

variable "location" {
  description = "The Azure region where the virtual network should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space that is used the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "A mapping of tags to assign to the virtual network"
  type        = map(string)
  default     = {}
}
