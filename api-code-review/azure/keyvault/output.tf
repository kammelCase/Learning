output "keyvaults" {
  value = {
    for key, value in azurerm_key_vault.this : value.name => {
      vault_uri   = value.vault_uri
      resource_id = value.id
    }
  }
}