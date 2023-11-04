data "azurerm_resource_group" "this" {
  for_each = local.linux_vms
  name     = each.value.resource_group_name
}

data "azurerm_resource_group" "as" {
  for_each = local.availability_sets
  name     = each.value.resource_group_name
}

data "azurerm_client_config" "current" {}

locals {

  network_interfaces = { for nic_k, nic_v in var.network_interfaces : nic_v["name"] => nic_v }

  nic_ip_configs = merge([
    for nic_k, nic_v in local.network_interfaces : {
      for ip_config_index, ip_config_value in nic_v["ip_configurations"] : "${nic_k}_${ip_config_index}" => ip_config_value
    }
  ]...)

  nic_ip_configs_with_public_ip = { for ip_config_k, ip_config_v in local.nic_ip_configs : ip_config_k => ip_config_v if lookup(ip_config_v, "public_ip_name", null) != null }

  nic_ip_configs_with_subnet = { for ip_config_k, ip_config_v in local.nic_ip_configs : ip_config_k => ip_config_v if lookup(ip_config_v, "subnet_name", null) != null }

  availability_sets = { for set_k, set_v in var.availability_sets : set_v["name"] => set_v }

  linux_vms = { for vm_k, vm_v in var.linux_vms : vm_v["name"] => vm_v }

  nic_vm = merge([
    for vm_k, vm_v in var.linux_vms : {
      for nic in vm_v.network_interface_names : nic => vm_v.name
    }
  ]...)

}

data "azurerm_key_vault" "this" {
  for_each            = local.linux_vms
  name                = each.value["key_vault_name"]
  resource_group_name = each.value["key_vault_resource_group_name"]
}

data "azurerm_subnet" "this" {
  for_each             = local.nic_ip_configs_with_subnet
  name                 = each.value["subnet_name"]
  resource_group_name  = each.value["vnet_resource_group_name"]
  virtual_network_name = each.value["vnet_name"]
}

data "azurerm_public_ip" "this" {
  for_each            = local.nic_ip_configs_with_public_ip
  name                = each.value["public_ip_name"]
  resource_group_name = lookup(each.value, "public_ip_rg_name", null) != null ? lookup(each.value, "public_ip_rg_name") : data.azurerm_resource_group.this[local.nic_vm[element(split("_",each.key), 0)]].name
}

resource "azurerm_network_interface" "this" {
  for_each            = local.network_interfaces
  name                = each.value["name"]
  location            = lookup(local.linux_vms[local.nic_vm[each.key]] , "location", null) != null ? lookup(local.linux_vms[local.nic_vm[each.key]], "location", null) : data.azurerm_resource_group.this[local.nic_vm[each.key]].location
  resource_group_name = data.azurerm_resource_group.this[local.nic_vm[each.key]].name
  dynamic "ip_configuration" {
    for_each = { for ip_config_k, ip_config_v in each.value["ip_configurations"] : ip_config_k => ip_config_v }
    content {
      name                          = ip_configuration.value["name"]
      private_ip_address_allocation = lookup(ip_configuration.value, "private_ip_address", null) != null ? "Static" : coalesce(lookup(ip_configuration.value, "private_ip_address_allocation", null), "Dynamic")
      subnet_id                     = try(data.azurerm_subnet.this["${each.key}_${ip_configuration.key}"].id, null)
      private_ip_address_version    = lookup(ip_configuration.value, "private_ip_address_version", null)
      public_ip_address_id          = lookup(ip_configuration.value, "public_ip_name", null) != null ? data.azurerm_public_ip.this["${each.key}_${ip_configuration.key}"].id : null
      primary                       = tonumber(ip_configuration.key) == 0 ? true : false
      private_ip_address            = lookup(ip_configuration.value, "private_ip_address", null)
    }
  }
  dns_servers                   = coalesce(lookup(each.value, "dns_servers", null), [])
  enable_ip_forwarding          = lookup(each.value, "enable_ip_forwarding", null)
  enable_accelerated_networking = lookup(each.value, "enable_accelerated_networking", null)
  internal_dns_name_label       = lookup(each.value, "internal_dns_name_label", null)
  tags                          = merge(data.azurerm_resource_group.this[local.nic_vm[each.key]].tags, lookup(local.linux_vms[local.nic_vm[each.key]], "additional_tags", null))
}

