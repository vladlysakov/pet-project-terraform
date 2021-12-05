resource "aws_codedeploy_app" "deploy" {
  compute_platform = "ECS"
  name             = "${var.developer}-codedeploy-application"
}

resource "aws_codedeploy_deployment_config" "deployment_config" {
  deployment_config_name = "${var.developer}-deployment-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.deploy.name
  deployment_group_name  = "${var.developer}-deployment-group"
  service_role_arn       = aws_iam_role.codedeploy.arn
  deployment_config_name = aws_codedeploy_deployment_config.deployment_config.id

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 2
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_name
    service_name = aws_ecs_service.ecs_service.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.http_listener.arn]
      }

      target_group {
        name = aws_lb_target_group.http_target_group.name
      }

      target_group {
        name = aws_lb_target_group.instance_lb_tg.name
      }
    }
  }
}
