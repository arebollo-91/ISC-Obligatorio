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
