# VM names
output "vm_names" {
  description = "List of VM names"
  value       = azurerm_linux_virtual_machine.vm[*].name
}

# VM Public IPs
output "vm_public_ips" {
  description = "List of VM Public IP addresses"
  value       = azurerm_public_ip.vm_pip[*].ip_address
}

# VM Private IPs
output "vm_private_ips" {
  description = "List of VM Private IP addresses"
  value       = azurerm_network_interface.vm_nic[*].private_ip_address
}
