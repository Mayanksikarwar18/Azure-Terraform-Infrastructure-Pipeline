output "id" {
  description = "The ID of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "name" {
  description = "The name of the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "admin_username" {
  description = "The admin username for the Virtual Machine"
  value       = azurerm_linux_virtual_machine.vm.admin_username
}

