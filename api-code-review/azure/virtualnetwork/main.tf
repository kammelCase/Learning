locals {
  deployment = jsondecode( file( "${path.module}/deployment.json" ) )[ "deployment" ]
  deployment_name_map = { for json_object in local.deployment : json_object.vnet_name => json_object }
}  

data "azurerm_resource_group" "this" {
  for_each  = local.deployment_name_map
  name      = each.value.resource_group_name
}

resource "azurerm_virtual_network" "this" {
  ## define the iterator over the objects using the map() defined in variables.tf
  for_each                = local.deployment_name_map 
  name                    = each.value.vnet_name
  location                = each.value.location != null ? each.value.location : data.azurerm_resource_group.this[ each.key ].location
  resource_group_name     = each.value.resource_group_name
  address_space           = each.value[ "address_space" ]
  dns_servers             = each.value.dns_servers
  tags                    = merge( { for key,value in data.azurerm_resource_group.this[ each.key ].tags : key => value } )
}
