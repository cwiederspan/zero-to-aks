# Zero to Kubernetes on Azure

This project shows several examples of using Terraform to create a fully functioning Kubernetes
cluster with Azure's managed AKS service.

## Getting Started

Clone this repository down to either your local machine or to your Azure Cloud Shell.

```bash
git clone https://github.com/cwiederspan/zero-to-aks.git
```

## Prerequisites

### Remote State Storage

This sample is designed to store the Terraform state in Azure blob storage. As part
of that, you must configure and initialize things appropriately. To do so, you will need to update the
values in a file called `backend-secrets-sample.tfvars` and remove the `-sample` from the file name.

> NOTE: Do not check this file into your git repo!

Now you can initialize Terraform, specifying the file above for the config.

```bash
cd terraform

terraform init --backend-config backend-secrets.tfvars

# Alternative approach is to create a backend-secrets.tfvars file
echo -e "storage_account_name = \"YOUR_STORAGE_ACCT_NAME\"\ncontainer_name = \"YOUR_STORAGE_CONTAINER\"\nkey = \"cluster.tfstate\"\naccess_key = \"YOUR_STORAGE_ACCT_KEY\"" >> backend-secrets.tfvars
```

### Secret Variables

Rename the `secrets-sample.tfvars` file to `secrets.tfvars` and update the values in that file.

## Terraform the Cluster

```bash

# Run the plan to see the changes
terraform plan \
-var 'name_prefix=cdw' \
-var 'name_base=kubernetes' \
-var 'name_suffix=20201215' \
-var 'location=westus2' \
-var 'node_count=2' \
-var 'enable_azure_policy=true' \
-var 'acr_rg_name=cdw-shared-resources' \
-var 'acr_name=cdwms' \
--var-file=secrets.tfvars


# Apply the script with the specified variable values
terraform apply \
-var 'name_prefix=cdw' \
-var 'name_base=kubernetes' \
-var 'name_suffix=20201215' \
-var 'location=westus2' \
-var 'node_count=2' \
-var 'enable_azure_policy=true' \
-var 'acr_rg_name=cdw-shared-resources' \
-var 'acr_name=cdwms' \
--var-file=secrets.tfvars

```
