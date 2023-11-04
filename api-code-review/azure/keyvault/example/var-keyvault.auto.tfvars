key_vaults = {
  "key1" = {
    key_vault_name  = "iac-lab-kv-001"              #(Required) Specifies the name of the Key Vault.
    resource_group_name = "iac-lab-rg01"                   #(Required) The name of the resource group in which to create the Key Vault.
    enable_rbac_authorization       = true          # (Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions.
    enabled_for_deployment          = true          # (Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.
    enabled_for_disk_encryption     = true          # (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.
    enabled_for_template_deployment = false         #  (Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault.
    purge_protection_enabled   = true              # (Optional) Is Purge Protection enabled for this Key Vault?
    sku_name                   = "standard"         # (Required) The Name of the SKU used for this Key Vault as a standard.
    soft_delete_retention_days = 7                  # (Optional) Soft delete retention days
    additional_tags = {                             # (Optional) Additional tags if required.
      env = "IAC"
    }
    network_acls = {                                # (Optional) Network ACLs block
      bypass                     = "AzureServices"  # (Required) Specifies which traffic can bypass the network rules and the values is AzureServices  
      default_action             = "Allow"          # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. here value is Allow .
      ip_rules                   = []               # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
      virtual_network_subnet_ids = []               # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
    }
  }
}

role_assign = {
  key1 = {
    key_vault_name = "iac-lab-kv-001"
    service_principal_names = null
    user_names = ["test@ydvyuvigmail.onmicrosoft.com", "primstr@ydvyuvigmail.onmicrosoft.com"]
    group_names = ["testg"]
    role_definition_name = "Key Vault Crypto User"
  }
}

access_policies = {
  key1 = {
    key_vault_name = "iac-lab-kv-001"
    service_principal_names = null
    user_names = ["test@ydvyuvigmail.onmicrosoft.com", "primstr@ydvyuvigmail.onmicrosoft.com"]
    group_names = ["testg"]
    key_permissions = ["List"]
    secret_permissions = ["List"]
    certificate_permissions = ["List"]
    storage_permissions = ["List"]
  }
}