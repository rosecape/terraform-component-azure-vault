output "key_vault_uri" {
  value = azurerm_key_vault.core.vault_uri
}

output "key_vault_name" {
  value = azurerm_key_vault.core.name
}
