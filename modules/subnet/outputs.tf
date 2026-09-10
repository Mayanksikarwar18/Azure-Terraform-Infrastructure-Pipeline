output "id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.subnet.id
}

output "name" {
  description = "The name of the subnet"
  value       = azurerm_subnet.subnet.name
}

output "address_prefixes" {
  description = "The address prefixes of the subnet"
  value       = azurerm_subnet.subnet.address_prefixes
}
