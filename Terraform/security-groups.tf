resource "aws_security_group" "web_sg" {
  name        = "isc-web-sg"
  description = "SG para instancias web"
  vpc_id      = aws_vpc.isc_vpc.id

  ingress {
    description = "HTTP desde Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH laboratorio"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Trafico saliente"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "isc-web-sg"
    Proyecto = "ISC-Obligatorio"
    Rol      = "web"
  }
}
