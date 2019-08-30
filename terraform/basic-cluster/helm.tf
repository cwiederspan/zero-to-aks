# Define the helm provider to use the AKS cluster
provider "helm" {
  version = "0.10"

  kubernetes {
    host = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate = base64decode(
      azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate,
    )
    client_key = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(
      azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate,
    )
  }

  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.14.1"
  service_account = "tiller"
}

# Install a load-balanced nginx-ingress controller onto the cluster
resource "helm_release" "ingress" {
  name      = "nginx-ingress"
  chart     = "stable/nginx-ingress"
  namespace = var.ingress_namespace

  values = [
    <<EOF
controller:
  replicaCount: 2
  healthStatus: "true"
EOF
    ,
  ]

  depends_on = [kubernetes_cluster_role_binding.tiller]
}

