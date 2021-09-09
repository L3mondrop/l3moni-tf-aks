echo "AKS demo installer"

# Creating Azure Storage for state management
cd .\0-azure-storage-tfstate 
echo "Creating Storage account for states"
terraform init
terraform plan -var-file="../test.tfvars" -out "out.plan"
terraform apply "out.plan"

Set-Variable -Name KEY1 -Value (terraform  output key1)
Set-Variable -Name Storage_Account_Name -Value (terraform output storage_account_name)
Set-Variable -Name Storage_Account_Rg -Value (terraform output storage_account_rg)
Set-Variable -Name simpleprefix -Value (terraform output simpleprefix)
Set-Variable -Name environment -Value (terraform output environment)

cd ..

# Creating AKS cluster with OMS (Log Analytics)
cd .\1-aks-cluster
echo "Creating AKS Cluster"

terraform init -backend-config="storage_account_name=$Storage_Account_Name" -backend-config="container_name=tfstate" -backend-config="access_key=$KEY1" -backend-config="key=$simpleprefix-akscluster.$environment.tfstate" -backend-config="resource_group_name=$storage_account_rg" 
terraform plan -var-file="../test.tfvars" -out "out.plan"
terraform apply "out.plan"

Set-Variable -Name cluster_resource_group -Value (terraform output cluster_resource_group)
Set-Variable -Name cluster_name -Value (terraform output cluster_name)

az aks get-credentials --resource-group $cluster_resource_group --name $cluster_name
cd ..

# Creating AzureDNS to be used by ExternalDNS
cd .\2-azuredns
echo "Creating AzureDNS"
terraform init -backend-config="storage_account_name=$Storage_Account_Name" -backend-config="container_name=tfstate" -backend-config="access_key=$KEY1" -backend-config="key=$simpleprefix-azuredns.$environment.tfstate" -backend-config="resource_group_name=$storage_account_rg"
terraform plan -var-file="../test.tfvars" -out "out.plan"
terraform apply "out.plan"
cd ..


# Installing NGINX Ingress with Helm + creating a namespace "ingress-basic"
cd .\3-nginx-ingress
echo "Installing NGINX-Ingress to Cluster"

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

terraform init -backend-config="storage_account_name=$Storage_Account_Name" -backend-config="container_name=tfstate" -backend-config="access_key=$KEY1" -backend-config="key=$simpleprefix-nginxingress.$environment.tfstate" -backend-config="resource_group_name=$storage_account_rg"
terraform plan -var-file="../test.tfvars" -out "out.plan"
terraform apply "out.plan"
cd ..

# Installing cert-manager
cd .\4-cert-manager


