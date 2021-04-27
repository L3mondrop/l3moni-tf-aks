output "id" {
  value = azurerm_kubernetes_cluster.cluster.id
}

output "kube_config" {
  sensitive = true
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}

output "client_key" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate
}

output "host" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.host
}

output "cluster_resource_group" {
  value = azurerm_kubernetes_cluster.cluster.resource_group_name
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.cluster.name
}
  
