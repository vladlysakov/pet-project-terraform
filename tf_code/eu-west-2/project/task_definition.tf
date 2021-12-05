resource "aws_ecs_task_definition" "task_definition" {
  family                = var.project_name
  execution_role_arn    = aws_iam_role.ecs_task.arn
  container_definitions = <<EOF
[
  {
    "name": "${var.project_name}",
    "image": "${aws_ecr_repository.ecr_repository.repository_url}:${var.ecr_build_number}",
    "cpu": 0,
    "memory": 300,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5000,
        "hostPort": 0,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.cloudwatch_group.name}",
        "awslogs-region": "${var.aws_region}",
        "awslogs-stream-prefix": "${var.developer}"
      }
    }
  }
]
EOF

  depends_on = [
    aws_ecr_repository.ecr_repository,
    aws_iam_role.ecs_task,
    aws_cloudwatch_log_group.cloudwatch_group
  ]
}