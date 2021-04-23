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

resource "helm_release" "nginx-ingress" {

  name  = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "stable/nginx-ingress"

}