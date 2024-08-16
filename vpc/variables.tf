####### 1) VPC 생성 ##########
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  description = "Instance tenancy in VPC"
  type        = string
  default     = "default"
}

variable "region" {
  description = "region"
  type        = string
  default     = "ap-northeast-2"
}

####### 2) Subnet 생성 ##########
variable "private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs" {
  description = "VPC AZ"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}
