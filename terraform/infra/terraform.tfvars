name_prefix = "cdw"
name_base   = "kubernetes"
name_suffix = "20190503"

location    = "centralus"

aks_version = "1.12.7"
# aks_version = "1.13.5"
#aks_version = "1.14.0"
node_count  = "1"

ingress_namespace        = "ingress-basic"
ingress_load_balancer_ip = "10.0.2.10"

gateway_instance_count = "2"