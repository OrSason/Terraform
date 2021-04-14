

resource "azurerm_lb" "lb_back" {
  name                = "BackLoadBalancer"
  location            = var.location
  resource_group_name = var.resourceGroupName
  sku                 = "Standard"
  
  frontend_ip_configuration {
    name                 = "privateIPLB"
    subnet_id            = azurerm_subnet.PrivateSN.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.10"
  }
 
}

resource "azurerm_lb_backend_address_pool" "back_lb_back_pool_address" {
  name            = "BLBBackendPool"
  loadbalancer_id = azurerm_lb.lb_back.id
  
}

resource "azurerm_network_interface_backend_address_pool_association" "vm1-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm_1.id
  ip_configuration_name   = "internalVM1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.back_lb_back_pool_address
}

resource "azurerm_network_interface_backend_address_pool_association" "vm2-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm_2.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.back_lb_back_pool_address
}

resource "azurerm_network_interface_backend_address_pool_association" "vm3-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm_3.id
  ip_configuration_name   = "internalVM3"
  backend_address_pool_id = azurerm_lb_backend_address_pool.back_lb_back_pool_address
}

resource "azurerm_lb_probe" "LBprivateProbe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb_front.id
  name                = "ssh-running-probe"
  port                = 22
}

resource "azurerm_lb_rule" "BackLBRule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb_back.id
  name                           = "BLBRule"
  protocol                       = "Tcp"
  frontend_port                  = 5432
  backend_port                   = 5432
  frontend_ip_configuration_name = "privateIPLB"
  
}


