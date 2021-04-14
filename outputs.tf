output "vm1-ip" {
  value = data.azurerm_public_ip.ip.ip_address
}


output "vm1-private-ip" {
  description = "private ip addresses of the vm nics"
  value       = azurerm_network_interface.vm.nic_vm_1.private_ip_address
}