output "akv_client_id" {
  value = data.azurerm_user_assigned_identity.akv.client_id
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.this.id
}