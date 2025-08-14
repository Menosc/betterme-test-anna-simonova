# Generate a random DB password
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Store credentials in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "betterme-db-credentials"
  description = "Postgres credentials for BetterMe test task"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "betterme_user"
    password = random_password.db_password.result
  })
}

# Create the DB subnet group (use only private subnets)
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "betterme-postgres-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "betterme-postgres-subnet-group"
  }
}

# Create RDS Postgres instance
resource "aws_db_instance" "postgres" {
  identifier             = "betterme-postgres"
  engine                 = "postgres"
  engine_version         = "15.3"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  username = "betterme_user"
  password = random_password.db_password.result

  skip_final_snapshot = true
  publicly_accessible = false
  storage_encrypted   = true

  tags = {
    Name = "betterme-postgres"
  }
}

# Security group for Postgres (allow only from VPC)
resource "aws_security_group" "postgres_sg" {
  name        = "betterme-postgres-sg"
  description = "Allow Postgres access from VPC private subnets"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Postgres from private subnets"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "betterme-postgres-sg"
  }
}
