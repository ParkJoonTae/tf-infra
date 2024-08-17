terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

  # 테라폼 상태 S3 관리
  # backend "s3" {
  #   bucket         = "ksi05298-terraform-bucket"
  #   key            = "global/s3/terraform.tfstate"
  #   region         = "ap-northeast-2"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region  = "ap-northeast-2"
  version = ">= 4.0"
}

provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.cluster.token
}