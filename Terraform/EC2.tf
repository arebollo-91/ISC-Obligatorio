#Template para instancias web - ASG

resource "aws_launch_template" "web_lt" {
  name_prefix   = "isc-web-lt-"
  image_id      = "ami-0fa3fe0fa7920f68e"
  instance_type = "t3.micro"

  key_name = "vockey"

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = base64encode(<<-EOT
    #!/bin/bash
    dnf update -y

    # Instalar Docker
    dnf install -y docker
    systemctl enable docker
    systemctl start docker

    # (Opcional) dar permisos a ec2-user
    usermod -aG docker ec2-user

    # Levantar contenedor web en puerto 80
    docker rm -f webapp 2>/dev/null || true

    docker run -d \
      --name webapp \
      -p 80:80 \
      nginx
  EOT
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name     = "isc-web-asg"
      Proyecto = "ISC-Obligatorio"
      Rol      = "web"
    }
  }
}

#Autoscaling
resource "aws_autoscaling_group" "web_asg" {
  name                      = "isc-web-asg"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"

  # Subredes publicas en distintas AZ
  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  # Registrar instancias del ASG en el mismo Target Group del ALB
  target_group_arns = [
    aws_lb_target_group.web_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "isc-web-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Proyecto"
    value               = "ISC-Obligatorio"
    propagate_at_launch = true
  }

  tag {
    key                 = "Rol"
    value               = "web"
    propagate_at_launch = true
  }
}

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
