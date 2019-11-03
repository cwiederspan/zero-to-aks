# Create an AKS Cluster with an Internal Load Balancer Fronted by an App Gateway

## Setup

### Remote State and Variable Setup

Make sure you have followed the instructions on the root [README.md](../README.md) files section on setting
up and configuring the remote state that you will need when `terraform init...`, and that you have made the
necessary changes so that you have a `secrets.tfvars` and a `terraform.tfvars` file with the correct values.

## Terraform

```bash
terraform apply --var-file=secrets.tfvars
```
