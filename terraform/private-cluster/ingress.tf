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
  service:
    loadBalancerIP: ${var.ingress_load_balancer_ip}
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
      service.beta.kubernetes.io/azure-load-balancer-internal-subnet: "${local.ingress_subnet_name}"
EOF
  ]

  depends_on = [
    module.tiller.tiller_role_binding
  ]
}