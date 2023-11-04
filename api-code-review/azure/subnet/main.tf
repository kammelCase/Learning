
resource "azurerm_subnet" "this" {
  for_each                                       = var.subnets
  name                                           = each.value.subnet_name
  resource_group_name                            = each.value.resource_group_name
  address_prefixes                               = each.value["address_prefixes"]
  service_endpoints                              = each.value.service_endpoints 
  enforce_private_link_endpoint_network_policies = coalesce(each.value.pe_enable) 
  enforce_private_link_service_network_policies  = coalesce(each.value.pes_enable) 
  virtual_network_name                           = each.value.vnet_name 
  service_endpoint_policy_ids                    = each.value.service_endpoint_policy_ids
  dynamic "delegation" {
    for_each = coalesce(each.value.delegation)
    content {
      name = delegation.value.name
      dynamic "service_delegation" {
        for_each = coalesce(delegation.value.service_delegation)
        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }
  }
}

