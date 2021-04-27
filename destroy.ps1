<# 
Intro
.NOTES
  Version:        0.1
  Author:         Mikko Kasanen (lemoni.cloud)
  Creation Date:  4-26-2021
#>



echo "AKS Destroyer (in reverse order)"

# Destroying AzureDNS
echo "Destroying AzureDNS..."

cd .\2-azuredns

terraform init

terraform plan -var-file="../test.tfvars" -out "out.plan"

terraform destroy -auto-approve

echo "AzureDNS destroyed..."

cd ..

# Destroying AKS cluster with OMS (Log Analytics)
cd .\1-aks-cluster

echo "Destroying AKS Cluster..."

terraform init -backend-config="storage_account_name=$Storage_Account_Name" -backend-config="container_name=tfstate" -backend-config="access_key=$KEY1" -backend-config="key=$simpleprefix-akscluster.$environment.tfstate" -backend-config="resource_group_name=$storage_account_rg" 

terraform plan -var-file="../test.tfvars" -out "out.plan"

terraform destroy -auto-approve

echo "AKS Cluster destroyed..."

cd ..

# Destroying Azure Storage for state management
cd .\0-azure-storage-tfstate

echo "Destroying Azure Storage..."

terraform init
terraform plan -var-file="../test.tfvars" -out "out.plan"
terraform destroy -auto-approve

echo "Azure Storage destroyed..."
echo "Bang, koodit on poissa..."

cd ..