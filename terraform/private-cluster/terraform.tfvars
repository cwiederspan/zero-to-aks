name_prefix = "cdw"
name_base   = "kubernetes"
name_suffix = "20190518"

//location  = "westus"
location    = "westus2"   // Supports DevSpaces and ACI VNET Preview
                            // https://docs.microsoft.com/en-us/azure/dev-spaces/
                            // https://docs.microsoft.com/en-us/azure/container-instances/container-instances-vnet

aks_version = "1.14.8"
node_count  = "1"

ingress_namespace        = "ingress-basic"
ingress_load_balancer_ip = "10.0.2.10"

gateway_instance_count = "1"