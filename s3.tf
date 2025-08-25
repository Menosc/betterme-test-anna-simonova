module "private_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.5.0"

  bucket = "private-${var.project_name}-${var.environment}-${var.candidate_name}"

  object_ownership = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }
}




module "public_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.5.0"

  bucket                  = "public-${var.project_name}-${var.environment}-${var.candidate_name}"
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  object_ownership = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }
}
