# VPC 데이터
data "aws_vpc" "selected" {
  filter {
    name   = "tag:ManagedBy"
    values = ["api"]
  }
}

# public 서브넷 데이터
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}
data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

# private 서브넷 데이터
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}
data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
  depends_on = [
    module.eks.eks_managed_node_groups,
  ]
}