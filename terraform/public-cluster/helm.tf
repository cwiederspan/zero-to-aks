# Define the helm provider to use the AKS cluster
provider "helm" {

  kubernetes {
    host = "${azurerm_kubernetes_cluster.aks.kube_config.0.host}"

    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
  }

  tiller_image    = "gcr.io/kubernetes-helm/tiller:v2.14.1"
  service_account = "tiller"
}

data "helm_repository" "private" {
    name     = "cdwms"
    url      = "https://cdwms.azurecr.io/helm/v1/repo/"
    username = "cdwms"
    password = "${var.helm_repo_password}"
}

# Install a load-balanced nginx-ingress controller onto the cluster
resource "helm_release" "ingress" {
  name      = "nginx-ingress"
  chart     = "stable/nginx-ingress"
  namespace = "${var.ingress_namespace}"

  values = [<<EOF
controller:
  replicaCount: 2
  healthStatus: "true"
EOF
  ]

  depends_on = ["kubernetes_cluster_role_binding.tiller"]
}

# Install a sample application to test connectivity
resource "helm_release" "hello-world" {
  name       = "hello-world-app"
  repository = "${data.helm_repository.private.metadata.0.name}"
  chart      = "shared-chart"
  namespace  = "testing"

  values = [<<EOF
fullname: hello-world-application
name: hello-world
image:
  repository: appsvcsample/python-helloworld
  tag: latest
service:
  type: ClusterIP
  port: 80
  targetPort: http
  protocol: TCP
  portName: http
probes:
  enabled: false
ingress:
  enabled: true
  path: /helloworld
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /
EOF
  ]

  depends_on = ["helm_release.ingress"]
}
