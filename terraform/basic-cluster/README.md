# Create an AKS Cluster without VNET

## Notes

* Helm v2.14.0 doesn't work - upgrade to v2.14.1 instead

## Setup

### Remote Terraform State

Assuming you want to use remote cloud storage for you Terraform state files, 
create a file called **backend-secrets.tfvars**, and add information that looks like this:

```hcl
storage_account_name = "mystorageaccount"
container_name       = "my-aks-cluster"
key                  = "my-aks-cluster/Production.tfstate"
access_key           = "access-key-from-azure-storage"
```

### Secret Variables

Now setup a file called **secrets.tfvars** with your secrets that you need to execute
the Terraform script. The file will look like this:

```hcl

```