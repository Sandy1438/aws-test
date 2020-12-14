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

  subnet_id      = aws_subnet.subnet.*.id[count.index]
  route_table_id = aws_route_table.route.id

  tags = {
      "Name" = "eks_route_link"
  }
}