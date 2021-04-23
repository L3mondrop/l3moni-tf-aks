1. terraform init
2. terraform plan -var-file="../test.tfvars" -out "out.plan"
3. terraform apply "out.plan"
4. terraform output key1   