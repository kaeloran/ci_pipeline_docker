provider "postgresql" {
  alias           = "pg"
  host            = aws_db_instance.postgres-alura-go-dev.address
  port            = aws_db_instance.postgres-alura-go-dev.port
  username        = aws_db_instance.postgres-alura-go-dev.username
  password        = aws_db_instance.postgres-alura-go-dev.password
  sslmode         = "require"
  connect_timeout = 15

  database        = "postgres"
}


resource "postgresql_database" "app_db" {
  provider = postgresql.pg

  name  = var.db_name 
  owner = aws_db_instance.postgres-alura-go-dev.username
}
