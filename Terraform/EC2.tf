#Web1 instance

resource "aws_instance" "web1" {
  ami                    = "ami-0fa3fe0fa7920f68e"
  instance_type          = "t3.micro"
  key_name               = "vockey"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  tags = {
    Name     = "isc-web-1"
    Proyecto = "ISC-Obligatorio"
    Rol      = "web"
  }

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y

              #Instalar Docker
              dnf install -y docker
              systemctl enable docker
              systemctl start docker

              #Opcional) dar permisos a ec2-user
              usermod -aG docker ec2-user

              #Levantar contenedor web en puerto 80
              docker run -d \
                --name webapp \
                -p 80:80 \
                nginx
              EOF
}

#Web2 Instance
resource "aws_instance" "web2" {
  ami                    = "ami-0fa3fe0fa7920f68e"
  instance_type          = "t3.micro"
  key_name               = "vockey"
  subnet_id              = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  tags = {
    Name     = "isc-web-2"
    Proyecto = "ISC-Obligatorio"
    Rol      = "web"
  }

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y

              #Instalar Docker
              dnf install -y docker
              systemctl enable docker
              systemctl start docker

              #Permisos a ec2-user
              usermod -aG docker ec2-user

              #Levantar contenedor web en puerto 80
              docker run -d \
                --name webapp \
                -p 80:80 \
                nginx

              EOF
}
