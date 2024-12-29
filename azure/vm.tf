# https://tailscale.com/kb/1142/cloud-azure-linux


resource "azurerm_virtual_network" "vm_network" {
  count               = 0
  name                = "vmNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "vm_subnet" {
  count                = 0
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
# resource "azurerm_public_ip" "vm_public_ip" {
#   name                = "vmPublicIP"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Dynamic"
# }

# Create Network Security Group and rule
resource "azurerm_network_security_group" "tailscale_security_group" {
  name                = "tailscaleNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Tailscale"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "41641"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "vm_network_interface" {
  count               = 0
  name                = "vmNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "vm_nic_configuration"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  network_interface_id      = azurerm_network_interface.vm_network_interface.id
  network_security_group_id = azurerm_network_security_group.tailscale_security_group.id
}

data "template_file" "script" {
  template = file("${path.module}/../init.tpl")

  vars = {
    tailscale_auth_key = vars.tailscale_auth_key
    routes             = "10.1.0.0/24,168.63.129.16/32"
    accept_dns         = false
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.script.rendered
  }
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm_B2pts2" {
  count                 = 0
  name                  = "${azurerm_resource_group.rg.name}_${azurerm_resource_group.rg.location}_B2pts2"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vm_network_interface.id]
  size                  = "Standard_B2pts_v2"

  os_disk {
    name                 = "vmDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "24_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_username = var.username
  # https://www.phillipsj.net/posts/cloud-init-with-terraform/
  custom_data = data.template_cloudinit_config.config.rendered

  # admin_ssh_key {
  #   username   = var.username
  #   public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  # }
}

resource "tailscale_dns_split_nameservers" "azure_split_nameservers" {
  domain      = "internal.cloudapp.net"
  nameservers = ["168.63.129.16"]
}
