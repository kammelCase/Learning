output "linux_vm_network_interfaces" {
  value       = { for nic_k, nic_v in azurerm_network_interface.this : nic_k => nic_v }
  description = "Linux VM Network Interface card names with there respective resource IDs"
}

output "linux_vm_availability_sets" {
  value       = { for set_k, set_v in azurerm_availability_set.this : set_k => set_v }
  description = "Linux VM Availability set names with there respective resource IDs"
}

output "linux_vm_ids" {
  value       = { for vm_k, vm_v in azurerm_linux_virtual_machine.this : vm_k => vm_v["id"] }
  description = "Linux VM names with there respective resource IDs"
}

output "linux_vm_managed_disk_attachment" {
  value       = { for mdd_k, mdd_v in azurerm_virtual_machine_data_disk_attachment.this : mdd_k => mdd_v }
  description = "Linux VM attached managed disk names with there respective resource IDs"
}