resource "azurerm_availability_set" "this" {
  for_each                     = local.availability_sets
  name                         = each.value["name"]
  location                     = lookup(each.value, "location", null) != null? lookup(each.value, "location", null) : data.azurerm_resource_group.as[each.key].location
  resource_group_name          = each.value.resource_group_name
  platform_fault_domain_count  = lookup(each.value, "platform_fault_domain_count", null)
  platform_update_domain_count = lookup(each.value, "platform_update_domain_count", null)
  proximity_placement_group_id = lookup(each.value, "proximity_placement_group_id", null)
  managed                      = lookup(each.value, "managed", null)
  tags                         = merge(data.azurerm_resource_group.as[each.key].tags, lookup(each.value, "additional_tags", null))
}

locals {

  linux_vms_with_os_disk_encryption = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "os_disk_encryption_set_name", null) != null }

  linux_vms_with_availability-set = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "availability_set_name", null) != null }

  linux_vms_with_vmss = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "vm_scale_set_name", null) != null }
}


data "azurerm_disk_encryption_set" "this" {
  for_each            = local.linux_vms_with_os_disk_encryption
  name                = each.value["os_disk_encryption_set_name"]
  resource_group_name = lookup(each.value, "os_disk_encryption_set_rg_name", null ) != null ? lookup(each.value, "os_disk_encryption_set_rg_name", null) : each.value["resource_group_name"]
}

data "azurerm_availability_set" "this" {
  for_each            = local.linux_vms_with_availability-set
  name                = each.value["availability_set_name"]
  resource_group_name = lookup(each.value, "availability_set_rg_name", null ) != null ? lookup(each.value, "availability_set_rg_name", null) : each.value["resource_group_name"]
  depends_on          = [azurerm_availability_set.this]
}

data "azurerm_virtual_machine_scale_set" "this" {
  for_each            = local.linux_vms_with_vmss
  name                = each.value["vm_scale_set_name"]
  resource_group_name = lookup(each.value, "vm_scale_set_rg_name", null ) != null ? lookup(each.value, "vm_scale_set_rg_name", null) : each.value["resource_group_name"]
}

data "azurerm_storage_account" "diagnostics_storage_account" {
  for_each            = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "diagnostics_sa_name", null) != null }
  name                = each.value["diagnostics_sa_name"]
  resource_group_name = lookup(each.value, "diagnostics_sa_rg_name", null ) != null ? lookup(each.value, "diagnostics_sa_rg_name", null) : each.value["resource_group_name"]
}

resource "random_password" "this" {
  for_each         = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if !(anytrue([coalesce(lookup(vm_v, "disable_password_authentication", null), true), var.default_password != null])) }
  length           = 12
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
  numeric          = true
  special          = true
  override_special = "!#$%'()*+,-./:;=?@[]^_`{|}~"
}

