#this script configures the database machines

resource "azurerm_network_interface" "nic_vm_4" {
  name                = "nic-vm-4"
  location            = var.location
  resource_group_name = var.resourceGroupName

  ip_configuration {
    name                          = "internalVM4"
    subnet_id                     = azurerm_subnet.PrivateSN.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_vm_5" {
  name                = "nic-vm-5"
  location            = var.location
  resource_group_name = var.resourceGroupName

  ip_configuration {
    name                          = "internalVM5"
    subnet_id                     = azurerm_subnet.PrivateSN.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm4" {
  name                  = "vm4-db"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = [azurerm_network_interface.nic_vm_4.id]
  vm_size               = var.VMSize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk4"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.VMUsername
    admin_password = var.VMPassword
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  
}

resource "azurerm_virtual_machine" "vm5" {
  name                  = "vm5-db"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = [azurerm_network_interface.nic_vm_5.id]
  vm_size               = var.VMSize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk5"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.VMUsername
    admin_password = var.VMPassword
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  
}