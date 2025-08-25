

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name                       = "${var.project_name}-${var.environment}-${var.candidate_name}-ec2"
  instance_type              = "t4g.small"
  ami                        = "ami-03d9fcc39480315d4" # ubuntu 24.04 (64-bit (Arm))
  subnet_id                  = module.vpc.public_subnets[0]
  associate_public_ip_address = true


  vpc_security_group_ids     = [module.vpc.default_security_group_id]

  user_data = <<-EOF
    #!/bin/bash

    # Оновлюємо пакети
    apt-get update -y
    apt-get upgrade -y

    # Встановлюємо Docker
    apt-get install -y docker.io

    # Стартуємо Docker
    systemctl start docker
    systemctl enable docker

    # Додаємо юзера ubuntu у групу docker
    usermod -aG docker ubuntu

    docker pull public.ecr.aws/h5v6m5z0/betterme-test/devops-test-app:latest

    docker run -d \
        --name devops-test-app \
        -e PUBLIC_BUCKET_URL=${module.public_s3_bucket.s3_bucket_id} \
        -e PRIVATE_BUCKET_URL=${module.private_s3_bucket.s3_bucket_id} \
        -e DATABASE_URL=postgres://${module.db.db_instance_username}:${random_password.db_password.result}@${module.db.db_instance_endpoint}/postgres?sslmode=require \
        -e AWS_ACCESS_KEY_ID=${var.aws_access_key} \
        -e AWS_SECRET_ACCESS_KEY=${var.aws_secret_key} \
        -e AWS_REGION=${var.region} \
        -p 3000:3000 \
        public.ecr.aws/h5v6m5z0/betterme-test/devops-test-app:latest

   EOF
   user_data_replace_on_change = true
}