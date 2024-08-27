resource "azurerm_resource_group" "rg_aks" {
  name     = "${var.resource_group}_${var.environment}"
  location = var.location
}

resource "azurerm_virtual_network" "appgw01" {
  name                = "appgw01-network"
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "appgw01" {
  name                 = "appgw01"
  resource_group_name  = azurerm_resource_group.rg_aks.name
  virtual_network_name = azurerm_virtual_network.appgw01.name
  address_prefixes     = ["10.254.0.0/24"]
}

resource "azurerm_public_ip" "appgw01" {
  name                = "appgw01-pip"
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.appgw01.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.appgw01.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.appgw01.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.appgw01.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.appgw01.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.appgw01.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.appgw01.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "appgw01-appgateway"
  resource_group_name = azurerm_resource_group.rg_aks.name
  location            = azurerm_resource_group.rg_aks.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgw01.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw01.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                                = "${var.cluster_name}_${var.environment}"
  location                            = azurerm_resource_group.rg_aks.location
  resource_group_name                 = azurerm_resource_group.rg_aks.name
  dns_prefix                          = var.dns_prefix
  private_cluster_enabled             = var.private_cluster_enabled
  automatic_channel_upgrade           = var.upgrade
#   azure_policy_enabled                = var.policy
  local_account_disabled              = var.local_acc
  node_resource_group                 = var.rg_nodes
  private_cluster_public_fqdn_enabled = var.private_fqdn
  http_application_routing_enabled    = var.http_routing
  sku_tier                            = var.sku
  kubernetes_version                  = var.aks_version

  #   linux_profile {
  #     admin_username = "ubuntu"

  #     ssh_key {
  #       key_data = file(var.ssh_public_key)
  #     }
  #   }

  network_profile {
    dns_service_ip    = var.net_dns
    load_balancer_sku = var.net_lb_sku
    network_plugin    = var.net_plugin
    network_policy    = var.net_policy
    outbound_type     = var.net_outbound
    service_cidr      = var.net_svc_crd
  }

  storage_profile {
    blob_driver_enabled = var.sto_blob
    disk_driver_enabled = var.sto_disk
    file_driver_enabled = var.sto_file
  }

  default_node_pool {
    name       = "defaultpool"
    node_count = var.pnp_node_count
    vm_size    = "Standard_DS2_v2"
  }

  ingress_application_gateway { 

    gateway_id = azurerm_application_gateway.network.id

  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment
  }
}

