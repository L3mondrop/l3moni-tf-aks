L3moni Terraform & AKS Example

The purpose of this repo is to demonstrate how to:

1. Setup a simple AKS Cluster with Terraform
2. Utilize Azure Storage for .tfstate management
3. Utilize Null Resource from Terraform to do things such as installing Helm repos
4. Install Helm charts with TF Helm provider
5. Setup Azure Key Vault using managed identities / service principal with Terraform

Under consideration:

1. Service Mesh installation during cluster creation (Istio?)