output "alura_go_api_dev_public_ip" {
  value = aws_instance.alura-go-api-dev.public_ip
}

output "db_endpoint" {
  description = "Address of the PostgreSQL database"
  value       = aws_db_instance.postgres-alura-go-dev.address
}

output "db_port" {
  description = "Port used by the database"
  value       = aws_db_instance.postgres-alura-go-dev.port
}

output "sg_ssh_id" {
  description = "ID do Security Group de SSH"
  value       = aws_security_group.asg-acesso-ssh.id
}