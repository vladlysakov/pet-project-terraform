locals {
  aws_region = "eu-west-2"

  remote_main_state_bucket = "lysakov-tfstate"
  remote_state_key_ecs = "${local.aws_region}/common/ecs/terraform.tfstate"
}
