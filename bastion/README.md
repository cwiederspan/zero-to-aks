# How to Create and Use a Bastion Container

```bash
docker build -t cwiederspan/bastion:latest .

docker push cwiederspan/bastion:latest

az container create -n cdw-kubernetes-20190518-aci -g cdw-kubernetes-20190518 -l westus2 \
  --image cwiederspan/bastion:latest \
  --vnet cdw-kubernetes-20190518-vnet \
  --subnet bastion-subnet

az container exec -n cdw-kubernetes-20190518-aci -g cdw-kubernetes-20190518 --exec-command './bin/bash'
```