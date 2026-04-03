output "nic_ids" {
  description = "NIC IDs keyed by VM role."
  value = {
    for name, nic in azurerm_network_interface.this : name => nic.id
  }
}

output "private_ips" {
  description = "Private IPs keyed by VM role."
  value = {
    for name, nic in azurerm_network_interface.this : name => nic.private_ip_address
  }
}

output "jumpbox_public_ip" {
  description = "Public IP address of the jumpbox."
  value       = azurerm_public_ip.jumpbox.ip_address
}

output "subnet_ids" {
  description = "Subnet IDs for the jumpbox and cluster subnets."
  value = {
    jumpbox = azurerm_subnet.jumpbox.id
    cluster = azurerm_subnet.cluster.id
  }
}
