terraform {
  backend "azurerm" {
    resource_group_name  = "rg_terraform_state_file"
    storage_account_name = "tfstatestorage12321"
    container_name       = "tfstate"
    #key                  = "${terraform.workspace}/terraform.tfstate"
    key = "terraform.tfstate"
  }
}
