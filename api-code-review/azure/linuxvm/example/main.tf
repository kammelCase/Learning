## NOTE: Read all given instructions before updating the values to get the resources created in first run.

module "linux_vm" {
  source               = "../"
  linux_vms            = var.linux_vms
  network_interfaces   = var.network_interfaces
  attach_managed_disks = var.attach_managed_disks
  disk_init            = var.disk_init
  # depends_on = [
  #   module.resource_group,
  #   module.virtual_network,
  #   module.subnet,
  #   module.public_ip,
  #   module.managed_disk,
  #   module.keyvault,
  #   module.disk_encryption_set
  # ]
}