# Resource Group
resource_group_name = "ansible-test"
location            = "eastus"

# Virtual Network
vnet_address_space = ["10.0.0.0/16"]

# Subnet
subnet_name          = "internal-subnet"
subnet_address_space = ["10.0.1.0/24"]

# VM Configuration
vm_name            = "ansible-server-0"
vm_client_name     = "ubuntu-cli"
vm_client_win_name = "windows-cli"
ws2019_client_name = "ws2019-cli"

# Additional Variables
create_rg            = false
create_vnet          = false
create_sshkey        = true
ssh_pub_key_path     = "C:/vscode/sshkeys/sshkey.pub"
ssh_pub_key_path_cli = "C:/vscode/sshkeys/id_rsa.pub"
vm_tags_linux = [
  {
    Role = "lx_web_server",
  },
  {
    Role = "mysqlserver"
  }
  # Add more maps as needed for each VM
]

vm_tags_win = [
  {
    Role = "win_web_server",
  },
  {
    Role = "mssql"
  }
  # Add more maps as needed for each VM
]
rg_name = "AKS_deploy"
rg_location = "eastus"
# Corresponding to the module variables
sto_file               = true
net_dns                = "10.123.0.10"
sto_disk               = true
net_lb_sku             = "standard"
net_bridge             = "172.123.0.1/16"
private_cluster_enabled = true
net_outbound           = "loadBalancer"
net_plugin             = "azure"
sto_blob               = true
net_policy             = "azure"

net_svc_crd   = "10.123.0.0/16"
policy        = true
local_acc     = false
auto_scaling  = true
sku           = "Standard"
private_fqdn  = false
http_routing  = false
mi_name       = "mutliclouds-aks"
cluster_name  = "multiclouds"
rg_nodes      = "multiclouds-rg"
private       = true
upgrade       = "patch"
