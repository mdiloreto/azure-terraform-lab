data "azurerm_client_config" "current" {
}

module "dev" {
  source = "./Modules/aks_simple_cluster"

  
  # Required variables
  sto_file               = var.sto_file
  net_dns                = var.net_dns
  sto_disk               = var.sto_disk
  net_lb_sku             = var.net_lb_sku
  net_bridge             = var.net_bridge
  private_cluster_enabled = var.private_cluster_enabled
  net_outbound           = var.net_outbound
  net_plugin             = var.net_plugin
  sto_blob               = var.sto_blob
  net_policy             = var.net_policy

  net_svc_crd = var.net_svc_crd
  policy = var.policy
  local_acc = var.local_acc
  auto_scaling = var.auto_scaling
  sku = var.sku
  private_fqdn = var.private_fqdn
  http_routing = var.http_routing
  mi_name = var.mi_name
  cluster_name  = var.cluster_name
  rg_nodes      = var.rg_nodes
  private       = var.private
  upgrade       = var.upgrade
}
