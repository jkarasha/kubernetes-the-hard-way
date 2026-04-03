variable "resource_group_name" {
  description = "Resource group name for all networking resources."
  type        = string
}

variable "location" {
  description = "Azure region for all networking resources."
  type        = string
}

variable "tags" {
  description = "Tags applied to networking resources."
  type        = map(string)
}

variable "vnet_cidr" {
  description = "Address space for the lab VNet."
  type        = string
}

variable "jumpbox_subnet_cidr" {
  description = "CIDR block for the jumpbox subnet."
  type        = string
}

variable "cluster_subnet_cidr" {
  description = "CIDR block for the cluster subnet."
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to reach the jumpbox over SSH."
  type        = string
}

variable "jumpbox_private_ip" {
  description = "Static private IP address for the jumpbox NIC."
  type        = string
}

variable "server_private_ip" {
  description = "Static private IP address for the server NIC."
  type        = string
}

variable "node0_private_ip" {
  description = "Static private IP address for worker node 0."
  type        = string
}

variable "node1_private_ip" {
  description = "Static private IP address for worker node 1."
  type        = string
}
