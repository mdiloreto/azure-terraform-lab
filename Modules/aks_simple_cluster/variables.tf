# variable ssh_public_key {

# }

variable "environment" {
  default = "dev"
}

variable "location" {
  default = "eastus"
}

variable "aks_version" {default=null}
variable "rg_nodes" {}
variable "private" {}
variable "upgrade" {}
variable "mi_name" {}
variable "policy" {}
variable "local_acc" {}
variable "private_fqdn" {}
variable "http_routing" {}
variable "auto_scaling" {}
variable "sku" {}

variable "pnp_node_count" {
  default = 1
}

variable "password" {
  default = "MadsBlog@AKS-Cluster01"
}

variable "dns_prefix" {
  default = "k8stest"
}

variable "cluster_name" {
  default = "k8stest"
}

variable "resource_group" {
  default = "kubernetes"
}

variable "private_cluster_enabled" {

}
variable "net_dns" {}
variable "net_bridge" {}
variable "net_lb_sku" {}
variable "net_plugin" {}
variable "net_policy" {}
variable "net_outbound" {}
variable "net_svc_crd" {}
variable "sto_blob" {}
variable "sto_disk" {}
variable "sto_file" {}