#Subnet group para RDS utilizando las subredes privadas
resource "aws_db_subnet_group" "db_subnets" {
  name = "isc-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name     = "isc-db-subnet-group"
    Proyecto = "ISC-Obligatorio"
    Rol      = "db"
  }
}

#Instancia RDS MySQL en subredes privadas
resource "aws_db_instance" "app_db" {
  identifier     = "isc-app-db"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  allocated_storage = 20

  #Backups automaticos DB
  backup_retention_period = 7 # dias de retencion de backups automaticos

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  #Multi-AZ para mayor tolerancia a fallas
  multi_az = true

  #No exponer la DB directamente a Internet
  publicly_accessible = false

  skip_final_snapshot = true # entorno de laboratorio

  deletion_protection = false # para poder destruir en el lab sin problemas

  tags = {
    Name     = "isc-app-db"
    Proyecto = "ISC-Obligatorio"
    Rol      = "db"
  }
}
