output "id" {
  description = "A unique ID that can be used to identify and reference a Kubernetes cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "endpoint" {
  description = "The base URL of the API server on the Kubernetes master node"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "kube_config" {
  description = "The full contents of the Kubernetes cluster's kubeconfig file"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
}

output "cluster_ca_cert" {
  description = "The base64 encoded public certificate for the cluster's certificate authority"
  value       = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
}

output "cluster_client_key" {
  description = "The base64 encoded private key used by clients to access the cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config.0.client_key
}

output "cluster_client_certificate" {
  description = "The base64 encoded public certificate used by clients to access the cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
}
