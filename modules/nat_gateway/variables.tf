variable "name" {
  description = "The name of the NAT gateway"
  type        = string
}

variable "public_ip_name" {
  description = "The name of the Public IP resource for the NAT gateway"
  type        = string
}

variable "location" {
  description = "The Azure region where the NAT gateway should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the NAT gateway"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the NAT gateway"
  type        = string
}

variable "idle_timeout_in_minutes" {
  description = "The idle timeout in minutes which is used for the NAT Gateway"
  type        = number
  default     = 4
}

variable "tags" {
  description = "A mapping of tags to assign to the NAT gateway resources"
  type        = map(string)
  default     = {}
}
