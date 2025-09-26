# -----------------------
# VM Deployment Variables
# -----------------------

variable "vm_count" {
  type        = number
  description = "Number of VMs to create"
}

variable "vm_name_prefix" {
  type        = string
  description = "Prefix for VM names (e.g., appserver)"
}

variable "location" {
  type        = string
  description = "Azure region for deployment (e.g., East US)"
}

variable "vm_size" {
  type        = string
  description = "VM size (e.g., Standard_B1s, Standard_B2s)"
}

variable "admin_username" {
  type        = string
  description = "Admin username for the VM (e.g., azureuser)"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, qa, prod)"
}

variable "owner" {
  type        = string
  description = "Owner of the resources (e.g., your name/email)"
}

# -----------------------
# Key Vault Integration
# -----------------------
variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault to fetch the VMPassword secret"
}
