## NOTE: Read all given instructions before updating the values to get the resources created in first run.

subnets = {
  subnet1 = {
    subnet_name                 = "iac-lab-snet1" # Value for Subnets
    vnet_name                   = "iac-lab-vnet1"
    resource_group_name         = "iac-lab-rg01"                             # (Required) Name of virtual network in which subnet is to be created
    address_prefixes            = ["10.70.0.0/28"]                            # (Required) The address prefix to use for subnet
    service_endpoints           = null# (Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web
    service_endpoint_policy_ids = null                                         # (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
    pe_enable                   = true                                         # (Optional) Enable or Disable network policies for the private link endpoint on the subnet.Default value is false.
    pes_enable                  = false                                        # (Optional) Enable or Disable network policies for the private link service on the subnet.Default value is false.
    delegation = [{                                                             # (Optional) The block of delagation 
      name = "delename"                                                        # (Required) A name for this delegation.
      service_delegation = [{                                                  # (Required) The list of service delegation block.
        name    = "Microsoft.ApiManagement/service"                            # (Required) The name of service to delegate to. 
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]         # (Optional) A list of Actions which should be delegated.
      }]
    }]
  }
}