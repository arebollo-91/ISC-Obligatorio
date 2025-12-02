resource "aws_lb_target_group" "web_tg" {
  name     = "isc-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.isc_vpc.id

  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = "/"
    matcher             = "200-399"
  }

  tags = {
    Name     = "isc-web-tg"
    Proyecto = "ISC-Obligatorio"
    Rol      = "web"
  }
}

# Asociar instancia web 1 a TG
resource "aws_lb_target_group_attachment" "web1_attachment" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

#Public LB
resource "aws_lb" "web_alb" {
  name               = "isc-web-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  enable_deletion_protection = false

  tags = {
    Name     = "isc-web-alb"
    Proyecto = "ISC-Obligatorio"
    Rol      = "alb"
  }
}

# Listener HTTP/80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

#Asociar web2 a TG
resource "aws_lb_target_group_attachment" "web2_attachment" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

