resource "aws_instance" "web1" {
  ami           = "ami-0fa3fe0fa7920f68e"
  instance_type = "t3.micro"

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
              dnf install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>ISC Obligatorio - Servidor web 1</h1>" > /var/www/html/index.html
              EOF
}
