# 워커노드 launch template
resource "aws_launch_template" "workernode" {
  name_prefix   = "workernode"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.medium"
  key_name      = "mykeypair"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 60
      volume_type = "gp2"
    }
  }
}

# eks 생성 모듈
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 19.0"

  cluster_name    = "pjt-eks-cluster"
  cluster_version = 1.29

  vpc_id                   = data.aws_vpc.selected.id
  subnet_ids               = data.aws_subnets.private.ids
  control_plane_subnet_ids = data.aws_subnets.private.ids

  # eks 생성 유저에 eks admin 액세스 권한 부여 
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default_node_group = {
      desired_size   = 2
      min_size       = 2
      max_size       = 4
      launch_template = {
        id = aws_launch_template.workernode.id
        version = "$Latest"
      }
    }
  }
  
  # vpc내부 aws리소스가 eks에 접근할 수 있도록 허용
  node_security_group_additional_rules = {
    allow_local_ingress_rule = {
      description = "Allow all of local ingress rules to node"
      protocol    = "TCP"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      cidr_blocks = [data.aws_vpc.selected.cidr_block]
    }
  }

  # bastion host eks 접근 허용
  cluster_security_group_additional_rules = {
    allow_bastion_https_ingress = {
      description = "Allow HTTPS(Bastion kubectl) input to cluster from local"
      protocol    = "TCP"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [data.aws_vpc.selected.cidr_block]
    }
  }
}