## NOTE: Read all given instructions before updating the values to get the resources created in first run.


module "key_vault" {
  source      = "../"
  key_vaults  = var.key_vaults
  role_assign = var.role_assign
}