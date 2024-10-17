data "azurerm_client_config" "current" {}

resource "azuread_group" "vault_users_admin" {
  display_name     = "rosecape-vault-users-admin"
  security_enabled = true
}

resource "azuread_group" "vault_service_principals_admin" {
  display_name     = "rosecape-vault-service-principals-admin"
  security_enabled = true
}

resource "azuread_group" "vault_users_read_only" {
  display_name     = "rosecape-vault-users-read-only"
  security_enabled = true
}

resource "azuread_group" "vault_users_full_access" {
  display_name     = "rosecape-vault-users-full-access"
  security_enabled = true
}

resource "azuread_group" "vault_service_principals_read_only" {
  display_name     = "rosecape-vault-service-principals-read-only"
  security_enabled = true
}

resource "azuread_group" "vault_service_principals_full_access" {
  display_name     = "rosecape-vault-service-principals-full-access"
  security_enabled = true
}

data "azuread_user" "admin_users" {
  for_each            = toset(var.admin_users)
  user_principal_name = each.key
}

data "azuread_user" "read_only_users" {
  for_each            = toset(var.read_only_users)
  user_principal_name = each.key
}

data "azuread_user" "full_access_users" {
  for_each            = toset(var.full_access_users)
  user_principal_name = each.key
}

data "azuread_service_principal" "admin_service_principals" {
  for_each     = toset(var.admin_service_principals)
  display_name = each.key
}

data "azuread_service_principal" "read_only_service_principals" {
  for_each     = toset(var.read_only_service_principals)
  display_name = each.key
}

data "azuread_service_principal" "full_access_service_principals" {
  for_each     = toset(var.full_access_service_principals)
  display_name = each.key
}

resource "azuread_group_member" "vault_users_admin_membership" {
  for_each = toset(var.admin_users)

  group_object_id  = azuread_group.vault_users_admin.object_id
  member_object_id = data.azuread_user.admin_users[each.key].object_id
}

resource "azuread_group_member" "vault_users_read_only_membership" {
  for_each = toset(var.read_only_users)

  group_object_id  = azuread_group.vault_users_read_only.object_id
  member_object_id = data.azuread_user.read_only_users[each.key].object_id
}

resource "azuread_group_member" "vault_users_full_access_membership" {
  for_each = toset(var.full_access_users)

  group_object_id  = azuread_group.vault_users_full_access.object_id
  member_object_id = data.azuread_user.full_access_users[each.key].object_id
}

resource "azuread_group_member" "vault_service_principals_admin_membership" {
  for_each = toset(var.admin_service_principals)

  group_object_id  = azuread_group.vault_service_principals_admin.object_id
  member_object_id = data.azuread_service_principal.admin_service_principals[each.key].object_id
}

resource "azuread_group_member" "vault_service_principals_read_only_membership" {
  for_each = toset(var.read_only_service_principals)

  group_object_id  = azuread_group.vault_service_principals_read_only.object_id
  member_object_id = data.azuread_service_principal.read_only_service_principals[each.key].object_id
}

resource "azuread_group_member" "vault_service_principals_full_access_membership" {
  for_each = toset(var.full_access_service_principals)

  group_object_id  = azuread_group.vault_service_principals_full_access.object_id
  member_object_id = data.azuread_service_principal.full_access_service_principals[each.key].object_id
}

resource "azurerm_role_assignment" "rbac_keyvault_read_only" {
  for_each = {
    vault_users_read_only              = azuread_group.vault_users_read_only.object_id
    vault_service_principals_read_only = azuread_group.vault_service_principals_read_only.object_id
  }

  scope                = azurerm_key_vault.core.id
  role_definition_name = "Key Vault Reader"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "rbac_keyvault_full_access" {
  for_each = {
    vault_users_full_access              = azuread_group.vault_users_full_access.object_id
    vault_service_principals_full_access = azuread_group.vault_service_principals_full_access.object_id
  }

  scope                = azurerm_key_vault.core.id
  role_definition_name = "Key Vault Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "rbac_keyvault_admin" {
  for_each = {
    vault_users_admin              = azuread_group.vault_users_admin.object_id
    vault_service_principals_admin = azuread_group.vault_service_principals_admin.object_id
  }

  scope                = azurerm_key_vault.core.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = each.value
}

resource "azurerm_key_vault" "core" {
  name                        = var.key_vault_name
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"

  timeouts {
    delete = "5m"
  }
}
