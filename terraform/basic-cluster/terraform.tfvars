name_prefix = "cdw"
name_base   = "kubernetes"
name_suffix = "20191227"

//location  = "westus"
location    = "westus2"   // Supports DevSpaces and ACI VNET Preview
                            // https://docs.microsoft.com/en-us/azure/dev-spaces/
                            // https://docs.microsoft.com/en-us/azure/container-instances/container-instances-vnet

// az aks get-versions -l westus2 -o table
aks_version = "1.15.5"
node_count  = "1"

ingress_namespace = "ingress-basic"