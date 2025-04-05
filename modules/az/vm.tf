# https://tailscale.com/kb/1142/cloud-azure-linux


resource "azurerm_virtual_network" "vm_network" {
  # count               = 0
  name                = "${azurerm_resource_group.az_resource_group.name}_${azurerm_resource_group.az_resource_group.location}_network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.az_resource_group.location
  resource_group_name = azurerm_resource_group.az_resource_group.name
}

# Create subnet
resource "azurerm_subnet" "vm_subnet" {
  # count                = 0
  name                 = "${azurerm_resource_group.az_resource_group.name}_${azurerm_resource_group.az_resource_group.location}_subnet"
  resource_group_name  = azurerm_resource_group.az_resource_group.name
  virtual_network_name = azurerm_virtual_network.vm_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
# resource "azurerm_public_ip" "vm_public_ip" {
#   name                = "vmPublicIP"
#   location            = azurerm_resource_group.az_resource_group.location
#   resource_group_name = azurerm_resource_group.az_resource_group.name
#   allocation_method   = "Dynamic"
# }

# Create Network Security Group and rule
resource "azurerm_network_security_group" "tailscale_security_group" {
  name                = "tailscale_security_group"
  location            = azurerm_resource_group.az_resource_group.location
  resource_group_name = azurerm_resource_group.az_resource_group.name

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
  # count               = 0
  name                = "vmNIC"
  location            = azurerm_resource_group.az_resource_group.location
  resource_group_name = azurerm_resource_group.az_resource_group.name

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

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/../../cloud_init.yml", {
      tailscale_auth_key = module.ts.tailnet_key
      routes             = "10.1.0.0/24,168.63.129.16/32"
      accept_dns         = false
    })
  }
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "vmB1s" {
  # count                 = 0
  name                  = "${azurerm_resource_group.az_resource_group.name}_${var.az_vm_size}"
  location              = azurerm_resource_group.az_resource_group.location
  resource_group_name   = azurerm_resource_group.az_resource_group.name
  network_interface_ids = [azurerm_network_interface.vm_network_interface.id]
  size                  = "Standard_${var.az_vm_size}"

  os_disk {
    name                 = "${azurerm_resource_group.az_resource_group.name}_disk_${var.az_vm_size}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  # az vm image list --architecture x64 --publisher Canonical --all --output table
  # az vm image list --architecture Arm64 --publisher Canonical --all --output table
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    # sku       = "minimal-arm64"
    version = "latest"
  }

  computer_name  = "${var.az_vm_size}${var.resource_group_location}"
  admin_username = var.username
  # https://www.phillipsj.net/posts/cloud-init-with-terraform/
  custom_data = data.template_cloudinit_config.config.rendered

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.dummy_key.public_key_openssh
  }
}
