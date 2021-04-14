resource "azurerm_network_interface" "nic_vm_4" {
  name                = "nice-vm-4"
  location            = var.location
  resource_group_name = var.resourceGroupName

  ip_configuration {
    name                          = "internalVM4"
    subnet_id                     = azurerm_subnet.PrivateSN.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm4" {
  name                = "vm4-db"
  location            = var.location
  resource_group_name = var.resourceGroupName
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic_vm_4.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}