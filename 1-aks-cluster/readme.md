### 1. PS Set variables for init:  

Set-Variable -Name KEY1 -Value (terraform -chdir="../0-azure-storage-tfstate" output key1)

Set-Variable -Name Storage_Account_Name -Value (terraform -chdir="../0-azure-storage-tfstate" output storage_account_name)

Set-Variable -Name Storage_Account_Rg -Value (terraform -chdir="../0-azure-storage-tfstate" output storage_account_rg)

Set-Variable -Name simpleprefix -Value (terraform -chdir="../0-azure-storage-tfstate" output simpleprefix)

Set-Variable -Name environment -Value (terraform -chdir="../0-azure-storage-tfstate" output environment)

### 3. Setting the init for remote state 

 terraform init -backend-config="storage_account_name=$Storage_Account_Name" -backend-config="container_name=tfstate" -backend-config="access_key=$KEY1" -backend-config="key=$simpleprefix-akscluster.$environment.tfstate" -backend-config="resource_group_name=$storage_account_rg" 

### 4. Create terraform plan with values given from the root (test.tfvars) instead of variables.tf defaults
terraform plan -var-file="../test.tfvars" -out "out.plan"

### 5. Apply the previosly created plan 
terraform apply "out.plan"
