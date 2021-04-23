variable "prefix" {
  description = "A prefix used for all resources in this example"
  default = "default-tf"
}

variable "simpleprefix" {
  description = "Prefix without any special characters - in lowercase"
  default = "defaulttf"
}

variable "state_storage_rg_name" {
  description = "A name used for the resource group where Terraform remote states will be stored"
  default = "default-tf-state-rg"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default = "West Europe"
}

variable "tfstatename" {
  description = "tf state name"
  default = "tfstate"
}

variable "environment" {
  description = "Environment, prod, test etc."
  default = "test"
}