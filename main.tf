locals {
  name_prefix         = "${var.name_prefix}-${var.environment}"
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : "rg-${local.name_prefix}"
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
  cloud_init_content = var.custom_data != null ? var.custom_data : (
    var.install_sample_application ? file("${path.module}/templates/cloud-init.yaml") : null
  )
}

# 1. Resource Group Module
module "resource_group" {
  source   = "./modules/resource_group"
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# 2. Virtual Network Module
module "virtual_network" {
  source              = "./modules/virtual_network"
  name                = "vnet-${local.name_prefix}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  address_space       = var.vnet_address_space
  tags                = local.common_tags
}

# 3. Subnet Module
module "subnet" {
  source               = "./modules/subnet"
  name                 = "snet-${local.name_prefix}"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.subnet_address_prefixes
}

# 4. NAT Gateway Module (Standard Public IP + NAT Gateway associated with Subnet for Outbound Egress)
module "nat_gateway" {
  source                  = "./modules/nat_gateway"
  name                    = "natgw-${local.name_prefix}"
  public_ip_name          = "pip-natgw-${local.name_prefix}"
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.name
  subnet_id               = module.subnet.id
  idle_timeout_in_minutes = 4
  tags                    = local.common_tags
}

# 5. Network Security Group Module (SSH, HTTP, HTTPS, Application Port)
module "network_security_group" {
  source              = "./modules/network_security_group"
  name                = "nsg-${local.name_prefix}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet.id
  tags                = local.common_tags

  security_rules = [
    {
      name                       = "AllowSSHInbound"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = var.allowed_ssh_source_address_prefix
      destination_address_prefix = "*"
      description                = "Allow SSH inbound from specified source address"
    },
    {
      name                       = "AllowHTTPInbound"
      priority                   = 1010
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = var.allowed_app_source_address_prefix
      destination_address_prefix = "*"
      description                = "Allow HTTP inbound for web application traffic"
    },
    {
      name                       = "AllowHTTPSInbound"
      priority                   = 1020
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = var.allowed_app_source_address_prefix
      destination_address_prefix = "*"
      description                = "Allow HTTPS inbound for secure web application traffic"
    },
    {
      name                       = "AllowAppPortInbound"
      priority                   = 1030
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = var.application_port
      source_address_prefix      = var.allowed_app_source_address_prefix
      destination_address_prefix = "*"
      description                = "Allow custom application port inbound from specified source address"
    }
  ]
}

# 6. Public IP Module for Virtual Machine (Inbound Internet Access)
module "public_ip" {
  count               = var.enable_vm_public_ip ? 1 : 0
  source              = "./modules/public_ip"
  name                = "pip-vm-${local.name_prefix}"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  domain_name_label   = var.vm_domain_name_label
  tags                = local.common_tags
}

# 7. Network Interface Module
module "network_interface" {
  source                    = "./modules/network_interface"
  name                      = "nic-${local.name_prefix}"
  location                  = module.resource_group.location
  resource_group_name       = module.resource_group.name
  subnet_id                 = module.subnet.id
  network_security_group_id = module.network_security_group.id
  public_ip_address_id      = var.enable_vm_public_ip ? module.public_ip[0].id : null
  tags                      = local.common_tags
}

# 8. Virtual Machine Module
module "virtual_machine" {
  source                = "./modules/virtual_machine"
  name                  = "vm-${local.name_prefix}"
  location              = module.resource_group.location
  resource_group_name   = module.resource_group.name
  vm_size               = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  ssh_public_key        = var.ssh_public_key
  network_interface_ids = [module.network_interface.id]
  custom_data           = local.cloud_init_content != null ? base64encode(local.cloud_init_content) : null
  tags                  = local.common_tags
}
