#HTTP solo desde ALB
resource "aws_security_group" "web_sg" {
  name        = "isc-web-sg"
  description = "SG para instancias web"
  vpc_id      = aws_vpc.isc_vpc.id

  # Solo definimos egress inline; las reglas de ingreso se manejan con aws_security_group_rule
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

#SG ALB
resource "aws_security_group" "alb_sg" {
  name        = "isc-alb-sg"
  description = "SG para el Application Load Balancer"
  vpc_id      = aws_vpc.isc_vpc.id

  # Permitir HTTP desde Internet hacia el ALB
  ingress {
    description = "HTTP publico hacia el ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Todo el trafico saliente permitido
  egress {
    description = "Trafico saliente del ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "isc-alb-sg"
    Proyecto = "ISC-Obligatorio"
    Rol      = "alb"
  }
}

#SG Base de datos
resource "aws_security_group" "db_sg" {
  name        = "isc-db-sg"
  description = "SG base de datos en subredes privadas"
  vpc_id      = aws_vpc.isc_vpc.id

  egress {
    description = "Trafico saliente de la base de datos"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "isc-db-sg"
    Proyecto = "ISC-Obligatorio"
    Rol      = "db"
  }
}

#Permitir MySQL solo desde el Security Group de las instancias web
resource "aws_security_group_rule" "db_in_from_web" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

#HTTP desde ALB hacia web
resource "aws_security_group_rule" "web_http_in_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "HTTP desde el ALB"
}

# SSH abierto a todos (solo por motivos de lab)
resource "aws_security_group_rule" "web_ssh_in_lab" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.web_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "SSH laboratorio (0.0.0.0/0, a restringir en produccion)"
}


