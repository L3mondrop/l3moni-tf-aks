provider "azurerm" {
  #partner_id = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  features {}
}

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.1.1"
    }
  }
}

provider "helm" {
  # Configuration options
    kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "ingress-basic"
  }  
}

resource "helm_release" "nginx-ingress" {

  name  = var.prefix
  chart = "ingress-nginx/ingress-nginx"
  namespace = "ingress-basic"
  #create_namespace = true // Created separately for graceful "destroy"

  set {
    name  = "controller.metrics.enabled" // Exporting Prometheus metrics
    value = "true"
  }

  set {
    name = "controller.replicaCount"
    value = 2
  }

}