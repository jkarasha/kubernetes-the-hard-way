locals {
  common_tags = merge(
    {
      environment = var.environment
      workload    = var.workload_name
      managed-by  = "terraform"
    },
    var.tags
  )

  vm_definitions = {
    jumpbox = {
      vm_name         = "jumpbox"
      computer_name   = "jumpbox"
      size            = var.jumpbox_vm_size
      nic_id          = module.networking.nic_ids.jumpbox
      os_disk_size_gb = var.os_disk_size_gb
    }
    server = {
      vm_name         = "server"
      computer_name   = "server"
      size            = var.cluster_vm_size
      nic_id          = module.networking.nic_ids.server
      os_disk_size_gb = var.os_disk_size_gb
    }
    node0 = {
      vm_name         = "node-0"
      computer_name   = "node-0"
      size            = var.cluster_vm_size
      nic_id          = module.networking.nic_ids.node0
      os_disk_size_gb = var.os_disk_size_gb
    }
    node1 = {
      vm_name         = "node-1"
      computer_name   = "node-1"
      size            = var.cluster_vm_size
      nic_id          = module.networking.nic_ids.node1
      os_disk_size_gb = var.os_disk_size_gb
    }
  }

  machines_txt = join("\n", [
    "${module.networking.private_ips.server} server.kubernetes.local server",
    "${module.networking.private_ips.node0} node-0.kubernetes.local node-0 ${var.node0_pod_cidr}",
    "${module.networking.private_ips.node1} node-1.kubernetes.local node-1 ${var.node1_pod_cidr}",
  ])
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
  vnet_cidr           = var.vnet_cidr
  jumpbox_subnet_cidr = var.jumpbox_subnet_cidr
  cluster_subnet_cidr = var.cluster_subnet_cidr
  ssh_allowed_cidr    = var.ssh_allowed_cidr
  jumpbox_private_ip  = var.jumpbox_private_ip
  server_private_ip   = var.server_private_ip
  node0_private_ip    = var.node0_private_ip
  node1_private_ip    = var.node1_private_ip
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  admin_username      = var.admin_username
  ssh_public_key      = trimspace(file(pathexpand(var.ssh_public_key_path)))
  vm_image_publisher  = var.vm_image_publisher
  vm_image_offer      = var.vm_image_offer
  vm_image_sku        = var.vm_image_sku
  vm_image_version    = var.vm_image_version
  tags                = local.common_tags
  vm_definitions      = local.vm_definitions
}
