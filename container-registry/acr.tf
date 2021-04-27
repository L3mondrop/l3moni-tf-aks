provider "azurerm" {
  #partner_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  features {}
}

terraform {
  backend "azurerm" {

  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-acr-rg"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                     = "${var.prefix}-acr"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Basic"
  admin_enabled            = false
  // (premium SKU only) georeplication_locations = ["East US", "West Europe"] 
}