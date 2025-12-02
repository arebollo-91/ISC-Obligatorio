resource "aws_vpc" "isc_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "isc-vpc-app"
    Proyecto = "ISC-Obligatorio"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.isc_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name     = "isc-public-a"
    Tipo     = "publica"
    Proyecto = "ISC-Obligatorio"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.isc_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name     = "isc-public-b"
    Tipo     = "publica"
    Proyecto = "ISC-Obligatorio"
  }
}

resource "aws_internet_gateway" "isc_igw" {
  vpc_id = aws_vpc.isc_vpc.id

  tags = {
    Name     = "isc-igw"
    Proyecto = "ISC-Obligatorio"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.isc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.isc_igw.id
  }

  tags = {
    Name     = "isc-public-rt"
    Tipo     = "publica"
    Proyecto = "ISC-Obligatorio"
  }
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}
