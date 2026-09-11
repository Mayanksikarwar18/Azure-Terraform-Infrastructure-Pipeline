variable "name" {
  description = "The name of the Linux Virtual Machine"
  type        = string
}

variable "location" {
  description = "The Azure region where the Virtual Machine should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Virtual Machine"
  type        = string
}

variable "vm_size" {
  description = "The SKU / size of the Virtual Machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "The admin username for the Virtual Machine"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Optional admin password for the Virtual Machine (if not using SSH key)"
  type        = string
  default     = null
  sensitive   = true
}

variable "ssh_public_key" {
  description = "The SSH public key text. If null and admin_password is null, a new key pair will be generated."
  type        = string
  default     = null
}

variable "network_interface_ids" {
  description = "A list of Network Interface IDs to attach to this Virtual Machine"
  type        = list(string)
}

variable "os_disk_caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Options: None, ReadOnly, ReadWrite"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Options: Standard_LRS, StandardSSD_LRS, Premium_LRS"
  type        = string
  default     = "StandardSSD_LRS"
}

variable "os_disk_size_gb" {
  description = "The Size of the Internal OS Disk in GB"
  type        = number
  default     = 30
}

variable "image_publisher" {
  description = "The publisher of the image used to create the Virtual Machine"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the image used to create the Virtual Machine"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "The SKU of the image used to create the Virtual Machine"
  type        = string
  default     = "22_04-lts-gen2"
}

variable "image_version" {
  description = "The version of the image used to create the Virtual Machine"
  type        = string
  default     = "latest"
}

variable "custom_data" {
  description = "Base64-encoded string of custom data / cloud-init script for VM provisioning"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the Virtual Machine"
  type        = map(string)
  default     = {}
}

variable "allow_extension_operations" {
  description = "Should extension operations be allowed on this Virtual Machine"
  type        = bool
  default     = false
}
