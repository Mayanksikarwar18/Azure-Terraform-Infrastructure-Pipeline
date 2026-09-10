output "id" {
  description = "The ID of the Public IP resource"
  value       = azurerm_public_ip.pip.id
}

output "name" {
  description = "The name of the Public IP resource"
  value       = azurerm_public_ip.pip.name
}

output "ip_address" {
  description = "The actual IP address allocated"
  value       = azurerm_public_ip.pip.ip_address
}

output "fqdn" {
  description = "The Fully Qualified Domain Name (FQDN) of the Public IP"
  value       = azurerm_public_ip.pip.fqdn
}
