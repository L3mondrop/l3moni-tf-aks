# Configure the Azure Provider
provider "azurerm" {
  # new stuff for ISV attribution
  #partner_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  features {}
}

resource "azurerm_storage_account" "example" {
  name                      = "${var.prefix}k8sstorage"
  resource_group_name       = azurerm_resource_group.example.name
  location                  = azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
}

resource "azurerm_storage_container" "example" {
  name                      = var.tfstatename
  storage_account_name      = azurerm_storage_account.example.name
}