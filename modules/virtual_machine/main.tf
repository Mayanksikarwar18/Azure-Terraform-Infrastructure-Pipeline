terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.100.0, < 5.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
  }
}

resource "tls_private_key" "ssh" {
  count     = var.admin_password == null && var.ssh_public_key == null ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "vm" {
  #checkov:skip=CKV_AZURE_50:Virtual Machine extensions are disabled
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = var.admin_password == null
  admin_password                  = var.admin_password
  network_interface_ids           = var.network_interface_ids
  custom_data                     = var.custom_data
  allow_extension_operations      = var.allow_extension_operations

  dynamic "admin_ssh_key" {
    for_each = var.admin_password == null ? { default = var.admin_username } : {}
    content {
      username   = var.admin_username
      public_key = var.ssh_public_key != null ? var.ssh_public_key : tls_private_key.ssh[0].public_key_openssh
    }
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = var.tags
}
