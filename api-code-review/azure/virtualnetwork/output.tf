output "vnet_ids" {
  value       = { for name, vnet in azurerm_virtual_network.this : name => vnet.id }
  description = "Virtual network names and there respective resource IDs"
}