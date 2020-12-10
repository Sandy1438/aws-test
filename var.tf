variable "vpc" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnet" {
  type = map(string)
  default = {
      private_love-bonito_cidr1 : "10.0.1.0/24"
      private_love-bonito_cidr2 : "10.0.2.0/24"
  }
}

variable "regin" {
  type = string
  default = "ap-south-1"
}