vm_count       = 3
vm_name_prefix = "appserver"
location       = "East US"
vm_size        = "Standard_B2s"
admin_username = "vj360p"          # ✅ Required for login
# admin_password comes from Key Vault (VMPassword secret)
environment    = "prod"
owner          = "vikas.jadhav"
key_vault_name = "kv-cloudinfra1232"
