variable "virtual_networks" {
  type = map(object({
    vnet_name               = string
    resource_group_name     = string
    location                = optional(string, null)
    address_space           = list(string)
    dns_servers             = optional(list(string), null)
    bgp_community           = optional(string, null)
    flow_timeout_in_minutes = optional(number, null)
    ddos_protection_plan    = optional(object({
      id     = optional(string, null)
      enable = optional(bool, false)
    }), 
    null)
    vnet_additional_tags    = optional(map(string), null)
  }))
  description = "The virtual networks with their properties."
  default     = {}
}