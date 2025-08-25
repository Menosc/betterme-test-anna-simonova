resource "random_password" "db_password" {
  length           = 16
  special          = false
  override_special = "_!%^"
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.project_name}-${var.environment}-${var.candidate_name}-rds"

  manage_master_user_password = false
  engine                      = "postgres"
  engine_version              = "17.4"
  instance_class              = "db.t3.micro"
  allocated_storage           = 20
  family                      = "postgres17"

  db_name  = "postgres"
  password = random_password.db_password.result
  username = "postgres"

  port = 5432

  vpc_security_group_ids = [module.vpc.default_security_group_id]
  create_db_subnet_group = true
  subnet_ids             = module.vpc.public_subnets

  deletion_protection = false
  publicly_accessible = true
}
