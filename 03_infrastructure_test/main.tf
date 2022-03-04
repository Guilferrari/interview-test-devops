# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# Create a resource group 
resource "azurerm_resource_group" "rg_test" {
    name     = var.RG_TEST_NAME
    location = var.REGION

    tags = var.TAGS_TEST
}

# Create virtual network
resource "azurerm_virtual_network" "vnet_test" {
    name                = var.VNET_TEST_NAME
    address_space       = ["10.0.0.0/16"]
    location            = var.REGION
    resource_group_name = azurerm_resource_group.rg_test.name

    tags = var.TAGS_TEST
}

# Create subnet
resource "azurerm_subnet" "subnet_test" {
    name                 = var.SUBNET_TEST_NAME
    resource_group_name  = azurerm_resource_group.rg_test.name
    virtual_network_name = azurerm_virtual_network.vnet_test.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "publicip_test" {
    name                         = var.PUBLIC_IP_TEST_NAME
    location                     = var.REGION
    resource_group_name          = azurerm_resource_group.rg_test.name
    allocation_method            = "Dynamic"

    tags = var.TAGS_TEST
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg_test" {
    name                = var.NSG_TEST_NAME
    location            = var.REGION
    resource_group_name = azurerm_resource_group.rg_test.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = var.TAGS_TEST
}

# Create network interface
resource "azurerm_network_interface" "nic_test" {
    name                      = var.NIC_TEST_NAME
    location                  = var.REGION
    resource_group_name       = azurerm_resource_group.rg_test.name

    ip_configuration {
        name                          = "nicConfiguration"
        subnet_id                     = azurerm_subnet.subnet_test.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicip_test.id
    }

    tags = var.TAGS_TEST
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "test" {
    network_interface_id      = azurerm_network_interface.nic_test.id
    network_security_group_id = azurerm_network_security_group.nsg_test.id
}

# Create an SSH key
resource "tls_private_key" "test_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { 
    value = tls_private_key.test_ssh.private_key_pem 
    sensitive = true
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm_test" {
    name                  = var.VM_TEST_NAME
    location              = var.REGION
    resource_group_name   = azurerm_resource_group.rg_test.name
    network_interface_ids = [azurerm_network_interface.nic_test.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.test_ssh.public_key_openssh
    }

    tags = var.TAGS_TEST
}