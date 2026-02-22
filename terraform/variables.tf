variable "amis" {
    type = map
    default = {
        "us-east-1" = "ami-0c1fe732b5494dc14"
    }     
}

variable "cdirs_acesso_remoto" {
    type = list(string)
    default = ["45.239.103.136/32"]
  
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