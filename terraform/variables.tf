variable "amis" {
    type = map
    default = {
        "us-east-1" = "ami-0c1fe732b5494dc14"
    }     
}

variable "cdirs_acesso_remoto" {
    description = "A list of CIDR blocks to allow remote access from. To be provided via secrets."
    type = list(string)
}

variable "key_name" {
    type = string
    default = "terraform-aws"
}

variable "db_username" {
    type        = string
    description = "Master username for the PostgreSQL instance. If not set, Terraform will attempt to read from AWS Secrets Manager."
    sensitive   = true
    default     = null
}

variable "db_password" {
    type        = string
    description = "Master password for the PostgreSQL instance. If not set, Terraform will attempt to read from AWS Secrets Manager."
    sensitive   = true
    default     = null
}

variable "s3_deploy_bucket" {
    description = "Nome do bucket S3 para os artefatos de deploy"
    type        = string
    sensitive   = true
}

variable "db_name" {
    description = "The name of the database to create in the RDS instance."
    type        = string
    sensitive   = true
}