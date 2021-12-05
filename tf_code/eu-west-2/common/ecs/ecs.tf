resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.developer}-cluster"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}


