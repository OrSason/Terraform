#This script configure the back load balancer

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
/*
resource "azurerm_network_interface_backend_address_pool_association" "vm1-nic-assoc2" {
  network_interface_id    = azurerm_network_interface.nic_vm_1.id
  ip_configuration_name   = "internalVM1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.back_lb_back_pool_address.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm2-nic-assoc2" {
  network_interface_id    = azurerm_network_interface.nic_vm_2.id
  ip_configuration_name   = "internalVM2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.back_lb_back_pool_address.id
}
*/


resource "azurerm_network_interface_backend_address_pool_association" "vm4-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm_4.id
  ip_configuration_name   = "internalVM4"
  backend_address_pool_id = azurerm_lb_backend_address_pool.back_lb_back_pool_address.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm5-nic-assoc" {
  network_interface_id    = azurerm_network_interface.nic_vm_5.id
  ip_configuration_name   = "internalVM5"
  backend_address_pool_id = azurerm_lb_backend_address_pool.back_lb_back_pool_address.id
}

resource "azurerm_lb_probe" "back_lb_probe" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb_back.id
  name                = "health-probe-blb"
  port                = 5432
}

resource "azurerm_lb_rule" "BackLBRule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb_back.id
  name                           = "BLBRule"
  protocol                       = "Tcp"
  frontend_port                  = 5432
  backend_port                   = 5432
  frontend_ip_configuration_name = "privateIPLB"
  probe_id                       = azurerm_lb_probe.back_lb_probe.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.back_lb_back_pool_address.id
  
}


