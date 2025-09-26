# -----------------------
# Public IP for each VM
# -----------------------
resource "azurerm_public_ip" "vm_pip" {
  count               = var.vm_count
  name                = "${var.environment}-${var.vm_name_prefix}-pip-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"        # ✅ Standard requires Static
  sku                 = "Standard"      # ✅ Changed from Basic to Standard

  tags = {
    Environment = var.environment
    Project     = "CloudInfra"
    Owner       = var.owner
  }
}

# -----------------------
# Network Security Group
# -----------------------
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.environment}-${var.vm_name_prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  # SSH rule
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTP rule
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTPS rule
  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    Project     = "CloudInfra"
    Owner       = var.owner
  }
}

# -----------------------
# Network Interface
# -----------------------
resource "azurerm_network_interface" "vm_nic" {
  count               = var.vm_count
  name                = "${var.environment}-${var.vm_name_prefix}-nic-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip[count.index].id
  }

  tags = {
    Environment = var.environment
    Project     = "CloudInfra"
    Owner       = var.owner
  }
}

# -----------------------
# Associate NSG with NICs
# -----------------------
resource "azurerm_network_interface_security_group_association" "vm_nic_nsg" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.vm_nic[count.index].id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# -----------------------
# Virtual Machine
# -----------------------
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.environment}-${var.vm_name_prefix}-vm-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false   # ✅ allow password login

  network_interface_ids = [
    azurerm_network_interface.vm_nic[count.index].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # ✅ Correct Ubuntu 20.04 LTS (Focal) image
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  tags = {
    Environment = var.environment
    Project     = "CloudInfra"
    Owner       = var.owner
  }
}
