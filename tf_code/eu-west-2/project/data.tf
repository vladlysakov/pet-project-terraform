data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"

  config = {
    bucket = var.remote_main_state_bucket
    region = var.aws_region
    key    = var.remote_state_key_ecs
  }
}
