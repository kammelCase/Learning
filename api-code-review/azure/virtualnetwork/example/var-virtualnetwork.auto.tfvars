## NOTE: Read all given instructions before updating the values to get the resources created in first run.

virtual_networks = {                               # Virtual Network block
  vnet1 = {                         
    vnet_name               = "iac-poc-vnet9"      # vnet name
    resource_group_name     = "iac-poc-rg-009" 
    location                = null                 # (Optional) Location in which Vnet is to be deployed. By Default will be resource group's location
    address_space           = ["10.0.0.0/16"]      # (Required) The address space that is used the virtual network. You can supply more than one address space.
    dns_servers             = null                 # (Optional) List of IP addresses of DNS servers 
    bgp_community           = null                 # (Optional) The BGP community attribute in format <as-number>:<community-value>.
    flow_timeout_in_minutes = null                 # (Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes.
    ddos_protection_plan    = null                 # One or more DDOS protection block. Attributes: id, enabled
    vnet_additional_tags = {                       # Virtual network additional tags.
      testing = "testing-complete"               # Map <input><tag_name>:<tag_value>
      OwnerName = "dhanashree.tambe"
    }
  }
}