vm_count       = 3
vm_name_prefix = "appserver"
location       = "East US"
vm_size        = "Standard_B1ms"
admin_username = "vj360p"          # ✅ Required for login
# admin_password comes from Key Vault (VMPassword secret)
environment    = "qa"
owner          = "vikas.jadhav"
key_vault_name = "kv-cloudinfra1232"
