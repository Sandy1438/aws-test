variable "regin" {
  type    = string
  default = "ap-south-1"
}

variable "eks-cluster-name" {
  type = string
  default = "love-bonito-k8cluster"
}

variable "vpc" {
  type    = string
  default = "10.0.0.0/16"
}