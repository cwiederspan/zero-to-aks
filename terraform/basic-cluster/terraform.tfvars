name_prefix = "cdw"
name_base   = "kubernetes"
name_suffix = "20190829"

//location  = "westus"
location    = "westus2"   // Supports DevSpaces and ACI VNET Preview
                            // https://docs.microsoft.com/en-us/azure/dev-spaces/
                            // https://docs.microsoft.com/en-us/azure/container-instances/container-instances-vnet

#aks_version = "1.12.7"
#aks_version = "1.13.5"
aks_version = "1.14.6"
node_count  = "1"

ingress_namespace        = "ingress-basic"