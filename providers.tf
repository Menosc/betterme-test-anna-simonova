terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5"

    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner       = var.candidate_name
      Terraform   = "true"
      Environment = var.environment
      Project     = var.project_name
    }
  }
}
