resource "aws_ecs_service" "ecs_service" {
  name            = "${var.developer}-service"
  cluster         = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 3

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.http_target_group.arn
    container_name   = var.project_name
    container_port   = var.container_port
  }

  depends_on = [
    data.terraform_remote_state.ecs_cluster,
    aws_ecs_task_definition.task_definition,
    aws_lb_target_group.http_target_group,
  ]
}
