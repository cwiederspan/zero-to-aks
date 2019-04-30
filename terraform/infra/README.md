# Quick Notes

## Create some storage in Azure

## Create a backend-secrets.tfvars file

```hcl
storage_account_name = "cdwterraformstate"
container_name       = "zero-to-azure"
key                  = "cdw-kubernetes-20190417/Production.tfstate"
access_key           = "XXX"
```

```bash
terraform init -reconfigure -backend-config=./backend-secrets.tfvars
```

## Create a service principal

```bash
az ad sp create-for-rbac --name <YOUR_SP_NAME> --skip-assignment
```

## Create secrets.tfvars

```hcl
service_principal_name = "29b2330a-XXXX-XXXX-XXXX-ad7c3b68d92d"
service_principal_pwd  = "636e6df5-XXXX-XXXX-XXXX-94fa02063ec2"
```

## Execute the Terraform

```bash
terraform apply -var-file=secrets.tfvars
```

## Install Helm/Tiller

<https://docs.microsoft.com/en-us/azure/aks/kubernetes-helm>

```bash
kubectl apply -f helm-rbac.yaml

helm init --service-account tiller
```

## Log into the Cluster

```bash
az aks get-credentials -g cdw-kubernetes-20190417 -n cdw-kubernetes-20190417

# From ingress folder
terraform init
```

```bash
# Create a namespace for your ingress resources
kubectl create namespace ingress-basic

# Use Helm to deploy an NGINX ingress controller
helm install stable/nginx-ingress --namespace ingress-basic --set controller.replicaCount=2
```

## Misc Tidbits

```bash
az aks get-credentials -n cdw-kubernetes-20190417 -g cdw-kubernetes-20190417 --overwrite-existing



```