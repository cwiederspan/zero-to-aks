terraform {
  required_version = ">= 0.12"

  backend "azurerm" {
    environment = "public"
  }
}

variable "name_prefix"        { }
variable "name_base"          { }
variable "name_suffix"        { }
variable "location"           { }
variable "node_count"         { }
variable "aks_version"        { }
variable "ingress_namespace"  { }
variable "win_admin_username" { }
variable "win_admin_password" { }

locals {
  base_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}

resource "azurerm_resource_group" "group" {
  name     = local.base_name
  location = var.location
}

module "common" {
  source    = "../modules/common"
}

module "service_principal" {
  source    = "../modules/service-principal"
  base_name = local.base_name
}

module "bindings" {
  source    = "../modules/role-bindings"
}

module "monitoring" {
  source         = "../modules/monitoring"
  base_name      = local.base_name
  resource_group = azurerm_resource_group.group.name
  location       = azurerm_resource_group.group.location
}

module "sample_app" {
  source = "../modules/sample-app"
  
  external_depends_on = [
    helm_release.ingress
  ]
}