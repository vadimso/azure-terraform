output "resource_group_name" {
  value = azurerm_resource_group.rg1.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet1
}

output "storage_account_name" {
  value = azurerm_storage_account.sg
  sensitive = true
}
