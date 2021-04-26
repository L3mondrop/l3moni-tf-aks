echo "AKS installer"

# Creating Azure Storage for state management
cd .\0-azure-storage-tfstate

terraform init
terraform plan -var-file="../test.tfvars" -out "out.plan"
terraform apply "out.plan"
terraform output key1  

cd ..

# Creating AKS cluster with OMS (Log Analytics)
cd .\1-aks-cluster

Set-Variable -Name KEY1 -Value (terraform -chdir="../0-azure-storage-tfstate" output key1)

Set-Variable -Name Storage_Account_Name -Value (terraform -chdir="../0-azure-storage-tfstate" output storage_account_name)

Set-Variable -Name Storage_Account_Rg -Value (terraform -chdir="../0-azure-storage-tfstate" output storage_account_rg)

Set-Variable -Name simpleprefix -Value (terraform -chdir="../0-azure-storage-tfstate" output simpleprefix)

Set-Variable -Name environment -Value (terraform -chdir="../0-azure-storage-tfstate" output environment)

terraform init -backend-config="storage_account_name=$Storage_Account_Name" -backend-config="container_name=tfstate" -backend-config="access_key=$KEY1" -backend-config="key=$simpleprefix-akscluster.$environment.tfstate" -backend-config="resource_group_name=$storage_account_rg" 

terraform plan -var-file="../test.tfvars" -out "out.plan"

terraform apply "out.plan"

cd ..

# Creating AzureDNS

cd .\2-azuredns

terraform init

terraform plan -var-file="../test.tfvars" -out "out.plan"

terraform apply "out.plan"

cd ..

# Installing NGINX Ingress