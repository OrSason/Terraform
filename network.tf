
#Public load balancer

resource "azurerm_public_ip" "LBPublicIP" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "PublicLB" {
  name                = "PublicLoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.LBPublicIP.id
    subnet_id           = azurerm_subnet.PublicSubnet.id
  }
}


