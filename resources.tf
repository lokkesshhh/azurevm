resource "azurerm_resource_group" "example" {
  name     = "${terraform.workspace}-resourcegroup"
  location = "East US"
}

# Create a virtual network and subnet
resource "azurerm_virtual_network" "example" {
  name                = "${terraform.workspace}-myVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "${terraform.workspace}-mySubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "example" {
  name                = "${terraform.workspace}-myPublicIP"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

# Create a network security group and associate it with the VM NIC
resource "azurerm_network_security_group" "example" {
  name                = "${terraform.workspace}-myNSG"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  # Define your NSG rules here (e.g., inbound/outbound rules)
}

# Create a network interface and associate it with the NSG and public IP
resource "azurerm_network_interface" "example" {
  name                = "${terraform.workspace}-myNIC"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "${terraform.workspace}myNICConfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.example.id
  }
}


# Create an OS disk
resource "azurerm_managed_disk" "os_disk" {
  name                 = "example-osdisk"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "FromImage"
  os_type              = "Linux" # Change to "Windows" for Windows VM
  disk_size_gb         = 128     # OS disk size in GB
}

# Create a virtual machine
resource "azurerm_virtual_machine" "example" {
  name                  = "${terraform.workspace}-var.vm_name"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = var.vm_size
  storage_os_disk {
    name              = azurerm_managed_disk.os_disk.name
    os_type           = azurerm_managed_disk.os_disk.os_type
    caching           = "ReadWrite"
    create_option     = "Attach"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}