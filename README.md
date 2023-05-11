Powołanie infrastruktury:

Projekt mający na celu ułatwienie wystawiania infrastruktury w oparciu o [Terraform supermodule for the Terraform platform engineering for Azure](https://registry.terraform.io/modules/aztfmod/caf/azurerm/latest)

Powołanie środowiska:
```
terraform init
terraform plan -out aks-dev.plan -var-file=develop.tfvars
terraform apply "aks-dev.plan"
AKS_ID=$(az aks show --name develop-aks-akscluster-dev1-001 --resource-group develop-rg-az-lx-rg-aks --query id -o tsv)
AZURE_USERNAME=$(az account show -o json --query "{user:user.name}" -o tsv)
az role assignment create --assignee "${AZURE_USERNAME}" --role "Azure Kubernetes Service RBAC Cluster Admin" --scope $AKS_ID
az aks list -o table
az aks get-credentials --name develop-aks-akscluster-dev1-001 --resource-group develop-rg-az-lx-rg-aks
az aks install-cli
kubectl get nodes
```
Zniszczenie powołanego środowiska z użyciem terraform:
```
terraform plan -destroy -out aks-dev.destroy -var-file=develop.tfvars
terraform apply "aks-dev.destroy"
```
Zniszczenie wszystkich zasobów w danej subskrypcji (linux):
```
az group list -o json | jq '.[] | .name' | xargs -L1 bash -c 'az group delete -n $0 --no-wait -y'
```

Istotne parametry zdefiniowane w przykładowym pliku develop.tfvars:

| Atrybut | przykładowa wartość | znaczenie |
|---|---|---|
| default_node_pool['vm_size'] | Standard_B2s | definiuje wielkość maszyny składowej klastra AKS |
| global_settings['regions']['region1'] | westeurope | definiuje region, w którym powoływane są zasoby |
| aks_clusters['cluster_dev1']['name'] | akscluster-dev1-001 | nazwa powoływanego klastra |
