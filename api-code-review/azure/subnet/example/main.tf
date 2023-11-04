## NOTE: Read all given instructions before updating the values to get the resources created in first run.

module "subnet" {
  source      = "../"
  subnets     = var.subnets
}