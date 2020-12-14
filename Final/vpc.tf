resource "aws_vpc" "vpc" {
  cidr_block = var.vpc

  tags = map(
    "Name", "terraform-eks-vpc",
    "kubernetes.io/cluster/${var.eks-cluster-name}", "shared",
  )
}

resource "aws_subnet" "subnet" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.vpc.id
  map_public_ip_on_launch = true

  tags = map(
    "Name", "terraform-eks-subnet",
    "kubernetes.io/cluster/${var.eks-cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "terraform-eks-gw"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "route_link" {
  count = 2

  subnet_id      = aws_subnet.subnet.*.id[count.index]
  route_table_id = aws_route_table.route.id
}

data "aws_subnet_ids" "subnet_id" {
  vpc_id = aws_vpc.vpc.id

  depends_on = [ 
    aws_subnet.subnet
   ]
}