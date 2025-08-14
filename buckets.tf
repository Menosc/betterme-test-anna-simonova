### Public S3 ###

module "public_s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.4.0"

  bucket = "betterme-public-${var.candidate_name}"
  acl    = "public-read"

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = "arn:aws:s3:::betterme-public-${var.candidate_name}/*"
      }
    ]
  })

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  tags = {
    Owner     = var.candidate_name
    Terraform = "true"
  }
}

### Private S3 ###

# VPC Endpoint for S3 (Gateway type)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = module.vpc.private_route_table_ids

  tags = {
    Name = "betterme-private-s3-endpoint"
  }
}

module "private_s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.4.0"

  bucket = "betterme-private-${var.candidate_name}"
  acl    = "private"


  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowAccessFromSpecificVPCE",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          "arn:aws:s3:::betterme-private-${var.candidate_name}",
          "arn:aws:s3:::betterme-private-${var.candidate_name}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:sourceVpce" = aws_vpc_endpoint.s3.id
          }
        }
      }
    ]
  })

  tags = {
    Owner     = var.candidate_name
    Terraform = "true"
  }
}
