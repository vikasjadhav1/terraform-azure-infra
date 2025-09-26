# -----------------------
# Fetch Key Vault secret
# -----------------------
data "azurerm_key_vault" "kv" {
  name                = "kv-cloudinfra1232"      # Replace if needed
  resource_group_name = "rg-infra-terraform" # Key Vault RG
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = "VMPassword"
  key_vault_id = data.azurerm_key_vault.kv.id
}

# -----------------------
# Resource Group
# -----------------------
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}-cloudinfra"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "CloudInfra"
    Owner       = var.owner
  }
}

# -----------------------
# Virtual Network
# -----------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environment}-cloudinfra"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

# -----------------------
# Subnet
# -----------------------
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-${var.environment}-cloudinfra"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# -----------------------
# VM Module
# -----------------------
module "vm" {
  source              = "./modules/vm"
  vm_count            = var.vm_count
  vm_name_prefix      = var.vm_name_prefix
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id
  vm_size             = var.vm_size
  admin_username      = var.admin_username

  # Securely pass from Key Vault
  admin_password      = data.azurerm_key_vault_secret.vm_password.value

  environment         = var.environment
  owner               = var.owner
}
