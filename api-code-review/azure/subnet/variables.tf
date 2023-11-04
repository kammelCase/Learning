variable "subnets" {
  description = "The virtal networks subnets with their properties."
  type = map(object({
    subnet_name                 = string
    vnet_name                   = string
    resource_group_name         = string
    address_prefixes            = list(string)
    pe_enable                   = optional(bool, false)
    pes_enable                  = optional(bool, false)
    service_endpoints           = optional(list(string))
    service_endpoint_policy_ids = optional(list(string), null)
    delegation = optional(list(object({
      name = optional(string,null)
      service_delegation = optional(list(object({
        name    = optional(string, null)
        actions = optional(list(string), null)
      })),[])
    })),[])
  }))
  default = {}
}