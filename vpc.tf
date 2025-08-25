module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-${var.environment}-${var.candidate_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  default_security_group_name = "${var.project_name}-default-sg"

  default_security_group_ingress = [
    {
      from_port   = 5432 #POSTGRES
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = var.ip_cidr
    },
    {
      from_port   = 3000 #APP
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = var.ip_cidr
    },
    {
      from_port   = 22 #SSH
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ip_cidr
    }
  ]
  default_security_group_egress = [
    {
      from_port   = 0 #ALL
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.ip_cidr
    },
  ]
  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

}
