# -----------------------
# VM Outputs
# -----------------------

# List of VM names
output "vm_names" {
  description = "List of VM names from the VM module"
  value       = module.vm.vm_names
}

# List of VM Public IPs
output "vm_public_ips" {
  description = "List of Public IPs for VMs from the VM module"
  value       = module.vm.vm_public_ips
}

# List of VM Private IPs
output "vm_private_ips" {
  description = "List of Private IPs for VMs from the VM module"
  value       = module.vm.vm_private_ips
}
