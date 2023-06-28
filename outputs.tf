output "vm_id" {
  value = "virtual_machine_id"
}

output "vm_ip_address" {
  value = "private_ip_address"
}

output "vm_public_ip" {
  value = "public_ip_address"
}

output "resource_group_name" {
  value = azurerm_resource_group.rg1.name
}