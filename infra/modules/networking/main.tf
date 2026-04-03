locals {
  nic_configs = {
    jumpbox = {
      name         = "nic-kthw-jumpbox-wus3-001"
      subnet_id    = azurerm_subnet.jumpbox.id
      private_ip   = var.jumpbox_private_ip
      public_ip_id = azurerm_public_ip.jumpbox.id
      nsg_id       = azurerm_network_security_group.jumpbox.id
    }
    server = {
      name         = "nic-kthw-server-wus3-001"
      subnet_id    = azurerm_subnet.cluster.id
      private_ip   = var.server_private_ip
      public_ip_id = null
      nsg_id       = azurerm_network_security_group.cluster.id
    }
    node0 = {
      name         = "nic-kthw-node0-wus3-001"
      subnet_id    = azurerm_subnet.cluster.id
      private_ip   = var.node0_private_ip
      public_ip_id = null
      nsg_id       = azurerm_network_security_group.cluster.id
    }
    node1 = {
      name         = "nic-kthw-node1-wus3-001"
      subnet_id    = azurerm_subnet.cluster.id
      private_ip   = var.node1_private_ip
      public_ip_id = null
      nsg_id       = azurerm_network_security_group.cluster.id
    }
  }
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-kthw-lab-wus3-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "snet-kthw-jumpbox-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.jumpbox_subnet_cidr]
}

resource "azurerm_subnet" "cluster" {
  name                 = "snet-kthw-cluster-001"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.cluster_subnet_cidr]
}

resource "azurerm_network_security_group" "jumpbox" {
  name                = "nsg-kthw-jumpbox-wus3-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowSshFromAdminCidr"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_allowed_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "cluster" {
  name                = "nsg-kthw-cluster-wus3-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_public_ip" "jumpbox" {
  name                = "pip-kthw-jumpbox-wus3-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_public_ip" "nat" {
  name                = "pip-kthw-nat-wus3-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway" "this" {
  name                = "ng-kthw-lab-wus3-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
  tags                = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "this" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "cluster" {
  subnet_id      = azurerm_subnet.cluster.id
  nat_gateway_id = azurerm_nat_gateway.this.id
}

resource "azurerm_network_interface" "this" {
  for_each = local.nic_configs

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.private_ip
    public_ip_address_id          = each.value.public_ip_id
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  for_each = local.nic_configs

  network_interface_id      = azurerm_network_interface.this[each.key].id
  network_security_group_id = each.value.nsg_id
}
