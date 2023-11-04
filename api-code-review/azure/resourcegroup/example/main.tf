## NOTE: Read all given instructions before updating the values to get the resources created in first run.

module "resource_group" {
  source          = "git::https://dev.azure.com/dmangeshtambe0819/_git/iac-azure-modules?path=/resourcegroup?ref=main"
  resource_groups = var.resource_groups
}