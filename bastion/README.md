# How to Create and Use a Bastion Container

```bash
docker build -t cwiederspan/bastion:latest .

docker push cwiederspan/bastion:latest

az container create -n cdw-kubernetes-20201215-aci -g cdw-kubernetes-20201215 -l westus2 \
  --image cwiederspan/bastion:latest \
  --vnet cdw-kubernetes-20201215-vnet \
  --subnet bastion-subnet

az container exec -n cdw-kubernetes-20201215-aci -g cdw-kubernetes-20201215 --exec-command './bin/bash'
```