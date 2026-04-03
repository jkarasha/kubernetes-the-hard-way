variable "resource_group_name" {
  description = "Resource group name for all VMs."
  type        = string
}

variable "location" {
  description = "Azure region for all VMs."
  type        = string
}

variable "admin_username" {
  description = "Admin username for the Debian VMs."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key data injected into all VMs."
  type        = string
  sensitive   = true
}

variable "vm_image_publisher" {
  description = "Azure marketplace image publisher."
  type        = string
}

variable "vm_image_offer" {
  description = "Azure marketplace image offer."
  type        = string
}

variable "vm_image_sku" {
  description = "Azure marketplace image SKU."
  type        = string
}

variable "vm_image_version" {
  description = "Azure marketplace image version."
  type        = string
}

variable "tags" {
  description = "Tags applied to all VMs."
  type        = map(string)
}

variable "vm_definitions" {
  description = "VM definitions keyed by role."
  type = map(object({
    vm_name         = string
    computer_name   = string
    size            = string
    nic_id          = string
    os_disk_size_gb = number
  }))
}
