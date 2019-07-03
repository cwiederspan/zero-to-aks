data "helm_repository" "shared" {
    name = "cdwmshelm"
    url  = "https://cdwmshelm.z5.web.core.windows.net"
}

# Install a sample application to test connectivity
resource "helm_release" "hello-world" {
  name       = "hello-world-app"
  repository = "${data.helm_repository.shared.metadata.0.name}"
  chart      = "shared-chart"
  namespace  = "sample-app"

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
  hosts:
  - host: ""
    paths:
    - /helloworld
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /
EOF
  ]
}