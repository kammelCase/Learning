output "resource_group_id" {
  value       = { for x in azurerm_resource_group.this : x.name => x.id }
  description = "Resource group names and there respective IDs"
}