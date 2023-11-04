## NOTE: Read all given instructions before updating the values to get the resources created in first run.

module "virtual_network" {
  source           = "git::https://dev.azure.com/dmangeshtambe0819/_git/iac-azure-modules?path=/virtualnetwork?ref=main"
  virtual_networks = var.virtual_networks
  depends_on = [
    module.resource_group,
    module.ddos_protection_plan
  ]
}