provider "azurerm" {
  #partner_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-dns-rg"
  location = "West Europe"

    tags = {

    }
}

resource "azurerm_dns_zone" "example-public" {
  name                = var.dns
  resource_group_name = azurerm_resource_group.rg.name
}

/** Option for private DNS Zone
resource "azurerm_private_dns_zone" "example-private" {
  name                = var.dns
  resource_group_name = azurerm_resource_group.rg.name
}
**/