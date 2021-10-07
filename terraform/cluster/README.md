# Deploy Kubernetes

## Setup

Rename the `secrets-sample.tfvars` file to `secrets.tfvars` and update the values in that file.

## Terraform Init

```bash

cd terraform/cluster

terraform init --backend-config backend-secrets.tfvars

```

## Terraform Apply

```bash

# Run the plan to see the changes
terraform plan \
-var 'name_prefix=cdw' \
-var 'name_base=kubernetes' \
-var 'name_suffix=20211006' \
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
-var 'name_suffix=20211006' \
-var 'location=westus2' \
-var 'node_count=2' \
-var 'enable_azure_policy=true' \
-var 'acr_rg_name=cdw-shared-resources' \
-var 'acr_name=cdwms' \
--var-file=secrets.tfvars

```
