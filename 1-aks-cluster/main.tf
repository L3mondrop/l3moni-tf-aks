provider "azurerm" {
  #partner_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  features {}
}

// Setup remote state
/*
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "terrastatestorage2134"
    container_name       = "terraformdemo"
    key                  = "dev.terraform.tfstate"
    use_msi              = true
    #subscription_id  = "00000000-0000-0000-0000-000000000000"
    #tenant_id        = "00000000-0000-0000-0000-000000000000"
  }
}
*/

// Creating a resource group
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-k8s-rg"
  location = var.location

    tags = {
    "Delete" = "delayed"
    "Prefix" = var.prefix
  }
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  // node_resource_group will allow you to have own naming convention for the node rg
  // it does not have automatic tagging though
  node_resource_group = "${azurerm_resource_group.example.name}-noderg"
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
      enabled = false
    }
  }
}