# Resource Group
resource_group_name = "ansible-test"
location = "eastus"

# Virtual Network
vnet_address_space = ["10.0.0.0/16"]

# Subnet
subnet_name = "internal-subnet"
subnet_address_space = ["10.0.1.0/24"]

# VM Configuration
vm_name = "ansible-server-0"
vm_client_name = "ubuntu-cli"
vm_client_win_name = "windows-cli"
ws2019_client_name = "ws2019-cli"

# Additional Variables
create_rg = false
create_vnet = false
create_sshkey = true
ssh_pub_key_path = "C:/vscode/sshkeys/sshkey.pub"
ssh_pub_key_path_cli = "C:/vscode/sshkeys/id_rsa.pub"
