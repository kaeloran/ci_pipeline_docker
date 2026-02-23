output "db_endpoint" {
  description = "Address of the PostgreSQL database"
  value       = aws_db_instance.postgres-alura-go-dev.address
}

output "db_port" {
  description = "Port used by the database"
  value       = aws_db_instance.postgres-alura-go-dev.port
}

output "ec2_instance_id" {
  description = "ID da Instância EC2 (Necessário para o AWS SSM)"
  value       = aws_instance.alura-go-api-dev.id
}