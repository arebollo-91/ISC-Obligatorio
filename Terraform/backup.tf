#Creacion bucket S3
resource "aws_s3_bucket" "backups" {
  bucket = "isc-obligatorio-backups-arebollo"

  tags = {
    Name     = "isc-obligatorio-backups"
    Proyecto = "ISC-Obligatorio"
    Rol      = "backups"
  }
}

#Versionado para poder recuperar archivos borrados o modificados
resource "aws_s3_bucket_versioning" "backups_versioning" {
  bucket = aws_s3_bucket.backups.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Lyficycle Glacier
resource "aws_s3_bucket_lifecycle_configuration" "backups_lifecycle" {
  bucket = aws_s3_bucket.backups.id

  rule {
    id     = "backups-to-glacier"
    status = "Enabled"

    filter {
      prefix = "" #Todos los objetos del bucket
    }

    #Enviar objetos a clase de almacenamiento Glacier
    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    #Borrar los objetos
    expiration {
      days = 1095
    }
  }
}
