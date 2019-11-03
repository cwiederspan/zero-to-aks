# NOTE: This file may be different for different variations

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
  ]

  depends_on = [
    module.tiller.tiller_role_binding
  ]
}