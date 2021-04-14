

resource "azurerm_public_ip" "lb_front_ip" {
  name                = "lb-front-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "lb_front" {
  name                = "FrontLoadBalancer"
  location            = var.location
  resource_group_name = var.resourceGroupName
  sku                 = "Standard"
  
  frontend_ip_configuration {
    name                 = "LBPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_front_ip.id
  }
 
}

resource "azurerm_lb_backend_address_pool" "lb_back_pool_address" {
  name            = "BackendPool"
  loadbalancer_id = azurerm_lb.lb_front.id
  
}

resource "azurerm_network_interface_backend_address_pool_association" "vm1-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm_1.id
  ip_configuration_name   = "internalVM1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm2-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm_2.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm3-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm_3.id
  ip_configuration_name   = "internalVM3"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_back_pool_address.id
}

resource "azurerm_lb_probe" "LBpublicProbe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb_front.id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "FrontLBRule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb_front.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "LBPublicIPAddress"
  
}


