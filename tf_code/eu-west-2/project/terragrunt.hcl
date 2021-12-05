include {
  path = find_in_parent_folders()
}

locals {
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  #  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  vpc_cidr    = "10.20.0.0/24"
}

inputs = merge(
local.region_vars.locals,
#local.environment_vars.locals,
{
  environment  = "development"
  project_name = "diploma"

  tokens_validity = 30
  default_url     = "https://google.com"
  external_id     = "diploma_external_id"

  # database variables
  max_allocated_storage   = 6
  allocated_storage       = 5
  database_name           = "diploma"
  storage_type            = "gp2"
  database_user           = "postgres"
  database_password       = "tzpg3JdyyzkezK6"
  database_engine         = "aurora-postgresql"
  database_engine         = "postgres"
  database_engine_version = "10.17"
  database_type           = "db.t2.micro"
  database_port           = 5432

  # vpc
  availability_zones = ["a", "b", "c"]
  vpc_cidr    = "172.16.0.0/16"
  public_cidr_block  = "172.16.2.0/24"
  private_cidr_block = "172.16.3.0/24"

  # ec2
  cpu                                = 10
  memory                             = 512
  container_port                     = 5000
  desired_count                      = 3
  alb_health_check_url               = "/api/v1/connections/check"
  spot_price                         = "0.05"
  instance_type                      = "t2.micro"
  image_id                           = "ami-063116f031e1a9e3b"
  autoscaling_group_max_size         = 3
  autoscaling_group_min_size         = 1
  autoscaling_group_desired_capacity = 2
  health_check_grace_period          = 300
  health_check_type                  = "ELB"

  # ci/cd
  ci_cd_github_owner       = "vladlysakov"
  ci_cd_github_token       = "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"
  ci_cd_github_repo        = "pet-project"
  ci_cd_github_project_url = "https://github.com/vladlysakov/pet-project"
  ci_cd_github_branch      = "development"

  ecr_build_number = "latest"
}
)
