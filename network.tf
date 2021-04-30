#this script configure the virtual network,subnets and NSGs
resource "azurerm_virtual_network" "vNet" {
  name                = "wta-vnet"
  location            = var.location
  resource_group_name = var.resourceGroupName
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_subnet" "PublicSN" {
  name                 = "public-subnet"
  resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vNet.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "PrivateSN" {
  name                 = "private-subnet"
    resource_group_name  = var.resourceGroupName
  virtual_network_name = azurerm_virtual_network.vNet.name
  address_prefixes     = ["10.0.2.0/24"]

}


resource "azurerm_network_security_group" "public_nsg" {
  name                = "public-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "8080"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "rule_22"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Port_8080"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_resource_group.rg,
  ]
}



resource "azurerm_network_security_group" "private_nsg" {
  name                = "private-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "5432_rule"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "5432"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "22_ruleO"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

    
  }

  depends_on = [
    azurerm_resource_group.rg,
  ]
}



resource "azurerm_subnet_network_security_group_association" "public_nsg_assoc" {
  subnet_id                 = azurerm_subnet.PublicSN.id
  network_security_group_id = azurerm_network_security_group.public_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_assoc" {
  subnet_id                 = azurerm_subnet.PrivateSN.id
  network_security_group_id = azurerm_network_security_group.private_nsg.id
}

resource "azurerm_public_ip" "nat_ip" {
  name                = "nat-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_nat_gateway" "NatG" {
  name                    = "nat-Gateway"
  location                = var.location
  resource_group_name     = var.resourceGroupName
  sku_name                = "Standard"
  public_ip_address_ids   = [azurerm_public_ip.nat_ip.id]
  idle_timeout_in_minutes = 10
  
}

resource "azurerm_subnet_nat_gateway_association" "AssocPrivate" {
  subnet_id      = azurerm_subnet.PrivateSN.id
  nat_gateway_id = azurerm_nat_gateway.NatG.id
}
resource "azurerm_subnet_nat_gateway_association" "AssocPublic" {
  subnet_id      = azurerm_subnet.PublicSN.id
  nat_gateway_id = azurerm_nat_gateway.NatG.id
}
