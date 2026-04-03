output "vm_ids" {
  description = "VM IDs keyed by role."
  value = {
    for name, vm in azurerm_linux_virtual_machine.this : name => vm.id
  }
}

output "vm_names" {
  description = "VM names keyed by role."
  value = {
    for name, vm in azurerm_linux_virtual_machine.this : name => vm.name
  }
}
