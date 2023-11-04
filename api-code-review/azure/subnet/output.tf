output "subnet_ids" {
  value       = { for x in azurerm_subnet.this : x.name => x.id }
  description = "Subnet names and there respective resource IDs"
}