# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 21.0"

#   name               = "${var.project_name}-${var.environment}-${var.candidate_name}-eks"
#   kubernetes_version = "1.32"

#   endpoint_public_access = true

#   enable_cluster_creator_admin_permissions = true

#   compute_config = {
#     enabled    = true
#     node_pools = ["general-purpose"]
#   }

#   eks_managed_node_groups = {
#     example = {
#       ami_type       = "AL2023_x86_64_STANDARD"
#       instance_types = ["t3.medium"]

#       min_size     = 2
#       max_size     = 5
#       desired_size = 2
#     }
#   }

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnets
# }
