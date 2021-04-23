provider "azurerm" {
  #partner_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  features {}
}

terraform {
  backend "azurerm" {

  }
}

// Creating a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-k8s-rg"
  location = var.location

    tags = {
    "Delete" = "delayed"
    "Prefix" = var.prefix
  }
}

resource "azurerm_log_analytics_workspace" "analyticsws" {
  name =  "${var.prefix}-log-analytics-ws"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Free"
  retention_in_days = 7
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  // node_resource_group will allow you to have own naming convention for the node rg
  // it does not have automatic tagging though
  node_resource_group = "${azurerm_resource_group.rg.name}-noderg"
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

// "SystemAssigned" = "managed identity"
  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.analyticsws.id
    }
  }
}