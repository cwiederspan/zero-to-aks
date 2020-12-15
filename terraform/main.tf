terraform {
  required_version = ">= 0.12"
  
  backend "azurerm" {
    environment = "public"
  }
}

provider "azurerm" {
  version = "~> 2.40"
  features {}
}

provider "azuread" {
  version = "~> 1.1"
}

variable "name_prefix" {
  type        = string
  description = "A prefix for the naming scheme as part of prefix-base-suffix."
}

variable "name_base" {
  type        = string
  description = "A base for the naming scheme as part of prefix-base-suffix."
}

variable "name_suffix" {
  type        = string
  description = "A suffix for the naming scheme as part of prefix-base-suffix."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be created."
}

variable "aks_version" {
  type        = string
  description = "The Azure region where the resources will be created."
  default     = "1.19.3"
}

variable "node_count" {
  type        = number
  description = "The number of nodes to create in the default node pool."
  default     = 1
}

variable "node_vm_sku" {
  type        = string
  description = "The VM SKU to use for the default nodes."
  default     = "Standard_DS2_v2"
}

variable "win_admin_username" {
  type        = string
  description = "A username to use if/when creating a Windows node pool (must be added at cluster creation time)."
}

variable "win_admin_password" {
  type        = string
  description = "A password to use if/when creating a Windows node pool (must be added at cluster creation time)."
}

variable "aks_admin_group_id" {
  type        = string
  description = "The ID of an AAD group that will be assigned as the AAD Admin for the Kubernetes cluster."
}

variable "authorized_ip_addresses" {
  type        = list(string)
  description = "A list of CIDR block strings that can access the Kubernetes API endpoint."
  default     = [ ]
}

variable "enable_azure_policy" {
  type        = bool
  description = "A flag for enabling Azure Policy for AKS (currently in Preview)."
  default     = false
}

variable "acr_rg_name" {
  type        = string
  description = "The Azure Container Registry's Resource Group name to setup for pull permissions."
}

variable "acr_name" {
  type        = string
  description = "The Azure Container Registry name to setup for pull permissions."
}

locals {
  base_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}

module "monitoring" {
  source         = "./modules/monitoring"
  base_name      = local.base_name
  resource_group = azurerm_resource_group.group.name
  location       = azurerm_resource_group.group.location
}

resource "azurerm_resource_group" "group" {
  name     = local.base_name
  location = var.location
}