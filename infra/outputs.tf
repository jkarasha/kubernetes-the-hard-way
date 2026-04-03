output "jumpbox_public_ip" {
  description = "Public IP address of the jumpbox."
  value       = module.networking.jumpbox_public_ip
}

output "private_ips" {
  description = "Private IP addresses for all VMs."
  value       = module.networking.private_ips
}

output "jumpbox_ssh_command" {
  description = "Preferred command to reach the jumpbox with SSH agent forwarding enabled."
  value       = "ssh -A ${var.admin_username}@${module.networking.jumpbox_public_ip}"
}

output "ssh_from_jumpbox_commands" {
  description = "Commands to run from the jumpbox to reach the private VMs."
  value = {
    server = "ssh ${var.admin_username}@${module.networking.private_ips.server}"
    node0  = "ssh ${var.admin_username}@${module.networking.private_ips.node0}"
    node1  = "ssh ${var.admin_username}@${module.networking.private_ips.node1}"
  }
}

output "proxyjump_commands" {
  description = "Optional direct local SSH commands using ProxyJump."
  value = {
    server = "ssh -J ${var.admin_username}@${module.networking.jumpbox_public_ip} ${var.admin_username}@${module.networking.private_ips.server}"
    node0  = "ssh -J ${var.admin_username}@${module.networking.jumpbox_public_ip} ${var.admin_username}@${module.networking.private_ips.node0}"
    node1  = "ssh -J ${var.admin_username}@${module.networking.jumpbox_public_ip} ${var.admin_username}@${module.networking.private_ips.node1}"
  }
}

output "machines_txt" {
  description = "Machine database content to paste into machines.txt on the jumpbox."
  value       = local.machines_txt
}

output "debian_image_urn" {
  description = "Azure marketplace image URN used for all VMs."
  value       = "${var.vm_image_publisher}:${var.vm_image_offer}:${var.vm_image_sku}:${var.vm_image_version}"
}
