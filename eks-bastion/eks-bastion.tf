# Bastion 호스트 보안 그룹
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "eks-bastion-sg"
  description = "Security group for EKS bastion host"
  vpc_id      = data.aws_vpc.selected.id

  ingress_with_cidr_blocks = [
    for port in [22, 80, 443] : {
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# EKS Bastion 호스트
module "eks_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.0.0"

  name                        = "eks-bastion"
  ami                         = "ami-0edc5427d49d09d2a"
  instance_type               = "t2.micro"
  key_name                    = "mykeypair"
  subnet_id                   = data.aws_subnets.public.ids[0]
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = "true"

  user_data = file("${path.module}/bastion-userdata.sh")
}