resource "azurerm_key_vault_secret" "password" {
  for_each        = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if !(coalesce(lookup(vm_v, "disable_password_authentication", null), true)) }
  name            = lookup(each.value, "admin_password_secret_name", null) != null ? lookup(each.value, "admin_password_secret_name", null) : "${each.key}-password"
  value           = var.default_password != null ? var.default_password : lookup(lookup(random_password.this, each.key, {}), "result", null)
  key_vault_id    = data.azurerm_key_vault.this[each.key].id
  content_type    = "Password"
  not_before_date = lookup(each.value, "secret_not_before_date", null) != null ? lookup(each.value, "secret_not_before_date", null) : timestamp()
  expiration_date = lookup(each.value, "secret_expiration_date", null) != null ? lookup(each.value, "secret_expiration_date", null) : timeadd(timestamp(), "8760h")
  tags            = merge(data.azurerm_resource_group.this[each.key].tags, lookup(each.value, "additional_tags", null))

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_key_vault_secret" "username" {
  for_each        = local.linux_vms
  name            = lookup(each.value, "admin_username_secret_name", null) != null ? lookup(each.value, "admin_username_secret_name", null) : "${each.key}-username"
  value           = each.value["admin_username"]
  key_vault_id    = data.azurerm_key_vault.this[each.key].id
  content_type    = "Username"
  not_before_date = lookup(each.value, "secret_not_before_date", null) != null ? lookup(each.value, "secret_not_before_date", null) : timestamp()
  expiration_date = lookup(each.value, "secret_expiration_date", null) != null ? lookup(each.value, "secret_expiration_date", null) : timeadd(timestamp(), "8760h")
  tags            = merge(data.azurerm_resource_group.this[each.key].tags, lookup(each.value, "additional_tags", null))

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tls_private_key" "this" {
  for_each  = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if coalesce(lookup(vm_v, "disable_password_authentication", null), true) }
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_key_vault_secret" "ssh_key" {
  for_each        = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if coalesce(lookup(vm_v, "disable_password_authentication", null), true) }
  name            = lookup(each.value, "ssh_private_key_secret_name", null) != null ? lookup(each.value, "ssh_private_key_secret_name", null) : "${each.key}-private-ssh-key"
  value           = lookup(tls_private_key.this, each.key)["private_key_pem"]
  key_vault_id    = data.azurerm_key_vault.this[each.key].id
  content_type    = "PrivateKey"
  not_before_date = lookup(each.value, "secret_not_before_date", null) != null ? lookup(each.value, "secret_not_before_date", null) : timestamp()
  expiration_date = lookup(each.value, "secret_expiration_date", null) != null ? lookup(each.value, "secret_expiration_date", null) : timeadd(timestamp(), "8760h")
  tags            = merge(data.azurerm_resource_group.this[each.key].tags, lookup(each.value, "additional_tags", null))

  lifecycle {
    ignore_changes = [value]
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  for_each                        = local.linux_vms
  name                            = each.value["name"]
  admin_username                  = each.value["admin_username"]
  size                            = each.value["size"]
  location                        = lookup(each.value, "location", null) != null ? lookup(each.value, "location", null) : data.azurerm_resource_group.this[each.key].location
  resource_group_name             = each.value["resource_group_name"]
  disable_password_authentication = coalesce(lookup(each.value, "disable_password_authentication", null), true)
  admin_password                  = coalesce(lookup(each.value, "disable_password_authentication", null), true) ? null : (var.default_password != null ? var.default_password : lookup(lookup(random_password.this, each.key, {}), "result", null))
  computer_name                   = lookup(each.value, "computer_name", null)
  custom_data                     = lookup(each.value, "custom_data_path", null) == null ? null : (base64encode(templatefile(abspath("${path.root}/${each.value["custom_data_path"]}"), lookup(each.value, "custom_data_args", null) != null ? each.value["custom_data_args"] : {})))
  user_data                       = lookup(each.value, "user_data", null) != null ? base64encode(each.value["user_data"]) : null
  source_image_id                 = lookup(each.value, "source_image_id", null) != null ? each.value["source_image_id"] : null
  network_interface_ids           = [for nic in each.value.network_interface_names : azurerm_network_interface.this[nic].id]
  os_disk {
    name                      = lookup(each.value, "os_disk_name", null)
    caching                   = coalesce(lookup(each.value, "os_disk_caching", null), "None")
    storage_account_type      = each.value["os_disk_storage_account_type"]
    disk_encryption_set_id    = lookup(each.value, "os_disk_encryption_set_name", null) != null ? data.azurerm_disk_encryption_set.this[each.key].id : null
    disk_size_gb              = lookup(each.value, "os_disk_size_gb", null)
    write_accelerator_enabled = lookup(each.value, "os_disk_write_accelerator_enabled", null)
  }

  dynamic "admin_ssh_key" {
    for_each = coalesce(lookup(each.value, "disable_password_authentication", null), true) ? [lookup(each.value, "admin_username", null)] : []
    content {
      username   = lookup(each.value, "admin_username", null)
      public_key = lookup(tls_private_key.this, each.key)["public_key_openssh"]
    }
  }

  dynamic "source_image_reference" {
    for_each = lookup(each.value, "source_image_id", null) == null ? (lookup(each.value, "source_image_publisher", null) != null ? [each.value["source_image_publisher"]] : []) : []
    content {
      publisher = lookup(each.value, "source_image_publisher", null)
      offer     = lookup(each.value, "source_image_offer", null)
      sku       = lookup(each.value, "source_image_sku", null)
      version   = lookup(each.value, "source_image_version", null)
    }
  }

  availability_set_id = lookup(each.value, "availability_set_name", null) != null ? data.azurerm_availability_set.this[each.key].id : null

  zone = alltrue([
    lookup(each.value, "availability_set_name", null) == null,
    lookup(each.value, "zone", null) != null
  ]) ? each.value["zone"] : null

  virtual_machine_scale_set_id = alltrue([
    lookup(each.value, "availability_set_name", null) == null,
    lookup(each.value, "zone", null) == null,
    lookup(each.value, "vm_scale_set_name", null) != null
  ]) ? data.azurerm_virtual_machine_scale_set.this[each.key].id : null


  boot_diagnostics {
    storage_account_uri = lookup(each.value, "diagnostics_sa_name", null) != null ? data.azurerm_storage_account.diagnostics_storage_account[each.key].primary_blob_endpoint : null
  }

  dynamic "identity" {
    for_each = lookup(each.value, "identity_type", null) != null ? [1] : []
    content {
      type = each.value["identity_type"]
      identity_ids = contains(
        ["UserAssigned", "SystemAssigned, UserAssigned", "SystemAssigned,UserAssigned"],
        lookup(each.value, "identity_type", null)
      ) ? each.value["identity_ids"] : null
    }
  }


  tags       = merge(data.azurerm_resource_group.this[each.key].tags, lookup(each.value, "additional_tags", null))
  depends_on = [azurerm_network_interface.this, azurerm_availability_set.this]

  lifecycle {
    ignore_changes = [network_interface_ids]
  }
}


