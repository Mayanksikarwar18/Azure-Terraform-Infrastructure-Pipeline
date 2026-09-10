output "id" {
  description = "The ID of the network interface"
  value       = azurerm_network_interface.nic.id
}

output "name" {
  description = "The name of the network interface"
  value       = azurerm_network_interface.nic.name
}

output "private_ip_address" {
  description = "The first private IP address assigned to the network interface"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "public_ip_address_id" {
  description = "The Public IP address ID associated with this network interface"
  value       = azurerm_network_interface.nic.ip_configuration[0].public_ip_address_id
}
