variable "key_vaults" {
  type = map(object({
    key_vault_name                  = string
    resource_group_name             = string
    enabled_for_deployment          = optional(bool,false)
    enabled_for_disk_encryption     = optional(bool,false)
    enabled_for_template_deployment = optional(bool,false)
    enable_rbac_authorization       = optional(bool,false)
    soft_delete_retention_days      = optional(number, 7)
    purge_protection_enabled        = optional(bool, false)
    sku_name                        = string
    additional_tags                 = optional(map(string), {})
    network_acls = optional(object({
      bypass                     = string     
      default_action             = string    
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), []) 
    }), null)
  }))
  description = "Specifies values for Key Vault network access"
  default     = {}
}

variable "role_assign" {
  type = map(object({
    key_vault_name          = string
    service_principal_names = optional(list(string),null)
    user_names              = optional(list(string),null)
    group_names             = optional(list(string),null)
    role_definition_name    = string
  }))
  description = "Role assignment is key vault is using RBAC for authentication"
  default     = {}
}

variable "access_policies" {
  type = map(object({
    key_vault_name          = string
    service_principal_names = optional(list(string),null)
    user_names              = optional(list(string),null)
    group_names             = optional(list(string),null)
    key_permissions         = optional(list(string),null)
    secret_permissions      = optional(list(string),null)
    certificate_permissions = optional(list(string),null)
    storage_permissions     = optional(list(string),null)
  }))
  description = "Access policies if key vault is using policy based authentication"
  default     = {}
}