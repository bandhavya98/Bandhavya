provider "azurerm" {
    version = ">=2.0"
    skip_provider_registration = true
    features {}
}

resource "azurerm_resource_group" "TestRg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.TestRg.location
  resource_group_name = azurerm_resource_group.TestRg.name
}

resource "azurerm_subnet" "AppSubnet" {
  name                 = var.App_subnet_name
  resource_group_name  = azurerm_resource_group.TestRg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix     = "10.0.2.0/24"
}
resource "azurerm_subnet" "WebSubnet" {
  name                 = var.Web_subnet_name
  resource_group_name  = azurerm_resource_group.TestRg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix     = "10.0.1.0/24"
}
resource "azurerm_network_interface" "AppVmNic" {
  name                = var.App_network_interface_name
  location            = azurerm_resource_group.TestRg.location
  resource_group_name = azurerm_resource_group.TestRg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.AppSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "WebVmNic" {
  name                = var.Web_network_interface_name
  location            = azurerm_resource_group.TestRg.location
  resource_group_name = azurerm_resource_group.TestRg.name

  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = azurerm_subnet.WebSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "AppVm" {
  name                  = var.AppVM_Name
  location              = azurerm_resource_group.TestRg.location
  resource_group_name   = azurerm_resource_group.TestRg.name
  network_interface_ids = [azurerm_network_interface.AppVmNic.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "AppServerosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
    owner = "bandhavya"
    server = "App"
  }
}
resource "azurerm_virtual_machine" "WebVm" {
  name                  = var.WebVM_Name
  location              = azurerm_resource_group.TestRg.location
  resource_group_name   = azurerm_resource_group.TestRg.name
  network_interface_ids = [azurerm_network_interface.WebVmNic.id]
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "WebServerosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
    owner = "bandhavya"
    server = "Web"
  }
}
resource "azurerm_sql_server" "sqls"{
    name                 = var.sql_Server_Name
    resource_group_name  = azurerm_resource_group.TestRg.name
    location             =  azurerm_resource_group.TestRg.location
    version              = "12.0"
    administrator_login  = var.sql_admin_login
    administrator_login_password = var.sql_admin_login_password
}
resource "azurerm_sql_database" "sqldb"{
    name               = var.sql_db_Name
    resource_group_name = azurerm_resource_group.TestRg.name
    location           =  azurerm_resource_group.TestRg.location
    server_name    = azurerm_sql_server.sqls.name
    zone_redundant     = false
}
resource "azurerm_public_ip" "IP" {
  name                = var.LB_FrontEnd_IP_name
  location            = azurerm_resource_group.TestRg.location
  resource_group_name = azurerm_resource_group.TestRg.name
  allocation_method   = "Static"
}
resource "azurerm_lb" "PubLB1"{
  name                = var.LB_Name
  location            = azurerm_resource_group.TestRg.location
  resource_group_name = azurerm_resource_group.TestRg.name
  sku                 = var.lb_sku
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.IP.id
  }
}