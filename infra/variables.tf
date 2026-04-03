variable "subscription_id" {
  description = "Azure subscription ID used by the azurerm provider."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name for the lab infrastructure."
  type        = string
  default     = "rg-kthw-lab-wus3-001"
}

variable "location" {
  description = "Azure region for all regional resources."
  type        = string
  default     = "westus3"
}

variable "environment" {
  description = "Environment tag value."
  type        = string
  default     = "lab"
}

variable "workload_name" {
  description = "Workload tag value."
  type        = string
  default     = "kubernetes-the-hard-way"
}

variable "admin_username" {
  description = "Admin username for the Debian VMs."
  type        = string
  default     = "debian"
}

variable "ssh_public_key_path" {
  description = "Path to the local SSH public key file to inject into all VMs."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to reach the jumpbox over SSH."
  type        = string
}

variable "vm_image_publisher" {
  description = "Azure marketplace image publisher."
  type        = string
  default     = "debian"
}

variable "vm_image_offer" {
  description = "Azure marketplace image offer."
  type        = string
  default     = "debian-12"
}

variable "vm_image_sku" {
  description = "Azure marketplace image SKU."
  type        = string
  default     = "12-arm64"
}

variable "vm_image_version" {
  description = "Azure marketplace image version. Keep latest to stay on Debian 12 Bookworm for ARM64."
  type        = string
  default     = "latest"
}

variable "jumpbox_vm_size" {
  description = "Azure ARM64 VM size for the jumpbox."
  type        = string
  default     = "Standard_B2pts_v2"
}

variable "cluster_vm_size" {
  description = "Azure ARM64 VM size for the control-plane server and worker nodes."
  type        = string
  default     = "Standard_B2pls_v2"
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB for all lab VMs."
  type        = number
  default     = 30
}

variable "vnet_cidr" {
  description = "Address space for the lab VNet."
  type        = string
  default     = "10.0.0.0/16"
}

variable "jumpbox_subnet_cidr" {
  description = "CIDR for the jumpbox/admin subnet."
  type        = string
  default     = "10.0.1.0/28"
}

variable "cluster_subnet_cidr" {
  description = "CIDR for the private cluster subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "jumpbox_private_ip" {
  description = "Static private IP for the jumpbox."
  type        = string
  default     = "10.0.1.10"
}

variable "server_private_ip" {
  description = "Static private IP for the control-plane server."
  type        = string
  default     = "10.0.2.20"
}

variable "node0_private_ip" {
  description = "Static private IP for worker node 0."
  type        = string
  default     = "10.0.2.21"
}

variable "node1_private_ip" {
  description = "Static private IP for worker node 1."
  type        = string
  default     = "10.0.2.22"
}

variable "node0_pod_cidr" {
  description = "Pod CIDR used by worker node 0 in the Kubernetes lab."
  type        = string
  default     = "10.200.0.0/24"
}

variable "node1_pod_cidr" {
  description = "Pod CIDR used by worker node 1 in the Kubernetes lab."
  type        = string
  default     = "10.200.1.0/24"
}

variable "tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
