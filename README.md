## Description:

A project aimed at facilitating the creation of infrastructure based on the [Terraform supermodule for the Terraform platform engineering for Azure](https://registry.terraform.io/modules/aztfmod/caf/azurerm/latest)

## Create aks environment using uzrerm CAF supermodule:

```
az login
terraform init
terraform plan -out aks-dev.plan -var-file=develop.tfvars
terraform apply "aks-dev.plan"
az aks get-credentials --name develop-aks-akscluster-dev1-001 --resource-group develop-rg-az-lx-rg-aks
az aks install-cli
kubectl get nodes
```
Get the id of the logged in account
`terraform output account_id`

## Destroy environment using terraform:

```
terraform plan -destroy -out aks-dev.destroy -var-file=develop.tfvars
terraform apply "aks-dev.destroy"
```
### Optional destroy of all resources in a given subscription (bash):

```
az group list -o json | jq '.[] | .name' | xargs -L1 bash -c 'az group delete -n $0 --no-wait -y'
```

Important parameters defined in the example develop.tfvars file:

| Attribute | example value | meaning |
|---|---|---|
| default_node_pool['vm_size'] | Standard_B2s | defines the size of the AKS cluster memeber node |
| global_settings['regions']['region1'] | westeurope | defines the region where resources are created |
| aks_clusters['cluster_dev1']['name'] | akscluster-dev1-001 | cluster name |
