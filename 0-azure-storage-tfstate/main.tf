# Configure the Azure Provider
provider "azurerm" {
  # new stuff for ISV attribution
  #partner_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name                      = "delete-rg"
  location                  = var.location
}

resource "azurerm_storage_account" "s_account" {
  name                      = "${var.prefix}statestorage"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
}

resource "azurerm_storage_container" "s_container" {
  name                      = var.tfstatename
  storage_account_name      = azurerm_storage_account.s_account.name
}