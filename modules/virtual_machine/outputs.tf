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

output "tls_private_key_pem" {
  description = "The generated private key (if SSH key was auto-generated)"
  value       = length(tls_private_key.ssh) > 0 ? tls_private_key.ssh[0].private_key_pem : null
  sensitive   = true
}

output "tls_public_key_openssh" {
  description = "The generated public key (if SSH key was auto-generated)"
  value       = length(tls_private_key.ssh) > 0 ? tls_private_key.ssh[0].public_key_openssh : null
}
