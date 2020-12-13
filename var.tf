variable "vpc" {
  type    = string
  default = "10.0.0.0/16"
}

locals {
  az-subnet = {
    az-subnet1 = {
      private_love-bonito_cidr = "10.0.1.0/24"
      az = "ap-east-1a"
    }
    az-subnet2 = {
      private_love-bonito_cidr = "10.0.2.0/24"
      az = "ap-east-1b"
    }
    az-subnet2 = {
      private_love-bonito_cidr = "10.0.3.0/24"
      az = "ap-east-1c"
    }
  }
}

variable "regin" {
  type    = string
  default = "ap-east-1"
}

variable "eks-cluster-name" {
  type = string
  default = "love-bonito-k8cluster"
}