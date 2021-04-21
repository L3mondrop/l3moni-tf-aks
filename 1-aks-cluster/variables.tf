variable "prefix" {
  description = "A prefix used for all resources in this example"
  default = "l3monitfdelete"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default = "West Europe"
}

variable "environment" {
  description = "Environment, prod, test etc."
  default = "test"
}