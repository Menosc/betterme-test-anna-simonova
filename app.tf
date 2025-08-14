module "app_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role = true
  role_name   = "betterme-app-role"

  provider_url = module.eks.oidc_provider

  oidc_fully_qualified_subjects = [
    "system:serviceaccount:default:betterme-app"
  ]

  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

resource "helm_release" "betterme_app" {
  name      = "betterme"
  namespace = "betterme"
  chart     = "./chart"
  version   = "0.1.0"

  set {
    name  = "image.repository"
    value = "public.ecr.aws/h5v6m5z0/betterme-test/devops-test-app"
  }

  set {
    name  = "image.tag"
    value = "latest"
  }
}
