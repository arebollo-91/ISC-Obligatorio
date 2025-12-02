# Networking

output "vpc_id" {
  description = "ID de la VPC principal del proyecto"
  value       = aws_vpc.isc_vpc.id
}

output "public_subnet_a_id" {
  description = "ID de la subnet publica A"
  value       = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  description = "ID de la subnet publica B"
  value       = aws_subnet.public_b.id
}

# Instancia web1
output "web1_id" {
  description = "ID de la instancia EC2 web1"
  value       = aws_instance.web1.id
}

output "web1_private_ip" {
  description = "IP privada de la instancia web1"
  value       = aws_instance.web1.private_ip
}

output "web1_public_ip" {
  description = "IP publica de la instancia web1"
  value       = aws_instance.web1.public_ip
}

output "web1_public_dns" {
  description = "DNS publico de la instancia web1"
  value       = aws_instance.web1.public_dns
}

#Instancia Web2
output "web2_id" {
  description = "ID de la instancia EC2 web2"
  value       = aws_instance.web2.id
}

output "web2_private_ip" {
  description = "IP privada de la instancia web2"
  value       = aws_instance.web2.private_ip
}

output "web2_public_ip" {
  description = "IP publica de la instancia web2"
  value       = aws_instance.web2.public_ip
}

output "web2_public_dns" {
  description = "DNS publico de la instancia web2"
  value       = aws_instance.web2.public_dns
}

