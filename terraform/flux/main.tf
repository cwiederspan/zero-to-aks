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

provider "kubernetes" {
  version = "~> 1.13"
}

provider "helm" {
  version = "~> 1.3"

  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

variable "aks_rg" {
  type        = string
  description = "The name of the resource group where the AKS cluster resides."
}

variable "aks_name" {
  type        = string
  description = "The name of the AKS cluster to access."
}

variable "flux_namespace" {
  type        = string
  description = "The namespace where flux will be installed."
  default     = "flux"
}

variable "flux_repo" {
  type        = string
  description = "The git repo from which flux will deploy manifests."
}

variable "flux_path" {
  type        = string
  description = "The path(s) within the git repo from which flux will deploy manifests."
}

variable "flux_poll_interval" {
  type        = string
  description = "The interval in which flux will poll for git commits to the repo."
  default     = "5m"
}

data "azurerm_kubernetes_cluster" "aks" {
  resource_group_name = var.aks_rg
  name                = var.aks_name
}

resource "kubernetes_namespace" "flux" {
  metadata {
    name = var.flux_namespace
  }
}

resource "helm_release" "flux" {
  name      = "flux"
  repository = "https://charts.fluxcd.io"
  chart     = "flux"
  #version = "3.3.3"
  namespace = kubernetes_namespace.flux.metadata[0].name
  
  set {
    name  = "git.url"
    value = var.flux_repo
  }
  
  set {
    name  = "git.path"
    value = var.flux_path
  }
  
  set {
    name  = "git.pollInterval"
    value = var.flux_poll_interval
  }
  
  set {
    name = "registry.acr.enabled"
    value = true
  }

  set {
    name  = "manifestGeneration"
    value = true
  }
}

resource "helm_release" "helm-operator" {
  name      = "helm-operator"
  repository = "https://charts.fluxcd.io"
  chart     = "helm-operator"
  #version = "3.3.3"
  namespace = kubernetes_namespace.flux.metadata[0].name

  set {
    name  = "git.ssh.secretName"
    value = "flux-git-deploy"
  }

  set {
    name  = "helm.versions"
    value = "v3"
  }

  depends_on = [
    helm_release.flux
  ]
}