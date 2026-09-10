variable "name" {
  description = "The name of the Public IP resource"
  type        = string
}

variable "location" {
  description = "The Azure region where the Public IP should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Public IP"
  type        = string
}

variable "allocation_method" {
  description = "The allocation method for this IP address (Static or Dynamic)"
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the Public IP (Basic or Standard)"
  type        = string
  default     = "Standard"
}

variable "domain_name_label" {
  description = "Optional label for the Domain Name. Resulting FQDN will be <label>.<location>.cloudapp.azure.com"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the Public IP"
  type        = map(string)
  default     = {}
}
