output "key1" {
  sensitive = true
  value = azurerm_storage_account.s_account.primary_access_key
}

output "storage_account_name" {
    value = azurerm_storage_account.s_account.name
}

output "storage_account_rg" {
    value = azurerm_resource_group.rg.name
}

output "simpleprefix" {
  value = var.simpleprefix
}

output "environment" {
  value = var.environment 
}