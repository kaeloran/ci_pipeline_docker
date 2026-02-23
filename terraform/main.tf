terraform {
  backend "s3" {
    bucket = "alura-bucket-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {    
  region = "us-east-1"
}

resource "aws_instance" "alura-go-api-dev" {
    ami           = var.amis["us-east-1"]
    instance_type = "t3.micro"
    key_name      = var.key_name
        
    iam_instance_profile = "GitHubActionsEc2SSMRole"
    
    vpc_security_group_ids = [
      aws_security_group.asg-acesso-ssh.id,
      aws_security_group.asg-alura-go-api-dev.id,
    ]

    user_data = <<-EOF
              #!/bin/bash
              # 1. Atualiza a lista de repositórios e instala o cliente postgres
              # No Ubuntu, o pacote é 'postgresql-client'
              sudo apt-get update -y
              sudo apt-get install -y postgresql-client

              # 2. Configura as variáveis
              export PGPASSWORD='${local.db_creds.password}'
              export DB_HOST='${aws_db_instance.postgres-alura-go-dev.address}'
              export DB_USER='${aws_db_instance.postgres-alura-go-dev.username}'
              export APP_DB_NAME='${var.db_name}'

              # 3. Loop para esperar o RDS estar pronto (timeout de ~2.5 min)
              for i in {1..15}; do
                if psql -h $DB_HOST -U $DB_USER -d postgres -c "select 1" > /dev/null 2>&1; then
                  echo "RDS está pronto!"
                  break
                fi
                echo "Aguardando RDS..."
                sleep 10
              done

              # 4. Verifica se o banco existe e cria se necessário
              DB_EXISTS=$(psql -h $DB_HOST -U $DB_USER -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$APP_DB_NAME'")

              if [ "$DB_EXISTS" != "1" ]; then
                echo "Criando banco de dados $APP_DB_NAME..."
                psql -h $DB_HOST -U $DB_USER -d postgres -c "CREATE DATABASE $APP_DB_NAME;"
              else
                echo "Banco de dados $APP_DB_NAME já existe."
              fi
              EOF

    tags = {
        Name = "alura-go-api-dev"
    }

    depends_on = [aws_db_instance.postgres-alura-go-dev]
}

data "aws_secretsmanager_secret" "db" {
  name = "alura_db_go_credentials"
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

resource "aws_db_instance" "postgres-alura-go-dev" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "17"
  instance_class       = "db.t3.micro"        
  username             = var.db_username != null ? var.db_username : local.db_creds.username
  password             = var.db_password != null ? var.db_password : local.db_creds.password
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true
  publicly_accessible  = false
  vpc_security_group_ids = [ aws_security_group.rds.id ]

  tags = {
    Name = "postgres-alura-go-dev"
  }
}

