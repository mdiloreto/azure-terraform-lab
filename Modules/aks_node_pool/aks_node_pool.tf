resource "azurerm_kubernetes_cluster_node_pool " "name" {
  name                  = var.node_pool_name
  kubernetes_cluster_id = var.cluster_id
  vm_size               = var.vm_size
  node_count            = var.node_count

  tags = var.tags
}