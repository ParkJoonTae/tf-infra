# alb 컨트롤러 iamserviceaccount
module "alb_iam_service_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = ">= 5.0"

  role_name = "alb-iamserviceaccount"

  role_policy_arns = {
    alb_policy = aws_iam_policy.alb_controller.arn
  }

  oidc_providers = {
    eks_oidc = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:alb-iamserviceaccount"]
    }
  }
}

# ca iamserviceaccount
module "ca_iam_service_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = ">= 5.0"

  role_name = "cluster-autoscaler-role"

  role_policy_arns = {
    ca_policy = aws_iam_policy.eks_cluster_autoscaler.arn
  }

  oidc_providers = {
    eks_oidc = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}
