terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

resource "azurerm_user_assigned_identity" "this" {
  name                = var.mi_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  tags                = var.tags
}

resource "azurerm_role_assignment" "dns" {
  scope                = var.pep_dns_id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.this.principal_id
}

resource "azurerm_kubernetes_cluster" "this" {
  automatic_channel_upgrade           = var.upgrade
  azure_policy_enabled                = var.policy
  dns_prefix                          = var.dns_prefix
  local_account_disabled              = var.local_acc
  location                            = var.rg_location
  name                                = var.cluster_name
  node_resource_group                 = var.rg_nodes
  private_cluster_enabled             = var.private
  private_cluster_public_fqdn_enabled = var.private_fqdn
  http_application_routing_enabled    = var.http_routing
  resource_group_name                 = var.rg_name
  sku_tier                            = var.sku
  kubernetes_version                  = var.aks_version
  private_dns_zone_id                 = var.pep_dns_id

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = var.adm_grp_id
    managed                = true
    tenant_id              = var.tenant_id
  }

  default_node_pool {
    enable_auto_scaling          = var.auto_scaling
    max_pods                     = var.pods_max
    max_count                    = var.pool_size.max
    min_count                    = var.pool_size.min
    name                         = var.pool_sys
    vm_size                      = var.pool_vm
    vnet_subnet_id               = var.subnet_id
    zones                        = var.pool_zone
    os_sku                       = var.pool_os
    only_critical_addons_enabled = var.pool_sys_crt
    temporary_name_for_rotation  = var.pool_sys_rot
    orchestrator_version         = var.aks_version

    tags                = var.tags
  }
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }
  key_vault_secrets_provider {
    secret_rotation_enabled = var.secret
  }
  ingress_application_gateway {          # this creates its own vnet if new AGW
  } 
  network_profile {
    dns_service_ip     = var.net_dns
    load_balancer_sku  = var.net_lb_sku
    network_plugin     = var.net_plugin
    network_policy     = var.net_policy
    outbound_type      = var.net_outbound
    service_cidr       = var.net_svc_crd
  }
  storage_profile {
    blob_driver_enabled = var.sto_blob
    disk_driver_enabled = var.sto_disk
    file_driver_enabled = var.sto_file
  }
  windows_profile {
    admin_username = var.win_user
    admin_password = var.win_pass
  }
  linux_profile {
    admin_username = var.lnx_user
    ssh_key {
      key_data = file(var.lnx_key)
    }
  }
  tags       = var.tags
  depends_on = [azurerm_role_assignment.dns]
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  name                  = var.pool_usr
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  enable_auto_scaling   = var.auto_scaling
  max_pods              = var.pods_max
	max_count             = var.pool_size.max
	min_count             = var.pool_size.min
	vm_size               = var.pool_vm
	vnet_subnet_id        = var.subnet_id
	zones                 = var.pool_zone
  os_sku                = var.pool_os
  orchestrator_version  = var.aks_version
	mode                  = "User"
  tags                  = var.tags
	depends_on            = [azurerm_kubernetes_cluster.this]
}

data "azurerm_resource_group" "nodes" {
  
  name       = azurerm_kubernetes_cluster.this.node_resource_group
  depends_on = [azurerm_kubernetes_cluster.this]
}

data "azurerm_resource_group" "aks" {
  name       = var.rg_name
  depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_role_assignment" "acr" {
  principal_id                     = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.acr_id
  skip_service_principal_aad_check = true
	depends_on = [azurerm_kubernetes_cluster.this]
}

data "azurerm_user_assigned_identity" "agw" {
  name                = "ingressapplicationgateway-${var.cluster_name}"
  resource_group_name = var.rg_nodes
  depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_role_assignment" "agw_reader" {
  principal_id                     = data.azurerm_user_assigned_identity.agw.principal_id
  role_definition_name             = "Reader"
  scope                            = data.azurerm_resource_group.aks.id
	depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_role_assignment" "agw_contributor" {

  principal_id                     = data.azurerm_user_assigned_identity.agw.principal_id
  role_definition_name             = "Contributor"
  scope                            = var.appgw_id
	depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_role_assignment" "subnet_contributor" {

  principal_id                     = data.azurerm_user_assigned_identity.agw.principal_id
  role_definition_name             = "Network Contributor"
  scope                            = var.appgw_sub_id
	depends_on = [azurerm_kubernetes_cluster.this]
}

data "azurerm_user_assigned_identity" "akv" {
  name                = "azurekeyvaultsecretsprovider-${var.cluster_name}"
  resource_group_name = var.rg_nodes
  depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_key_vault_access_policy" "this" {
  key_vault_id   = var.akv_id
  tenant_id      = var.tenant_id
  object_id      = data.azurerm_user_assigned_identity.akv.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_role_assignment" "aks" {

  principal_id                     = var.adm_grp_id[0]
  role_definition_name             = "Reader"
  scope                            = azurerm_kubernetes_cluster.this.id
	depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_role_assignment" "cluster_admin" {

  principal_id                     = var.adm_grp_id[0]
  role_definition_name             = "Azure Kubernetes Service Cluster Admin Role"
  scope                            = azurerm_kubernetes_cluster.this.id
	depends_on = [azurerm_kubernetes_cluster.this]
}

resource "azurerm_role_assignment" "nodes" {

  principal_id                     = var.adm_grp_id[0]
  role_definition_name             = "Reader"
  scope                            = data.azurerm_resource_group.nodes.id
	depends_on = [data.azurerm_resource_group.nodes]
}