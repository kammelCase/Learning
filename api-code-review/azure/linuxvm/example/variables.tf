variable "network_interfaces" {
  description = "Manages Network Interfaces."
  default     = []
  nullable    = false

  validation {
    condition = alltrue(flatten([
      for nic_k, nic_v in var.network_interfaces : [
        for ip_config in nic_v["ip_configurations"] : alltrue([
          lookup(ip_config, "vnet_name", null) != null,
          lookup(ip_config, "vnet_resource_group_name", null) != null
        ]) if lookup(ip_config, "subnet_name", null) != null
      ]
    ]))
    error_message = "The value of vnet_name and vnet_resource_group_name is required to get the subnet id."
  }
}

variable "availability_sets" {
  description = "Manages an Availability Set for Virtual Machines."
  default     = []
  nullable    = false
}

variable "linux_vms" {
  description = "Manages Linux Virtual Machines."
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for vm in var.linux_vms : !(anytrue([
        lookup(vm, "name", null) == null,
        lookup(vm, "resource_group_name", null) == null,
        lookup(vm, "admin_username", null) == null,
        lookup(vm, "key_vault_name", null) == null,
        lookup(vm, "key_vault_resource_group_name", null) == null,
        lookup(vm, "size", null) == null,
        lookup(vm, "network_interface_names", null) == null,
        lookup(vm, "os_disk_storage_account_type", null) == null,
      ]))
    ])
    error_message = "One of below required attributes is missing.\nname\nresource_group_name\nadmin_username\nkey_vault_name\nkey_vault_resource_group_name\nkey_vault_secret_name\nsize\nnetwork_interface_names\nos_disk_storage_account_type."
  }

  validation {
    condition = alltrue([
      for vm in var.linux_vms : alltrue([
        lookup(vm, "identity_ids", null) != null
        ]) if lookup(vm, "identity_type", null) != null && contains(
        ["UserAssigned", "SystemAssigned, UserAssigned"],
        coalesce(lookup(vm, "identity_type", null), "null")
      )
    ])
    error_message = "Parameter \"identity_ids\" is required if \"identity_type\" is \"UserAssigned\"."
  }

  validation {
    condition = alltrue([
      for vm in var.linux_vms : alltrue([
        lookup(vm, "app_gateway_backend_pool_name", null) != null
      ]) if lookup(vm, "app_gateway_name", null) != null
    ])
    error_message = "The value for \"app_gateway_backend_pool_name\" is required if \"app_gateway_name\" is not null."
  }

  validation {
    condition = alltrue([
      for vm in var.linux_vms : anytrue([
        lookup(vm, "load_balancer_backend_pool_name", null) != null,
        lookup(vm, "load_balancer_nat_rule_name", null) != null
      ]) if lookup(vm, "load_balancer_name", null) != null
    ])
    error_message = "The value for One of \"load_balancer_backend_pool_name\" Or \"load_balancer_nat_rule_name\" is required if \"load_balancer_name\" is not null."
  }

  validation {
    condition = alltrue([
      for vm in var.linux_vms : alltrue([
        lookup(vm, "backup_policy_name", null) != null
      ]) if lookup(vm, "recovery_service_vault_name", null) != null
    ])
    error_message = "The value for \"backup_policy_name\" is required if \"recovery_service_vault_name\" is not null."
  }
}


variable "attach_managed_disks" {
  description = "Manages data disks attachments"
  default     = []
  nullable    = false
}

variable "disk_init" {
  description = "Format and mount all the additional disks attached to the virtual machine."
  default     = []
  nullable    = false
}

variable "default_password" {
  type        = string
  default     = null
  description = "Default password to be set for all VMs"
}