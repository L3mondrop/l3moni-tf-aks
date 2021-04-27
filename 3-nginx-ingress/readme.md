### 
1. helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
2. terraform init
3. terraform plan -var-file="../test.tfvars" -out "out.plan"
4. terraform apply "out.plan"