#VPC
resource "aws_vpc" "isc_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name     = "isc-vpc-app"
    Proyecto = "ISC-Obligatorio"
  }
}

#Subnet public_a
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

#Subnet public_b
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

#IGW para salida a internet
resource "aws_internet_gateway" "isc_igw" {
  vpc_id = aws_vpc.isc_vpc.id

  tags = {
    Name     = "isc-igw"
    Proyecto = "ISC-Obligatorio"
  }
}

#RT
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

#Asociacion de RT a public subnet
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

#Subnet privada_a
resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.isc_vpc.id
  cidr_block              = "10.0.11.0/24"      
  availability_zone       = "us-east-1a"        # misma AZ que public_a
  map_public_ip_on_launch = false               

  tags = {
    Name     = "isc-private-a"
    Proyecto = "ISC-Obligatorio"
    Tipo     = "privada"
  }
}

#Subnet privada_b
resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.isc_vpc.id
  cidr_block              = "10.0.12.0/24"      
  availability_zone       = "us-east-1b"        # misma AZ que public_b
  map_public_ip_on_launch = false

  tags = {
    Name     = "isc-private-b"
    Proyecto = "ISC-Obligatorio"
    Tipo     = "privada"
  }
}

#RT subredes privadas
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.isc_vpc.id

  tags = {
    Name     = "isc-private-rt"
    Proyecto = "ISC-Obligatorio"
    Tipo     = "privada"
  }
}

# Asociaciones RT a subredes privadas
resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}
