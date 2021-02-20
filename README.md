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

## Create Kubernetes Cluster

[Instructions](/terraform/cluster/README.md)

## Install and Setup FluxCD

[Instructions](/terraform/flux/README.md)
