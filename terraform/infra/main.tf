provider "azurerm" {
  version = "=1.24.0"
}

provider "azuread" {
  version = "=0.1.0"
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

variable "helm_repo_password" { }

variable "ingress_load_balancer_ip" { }

variable "gateway_instance_count" { }

variable "ssl_filename" { }

variable "ssl_password" { }

locals {
  base_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}