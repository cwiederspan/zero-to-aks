resource "helm_release" "ingress" {
  name      = "nginx-ingress"
  chart     = "stable/nginx-ingress"
  namespace = "nginx-ingress-controller"
}