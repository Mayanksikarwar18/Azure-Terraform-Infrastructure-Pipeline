output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = module.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the Resource Group"
  value       = module.resource_group.id
}

output "virtual_network_name" {
  description = "The name of the Virtual Network"
  value       = module.virtual_network.name
}

output "virtual_network_id" {
  description = "The ID of the Virtual Network"
  value       = module.virtual_network.id
}

output "subnet_name" {
  description = "The name of the workload Subnet"
  value       = module.subnet.name
}

output "subnet_id" {
  description = "The ID of the workload Subnet"
  value       = module.subnet.id
}

output "nat_gateway_name" {
  description = "The name of the NAT Gateway"
  value       = module.nat_gateway.name
}

output "nat_gateway_public_ip" {
  description = "The public IP allocated to the NAT Gateway for outbound traffic"
  value       = module.nat_gateway.public_ip_address
}

output "network_security_group_name" {
  description = "The name of the Network Security Group"
  value       = module.network_security_group.name
}

output "network_interface_name" {
  description = "The name of the Network Interface"
  value       = module.network_interface.name
}

output "vm_private_ip" {
  description = "The private IP address of the Virtual Machine"
  value       = module.network_interface.private_ip_address
}

output "vm_public_ip" {
  description = "The public IP address assigned to the Virtual Machine for inbound internet access"
  value       = var.enable_vm_public_ip ? module.public_ip[0].ip_address : null
}

output "vm_fqdn" {
  description = "The Fully Qualified Domain Name of the Virtual Machine (if domain label configured)"
  value       = var.enable_vm_public_ip ? module.public_ip[0].fqdn : null
}

output "application_url" {
  description = "Direct HTTP URL to access the web application from the internet"
  value = var.enable_vm_public_ip ? (
    module.public_ip[0].fqdn != null ? "http://${module.public_ip[0].fqdn}" : "http://${module.public_ip[0].ip_address}"
  ) : null
}

output "ssh_connection_command" {
  description = "Example SSH command to connect to the Virtual Machine"
  value       = var.enable_vm_public_ip ? "ssh ${module.virtual_machine.admin_username}@${module.public_ip[0].ip_address}" : "ssh ${module.virtual_machine.admin_username}@${module.network_interface.private_ip_address}"
}

output "vm_name" {
  description = "The name of the Virtual Machine"
  value       = module.virtual_machine.name
}

output "vm_id" {
  description = "The ID of the Virtual Machine"
  value       = module.virtual_machine.id
}

output "vm_admin_username" {
  description = "The admin username of the Virtual Machine"
  value       = module.virtual_machine.admin_username
}

output "ssh_private_key_pem" {
  description = "Generated private SSH key (only populated if auto-generated key was used)"
  value       = module.virtual_machine.tls_private_key_pem
  sensitive   = true
}
