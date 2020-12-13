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

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc
  instance_tenancy = "default"

  tags = {
    "Name" = "eks_vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
  "Name" = "eks_int_gw"
  }
}

resource "aws_subnet" "subnet" {
  for_each   = local.az-subnet
  vpc_id     = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block = each.value.private_love-bonito_cidr
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw]

  tags = {
    "Name" = "eks_subnets"
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/${var.eks-cluster-name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }  
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
      "Name" = "eks_route"
  }
}

resource "aws_route_table_association" "route_link" {
  count = 2
  subnet_id = aws_subnet.subnet.*.subnet_id[count.index]
  route_table_id = aws_route_table.route.id
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
  vpc_id          = aws_vpc.vpc.id

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
  vpc_id = aws_vpc.vpc.id

  depends_on = [ 
    aws_subnet.subnet
   ]
}

data "aws_eks_cluster" "cluster" {
  name = module.love-bonito-k8cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.love-bonito-k8cluster.cluster_id
}
