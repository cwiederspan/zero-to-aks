# Zero to Kubernetes on Azure

This project shows several examples of using Terraform to create a fully functioning Kubernetes
cluster with Azure's managed AKS service.

## Getting Started

Clone this repository down to either your local machine or to your Azure Cloud Shell.

```bash
git clone https://github.com/cwiederspan/zero-to-aks.git
```

## Shared Features

### Remote State Storage

Each variation outlined below is designed to store the Terraform state in Azure blob storage. As part
of that, you must configure and initialize things appropriately. To do so, you will need to update the
values in a file called `sample-backend-secrets.tfvars` and remove the `sample-` from the file name.

> NOTE: Do not check this file into your git repo!

Now you can initialize Terraform, specifying the file above for the config.

```bash
terraform init --backend-config backend-secrets.tfvars
```

### Secret Variables

Rename the `sample-secrets.tfvars` file to `secrets.tfvars` and update the values in that file.

### Variable Values

Update any/all values in the `terraform.tfvars` file to meet your needs.

### Service Principal Setup

Docs coming soon.

### Helm Installation

Docs coming soon.

### Ingress Installation

Docs coming soon.

### Sample App Installation

Docs coming soon.

## Cluster Variations

Currently, there are three variations of AKS clusters that you can create:

  * [Basic Cluster](/basic-cluster/README.md) - A no-frills cluster with minimal configuration
  and no explicit networking defined, which means it will default to kubenet.

  * [Public Cluster](/public-cluster/README.md) - A public-facing cluster with Azure CNI networking
    defined, resulting in a fully functional VNET and exposed through an external load balancer (ELB).

  * [Private Cluster](/private-cluster/README.md) - A cluster built with Azure CNI networking that
    is deployed with an internal load balancer (ILB), and is publicly exposed via an Azure App Gateway.
