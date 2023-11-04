data "azurerm_resource_group" "this" {
  for_each = var.key_vaults
  name     = each.value.resource_group_name
}

data "azurerm_client_config" "current" {}

locals {
  default_network_acls = [{
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }]
}

resource "azurerm_key_vault" "this" {
  for_each                        = var.key_vaults
  name                            = each.value.key_vault_name
  resource_group_name             = each.value.resource_group_name
  location                        = data.azurerm_resource_group.this[each.key].location
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  purge_protection_enabled        = each.value.purge_protection_enabled
  enable_rbac_authorization       = each.value.enable_rbac_authorization
  sku_name                        = each.value.sku_name
  dynamic "network_acls" {
    for_each = each.value.network_acls != null ? tolist([each.value.network_acls]) : local.default_network_acls
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }
  tags = merge(each.value.additional_tags, data.azurerm_resource_group.this[each.key].tags)
}

resource "azurerm_role_assignment" "keyvault_admin" {
  for_each                = {for key, value in var.key_vaults : key => value if value.enable_rbac_authorization == true}
  scope                = azurerm_key_vault.this[each.key].id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_access_policy" "current" {
  for_each     = {for key, value in var.key_vaults : key => value if value.enable_rbac_authorization != true}
  key_vault_id = azurerm_key_vault.this[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore",
    "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge"
  ]
  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
  certificate_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts",
    "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"
  ]
  storage_permissions = [
    "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey",
    "Restore", "Set", "SetSAS", "Update"
  ]
  depends_on = [azurerm_key_vault.this]
}


locals {
  keys = {
    for key, value in var.key_vaults : value.key_vault_name => key
  }
  temp1 = values({
    for key, value in data.azuread_users.rbac : key => {
      for object_id in value.object_ids : object_id => key
    }
  })
  temp2 = values({
    for key, value in data.azuread_groups.rbac : key => {
      for object_id in value.object_ids : object_id => key
    }
  })
  temp3 = values({
    for key, value in data.azuread_service_principals.rbac : key => {
      for object_id in value.object_ids : object_id => key
    }
  })
  object_ids_rbac = merge(concat(local.temp1, local.temp2, local.temp3)...)
}

data "azuread_users" "rbac" {
  for_each             = { for key, value in var.role_assign : key => value if value.user_names != null }
  user_principal_names = each.value.user_names
}

data "azuread_groups" "rbac" {
  for_each      = { for key, value in var.role_assign : key => value if value.group_names != null }
  display_names = each.value.group_names
}

data "azuread_service_principals" "rbac" {
  for_each      = { for key, value in var.role_assign : key => value if value.service_principal_names != null }
  display_names = each.value.service_principal_names
}

resource "azurerm_role_assignment" "this" {
  for_each = local.object_ids_rbac
  scope    = azurerm_key_vault.this[local.keys[var.role_assign[each.value].key_vault_name]].id
  role_definition_name = var.role_assign[each.value].role_definition_name
  principal_id = each.key
}

locals {
  tmp1 = values({
    for key, value in data.azuread_users.this : key => {
      for object_id in value.object_ids : object_id => key
    }
  })
  tmp2 = values({
    for key, value in data.azuread_groups.this : key => {
      for object_id in value.object_ids : object_id => key
    }
  })
  tmp3 = values({
    for key, value in data.azuread_service_principals.this : key => {
      for object_id in value.object_ids : object_id => key
    }
  })
  object_ids = merge(concat(local.tmp1, local.tmp2, local.tmp3)...)
}

data "azuread_users" "this" {
  for_each             = { for key, value in var.access_policies : key => value if value.user_names != null }
  user_principal_names = each.value.user_names
}

data "azuread_groups" "this" {
  for_each      = { for key, value in var.access_policies : key => value if value.group_names != null }
  display_names = each.value.group_names
}

data "azuread_service_principals" "this" {
  for_each      = { for key, value in var.access_policies : key => value if value.service_principal_names != null }
  display_names = each.value.service_principal_names
}

resource "azurerm_key_vault_access_policy" "this" {
  for_each                = local.object_ids
  key_vault_id            = azurerm_key_vault.this[local.keys[var.access_policies[each.value].key_vault_name]].id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.key
  key_permissions         = var.access_policies[each.value].key_permissions
  secret_permissions      = var.access_policies[each.value].secret_permissions
  certificate_permissions = var.access_policies[each.value].certificate_permissions
  storage_permissions     = var.access_policies[each.value].storage_permissions
  depends_on              = [azurerm_key_vault.this]
}