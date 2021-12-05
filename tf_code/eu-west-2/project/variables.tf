variable "developer" {
  default     = "vlysakov"
  description = "The name of the developer to identify resources"
  type        = string
}

# remote state
variable "remote_main_state_bucket" {}
variable "remote_state_key_ecs" {}

variable "aws_region" {}
variable "project_name" {}
variable "environment" {}

# database variables
variable "allocated_storage" {}
variable "max_allocated_storage" {}
variable "database_engine" {}
variable "database_name" {}
variable "storage_type" {}
variable "database_engine_version" {}
variable "database_type" {}
variable "database_user" {}
variable "database_password" {}
variable "database_port" {}

# vpc
variable "vpc_cidr" {}
variable "public_cidr_block" {}
variable "private_cidr_block" {}
variable "availability_zones" { type = list(string) }

# cognito
variable "tokens_validity" {}
variable "default_url" {}

# ec2
variable "cpu" {}
variable "memory" {}
variable "container_port" {}
variable "alb_health_check_url" {}
variable "desired_count" {}
variable "spot_price" {}
variable "instance_type" {}
variable "image_id" {}
variable "autoscaling_group_max_size" {}
variable "autoscaling_group_min_size" {}
variable "autoscaling_group_desired_capacity" {}
variable "health_check_grace_period" {}
variable "health_check_type" {}

# ci/cd
variable "ci_cd_github_owner" {}
variable "ci_cd_github_token" {}
variable "ci_cd_github_repo" {}
variable "ci_cd_github_project_url" {}
variable "ci_cd_github_branch" {}


variable "ecr_build_number" {}
