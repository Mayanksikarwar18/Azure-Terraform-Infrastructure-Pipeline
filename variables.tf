variable "environment" {
  description = "Deployment environment name (e.g. dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "centralindia"
}


variable "name_prefix" {
  description = "Prefix prepended to resource names"
  type        = string
  default     = "demo"
}

variable "resource_group_name" {
  description = "Custom name for the Resource Group. If omitted, a name will be generated using name_prefix and environment"
  type        = string
  default     = null
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the workload Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "vm_size" {
  description = "Virtual Machine SKU / size"
  type        = string
  default     = "Standard_B2as_v2"
}


variable "admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the Virtual Machine"
  type        = string
  default     = "AzureAdmin12345!"
  sensitive   = true
}


variable "allowed_ssh_source_address_prefix" {
  description = "Source IP/CIDR allowed to connect to SSH (port 22)"
  type        = string
  default     = "*"
}

variable "enable_vm_public_ip" {
  description = "Whether to allocate a dedicated Standard Public IP and attach it to the VM Network Interface"
  type        = bool
  default     = true
}

variable "vm_domain_name_label" {
  description = "Optional DNS label for the VM Public IP (resulting FQDN: <label>.<region>.cloudapp.azure.com)"
  type        = string
  default     = null
}

variable "allowed_app_source_address_prefix" {
  description = "Source IP/CIDR allowed to access application ports (HTTP 80, HTTPS 443, and application_port)"
  type        = string
  default     = "*"
}

variable "application_port" {
  description = "Custom application port opened in NSG for web/API services"
  type        = string
  default     = "8080"
}

variable "install_sample_application" {
  description = "Whether to automatically install and run the sample Nginx application dashboard on VM boot via cloud-init"
  type        = bool
  default     = true
}

variable "custom_data" {
  description = "Optional raw cloud-init / startup script for the VM. If specified, overrides the default sample application."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Project     = "Azure-Infra-Pipeline"
    Environment = "dev"
  }
}
