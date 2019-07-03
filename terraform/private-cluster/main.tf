provider "azurerm" {
  version = "=1.31.0"
}

provider "azuread" {
  version = "=0.4.0"
}

terraform {
  backend "azurerm" {
    environment = "public"
  }
}

variable "name_prefix" { }

variable "name_base" { }

variable "name_suffix" { }

variable "location" { }

variable "node_count" { }

variable "aks_version" { }

variable "ingress_namespace" { }

variable "ingress_load_balancer_ip" { }

variable "gateway_instance_count" { }

variable "ssl_filename" { }

variable "ssl_password" { }

locals {
  base_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}

module "service_principal" {
  source    = "../modules/service-principal"
  base_name = "${local.base_name}"
}

module "monitoring" {
  source         = "../modules/monitoring"
  base_name      = "${local.base_name}"
  resource_group = "${azurerm_resource_group.group.name}"
  location       = "${azurerm_resource_group.group.location}"
}

module "sample_app" {
  source = "../modules/sample-app"
}