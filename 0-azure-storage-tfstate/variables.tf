variable "prefix" {
  description = "A prefix used for all resources in this example"
  default = "l3monitf"
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