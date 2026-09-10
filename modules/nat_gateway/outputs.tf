output "id" {
  description = "The ID of the NAT gateway"
  value       = azurerm_nat_gateway.nat_gw.id
}

output "name" {
  description = "The name of the NAT gateway"
  value       = azurerm_nat_gateway.nat_gw.name
}

output "public_ip_id" {
  description = "The ID of the Public IP allocated for the NAT gateway"
  value       = azurerm_public_ip.nat_pip.id
}

output "public_ip_address" {
  description = "The public IP address allocated for the NAT gateway"
  value       = azurerm_public_ip.nat_pip.ip_address
}
