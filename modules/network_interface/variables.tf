variable "name" {
  description = "The name of the network interface"
  type        = string
}

variable "location" {
  description = "The Azure region where the network interface should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the network interface"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to which the NIC should be connected"
  type        = string
}

variable "private_ip_address_allocation" {
  description = "The allocation method used for the private IP address. Options: Static or Dynamic"
  type        = string
  default     = "Dynamic"
}

variable "private_ip_address" {
  description = "The static private IP address to allocate (if allocation is Static)"
  type        = string
  default     = null
}

variable "network_security_group_id" {
  description = "Optional ID of a Network Security Group to associate with this NIC"
  type        = string
  default     = null
}

variable "associate_with_network_security_group" {
  description = "Whether to associate the NIC with a Network Security Group"
  type        = bool
  default     = true
}


variable "public_ip_address_id" {
  description = "Optional ID of a Public IP address to associate with this NIC"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the network interface"
  type        = map(string)
  default     = {}
}