locals {

  linux_vms_with_nsg = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "network_security_group_name", null) != null }

  linux_vms_with_asg = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "application_security_group_name", null) != null }

  linux_vms_with_app_gw = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "app_gateway_name", null) != null }

  linux_vms_with_lb = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "load_balancer_name", null) != null }

  linux_vms_with_lb_nat_rule = { for vm_k, vm_v in local.linux_vms_with_lb : vm_k => vm_v if lookup(vm_v, "load_balancer_nat_rule_name", null) != null }

}

data "azurerm_network_security_group" "this" {
  for_each            = local.linux_vms_with_nsg
  name                = each.value["network_security_group_name"]
  resource_group_name = each.value["resource_group_name"]
}

resource "azurerm_network_interface_security_group_association" "this" {
  for_each                  = local.linux_vms_with_nsg
  network_interface_id      = azurerm_network_interface.this[each.value.network_interface_names.0]
  network_security_group_id = data.azurerm_network_security_group.this[each.key].id
  depends_on                = [azurerm_network_interface.this]
}

data "azurerm_application_security_group" "this" {
  for_each            = local.linux_vms_with_asg
  name                = each.value["application_security_group_name"]
  resource_group_name = each.value["resource_group_name"]
}

resource "azurerm_network_interface_application_security_group_association" "this" {
  for_each                      = local.linux_vms_with_asg
  network_interface_id          = azurerm_network_interface.this[each.value.network_interface_names.0].id
  application_security_group_id = data.azurerm_application_security_group.this[each.key].id
  depends_on                    = [azurerm_network_interface.this]
}

