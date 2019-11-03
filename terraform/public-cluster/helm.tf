# Define the helm provider to use the AKS cluster
provider "helm" {
  version = "0.10.4"

  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }

  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.14.1"
  service_account = "tiller"

  override = [
    "spec.template.spec.nodeSelector.beta\\.kubernetes\\.io/os=linux"
  ]
}

module "tiller" {
  source  = "../modules/tiller"
}