provider "azurerm" {
  version = "=1.24.0"
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

variable "service_principal_name" { }

variable "service_principal_pwd" { }

variable "node_count" { }

variable "aks_version" { }


# VNET and App Gateway Variables

#variable "storage_name" { }     # This should eventually go away

#variable "ssl_filename" { }     # This should eventually go away

#variable "ssl_password" { }     # This should eventually go away

#variable "gateway_name" { }

#variable "gateway_instance_count" {
#  default = 1
#}

#variable "public_ip_name" { }

#variable "vnet_name" { }