data "azurerm_application_gateway" "this" {
  for_each            = local.linux_vms_with_app_gw
  name                = each.value["app_gateway_name"]
  resource_group_name = lookup(each.value, "app_gateway_rg_name", null ) != null ? lookup(each.value, "app_gateway_rg_name", null) : each.value["resource_group_name"]
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "this" {
  for_each                = local.linux_vms_with_app_gw
  network_interface_id    = azurerm_network_interface.this[each.value.network_interface_names.0]["id"]
  ip_configuration_name   = azurerm_network_interface.this[each.value.network_interface_names.0].ip_configuration[0]["name"]
  backend_address_pool_id = "${data.azurerm_application_gateway.this[each.key].id}/backendAddressPools/${each.value["app_gateway_backend_pool_name"]}"
  depends_on              = [azurerm_network_interface.this]
}

data "azurerm_lb" "this" {
  for_each            = local.linux_vms_with_lb
  name                = each.value["load_balancer_name"]
  resource_group_name = lookup(each.value, "load_balancer_rg_name", null ) != null ? lookup(each.value, "load_balancer_rg_name", null) : each.value["resource_group_name"]
}

data "azurerm_lb_backend_address_pool" "this" {
  for_each        = local.linux_vms_with_lb
  loadbalancer_id = data.azurerm_lb.this[each.key].id
  name            = each.value["load_balancer_backend_pool_name"]
}

resource "azurerm_network_interface_backend_address_pool_association" "this" {
  for_each                = local.linux_vms_with_lb
  network_interface_id    = azurerm_network_interface.this[each.value.network_interface_names.0]["id"]
  ip_configuration_name   = azurerm_network_interface.this[each.value.network_interface_names.0].ip_configuration[0]["name"]
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.this[each.key].id
  depends_on              = [azurerm_network_interface.this]
}

resource "azurerm_network_interface_nat_rule_association" "this" {
  for_each              = local.linux_vms_with_lb_nat_rule
  network_interface_id  = azurerm_network_interface.this[each.value.network_interface_names.0]["id"]
  ip_configuration_name = azurerm_network_interface.this[each.value.network_interface_names.0].ip_configuration[0]["name"]
  nat_rule_id           = "${data.azurerm_lb.this[each.key].id}/inboundNatRules/${each.value["load_balancer_nat_rule_name"]}"
  depends_on            = [azurerm_network_interface.this]
}

locals {
  linux_vms_with_recovery_backup = { for vm_k, vm_v in local.linux_vms : vm_k => vm_v if lookup(vm_v, "recovery_service_vault_name", null) != null }
}

data "azurerm_backup_policy_vm" "this" {
  for_each            = local.linux_vms_with_recovery_backup
  name                = each.value["backup_policy_name"]
  recovery_vault_name = each.value["recovery_service_vault_name"]
  resource_group_name = lookup(each.value, "recovery_service_vault_rg_name", null ) != null ? lookup(each.value, "recovery_service_vault_rg_name", null) : each.value["resource_group_name"]
}

resource "azurerm_backup_protected_vm" "this" {
  for_each            = local.linux_vms_with_recovery_backup
  resource_group_name = lookup(each.value, "recovery_service_vault_rg_name", null ) != null ? lookup(each.value, "recovery_service_vault_rg_name", null) : each.value["resource_group_name"]
  recovery_vault_name = each.value["recovery_service_vault_name"]
  source_vm_id        = azurerm_linux_virtual_machine.this[each.key].id
  backup_policy_id    = data.azurerm_backup_policy_vm.this[each.key].id

  timeouts {
    create = "10m"
    update = "5m"
    delete = "5m"
  }

  depends_on = [azurerm_linux_virtual_machine.this]
}

locals {
  attach_managed_disks = { for disk_k, disk_v in var.attach_managed_disks : disk_v["managed_data_disk_name"] => merge(disk_v, { disk_index = disk_k }) }
}

data "azurerm_managed_disk" "this" {
  for_each            = local.attach_managed_disks
  name                = each.value["managed_data_disk_name"]
  resource_group_name = lookup(each.value, "managed_data_disk_rg_name", null ) != null ? lookup(each.value, "managed_data_disk_rg_name", null) : local.linux_vms[each.value.virtual_machine_name].resource_group_name
}


resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each                  = local.attach_managed_disks
  managed_disk_id           = data.azurerm_managed_disk.this[each.key].id
  virtual_machine_id        = azurerm_linux_virtual_machine.this[each.value["virtual_machine_name"]].id
  lun                       = coalesce(lookup(each.value, "lun", null), each.value["disk_index"])
  caching                   = coalesce(lookup(each.value, "caching", null), "None")
  create_option             = "Attach"
  write_accelerator_enabled = lookup(each.value, "write_accelerator_enabled", null)
  depends_on                = [azurerm_linux_virtual_machine.this]
}

locals {

  disk_init_args = {
    for disk_init_args_k, disk_init_args_v in var.disk_init: disk_init_args_v["virtual_machine_name"] => [
      for partition_k, partition_v in coalesce(lookup(disk_init_args_v, "partitions", null ), []): format("lun=%s,size=%s,mount=%s", partition_v["lun"], partition_v["size"], partition_v["mount"])
  ]
  }

  disk_init = {
    for disk_init_k, disk_init_v in var.disk_init: disk_init_v["virtual_machine_name"] => {
      vm_name = disk_init_v["virtual_machine_name"]
      re_run  = coalesce(lookup(disk_init_v, "re_run_disk_init", null), false)
  } if coalesce(lookup(disk_init_v, "partitions", null ), []) != []
  }

}

resource "random_integer" "disk_init" {
  for_each = { for disk_init_k, disk_init_v in local.disk_init : disk_init_k => disk_init_v if disk_init_v["re_run"] }
  min      = 1
  max      = 500000
  keepers = {
    first = timestamp()
  }
}

resource "azurerm_virtual_machine_extension" "disk_init" {
  for_each             = local.disk_init
  name                 = "vm-disk-init-ext"
  virtual_machine_id   = azurerm_linux_virtual_machine.this[each.key].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = jsonencode(
    {
      script = base64encode(templatefile(abspath("${path.module}/DiskInit.sh"), { disk_init_args = join(" ", local.disk_init_args[each.key]) }))
    }
  )

  settings = jsonencode(
    {
      timestamp = coalesce(lookup(each.value, "re_run", null), false) ? random_integer.disk_init[each.key].result : 0
    }
  )

  tags       = azurerm_linux_virtual_machine.this[each.key].tags
  depends_on = [azurerm_linux_virtual_machine.this, azurerm_virtual_machine_data_disk_attachment.this]

}