#this script configure the public vms


resource "azurerm_network_interface" "nic_vm_1" {
  name                = "wta-vm1-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internalVM1"
    subnet_id                     = azurerm_subnet.PublicSN.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic_vm_2" {
  name                = "wta-vm2-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internalVM2"
    subnet_id                     = azurerm_subnet.PublicSN.id
    private_ip_address_allocation = "Dynamic"
   
  }
}


/*
resource "azurerm_virtual_machine" "publicVM1" {
  name                = "wta-public-vm1"
  resource_group_name = var.resourceGroupName
  location            = var.location
  vm_size             = var.VMSize
  network_interface_ids = [
  azurerm_network_interface.nic_vm_1.id,
  ]

storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username      = var.VMUsername
    admin_password      = var.VMPassword
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

}
*/



resource "azurerm_virtual_machine" "vm1" {
  name                  = "wta-public-vm1"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = [azurerm_network_interface.nic_vm_1.id]
  vm_size               = var.VMSize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
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



resource "azurerm_virtual_machine" "publicVM2" {
  name                = "wta-public-vm2"
  resource_group_name = var.resourceGroupName
  location            = var.location
  vm_size             = var.VMSize
  network_interface_ids = [
  azurerm_network_interface.nic_vm_2.id,
  ]

storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username      = var.VMUsername
    admin_password      = var.VMPassword
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

}
