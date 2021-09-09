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

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "external-dns" {
  metadata {
    name = "external-dns"
  }
}

variable "tenantId" { default = "" }
variable "subscriptionId" { default = ""}
variable "resourceGroup" {}

resource "helm_release" "nginx-ingress" {

  name  = "nginx-ingress"
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

  set {
    name = "publish-service"
    value = "namespace/nginx-ingress-controller-svcname"
  }

}

resource "helm_release" "cert-manager" {
  name = "cert-manager"
  chart = "jetstack/cert-manager"
  namespace = "cert-manager"
  #create_namespace = true // Created separately for graceful "destroy"
  version = "v1.3.1"

  set {
    name = "installCRDs"
    value = true
}
}

data "azurerm_client_config" "current" {}

/*
resource "kubernetes_secret" "external-dns" {

}
*/
/*
resource "helm_release" "external-dns" {
  name = "external-dns"
  chart = "bitnami/external-dns"
  namespace = "external-dns"

  set {
    name = "provider"
    value = "azure"
  }

  set {
    name = "azure.tenantId"
    value = "${data.azurerm_client_config.current.tenant_id}"
  }
  set {
    name = "azure.subscriptionId"
    value = "${data.azurerm_client_config.current.subscription_id}"
  }
  set {
    name = "azure.resourceGroup"
    value = var.resourceGroup
  }
  set {
    name = "azure.useManagedIdentityExtension"
    value = true
  }
}
*/

resource "kubernetes_deployment" "external-dns" {

  metadata {
    name = "external-dns"
    #namespace = "external-dns"
  }
  spec {
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
         "app" = "external-dns"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "external-dns"
        }
      }
      spec {
        container {
          image = "k8s.gcr.io/external-dns/external-dns:v0.7.6"
          name = "external-dns"
          args = [ "--source=service", "--source=ingress", "--domain-filter=lemoni.cloud", "--provider=azure", "--azure-resource-group=l3monitf-k8s-rg-noderg"]
          volume_mount {
            name = "azure-config-file"
            mount_path = "/etc/kubernetes"
            read_only = true
          }
          }
        volume {
          name = "azure-config-file"
          secret {
            secret_name = "azure-config-file"
          }
        }
        }
      }
    }
  }
  
  resource "kubernetes_deployment" "example-deployment" {
    metadata {
      name = "supermario"
      namespace = "default"
    }
    spec {
    selector {
      match_labels = {
         "app" = "supermario"
      }
    }
    template {
      metadata {
        labels = {
          "app" = "supermario"
        }
      }
      spec {
        container {
          image = "pengbai/docker-supermario"
          name = "supermario"
          port {
            container_port = 8080
          }
          }
        }
      }
    }
  }

  resource "kubernetes_service" "example-service" {
    metadata {
      name = "supermario-svc"
    }
    spec {
      port {
      port = 80
      protocol = "TCP"
      target_port = 8080
      }
      selector = {
        "app" = "supermario"
      }
      type = "ClusterIP"
    }
  }

  resource "kubernetes_ingress" "example-ingress" {
    wait_for_load_balancer = true
    metadata {
      name = "supermario"
      annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "external-dns.alpha.kubernetes.io/hostname" = "supermario.lemoni.cloud"
      }
    }
    spec {
      backend {
        service_name = "supermario-svc"
        service_port = 80
      }
      rule {
        host = "supermario.lemoni.cloud"
        http {
          path {
            path = "/*"
            backend {
              service_name = "supermario-svc"
              service_port = 80
            }
          }
        } 
      }
    }
  }
