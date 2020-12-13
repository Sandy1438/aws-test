terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.regin
}

provider "http" {}

/*resource "aws_s3_bucket" "terraform_state" {
  bucket = "love-bonito-bucket"
  #acl    = "private"

  versioning {
    enabled = true
  }

 /* server_side_encryption_configuration {
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}*/

/*resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}*/

terraform {
  backend "s3" {
    bucket = "love-bonito-bucket"
    key    = "terraform-eks/terraform.tfstate"
    region = "ap-south-1"
    #dynamodb_table = "terraform-state-locks"
    #encrypt        = true
  }
}

module "vpc" {
  source = module/vpc
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "love-bonito-k8cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version = "13.2.0"
  cluster_name    = var.eks-cluster-name
  cluster_version = "1.18"
  subnets         = tolist(data.aws_subnet_ids.subnet_id.ids)
  vpc_id          = module.vpc.id

  node_groups = [
    {
      instance_name = "eks_worker"
      instance_type = "t2.micro"
      max_capacity     = 5
      desired_capacity = 3
      min_capacity     = 1
    }
  ]
  write_kubeconfig   = true
  config_output_path = "./"
}


data "aws_subnet_ids" "subnet_id" {
  vpc_id = module.vpc.id

  depends_on = [ 
    module.vpc.subnet
   ]
}

data "aws_eks_cluster" "cluster" {
  name = module.love-bonito-k8cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.love-bonito-k8cluster.cluster_id
}
