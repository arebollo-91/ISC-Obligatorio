variable "region" {
  description = "Region de AWS"
  type        = string
  default     = "us-east-1"
}

variable "perfil_admin" {
  description = "Perfil de AWS para credenciales"
  type        = string
  default     = "default"
}

#Credenciales admin DB
variable "db_username" {
  description = "Usuario administrador de la base de datos"
  type        = string
}

variable "db_password" {
  description = "Password del usuario de la base de datos"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nombre de la base de datos a crear"
  type        = string
  default     = "isc_app_db"
}
