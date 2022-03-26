resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_range
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.cidr_range, 8, 0) # Need to be able to hold maximum 11 instances
  availability_zone = "eu-west-2a"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

}

resource "aws_route_table_association" "public_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(local.cidr_range, 8, 2) # Need to be able to hold maximum 11 instances
  availability_zone = "eu-west-2a"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_eip" "nat_eip" {
  vpc   = true
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

}

resource "aws_route_table_association" "private_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.public.id
}