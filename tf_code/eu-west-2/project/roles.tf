resource "aws_iam_role" "sns_caller" {
  name = "${var.developer}-sns-caller-role"

  assume_role_policy = jsonencode(
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : ["cognito-idp.amazonaws.com", "ec2.amazonaws.com"]
        },
        "Action" : "sts:AssumeRole",
      }
    ]
  }
  )
}

resource "aws_iam_role_policy" "sns_caller" {
  name = "${var.project_name}-sns-caller-policy"
  role = aws_iam_role.sns_caller.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["sns:publish"],
            "Resource": ["*"]
        }
    ]
}
EOF
}

resource "aws_iam_role" "codepipeline_role" {
  name = "${var.developer}-codepipeline-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        },
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : aws_s3_bucket.codepipeline_bucket.arn
      },
      {
        "Effect" : "Allow",
        "Action" : "codebuild:*",
        "Resource" : aws_codebuild_project.codebuild.arn # ?
      },
      {
        "Effect" : "Allow",
        "Action" : "codedeploy:*",
        "Resource" : "*",
      },
      {
        "Action" : [
          "ecr:*",
          "ecs:*"
        ],
        "Resource" : [
          aws_ecr_repository.ecr_repository.arn,
          data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_arn
        ],
        "Effect" : "Allow"
      },
    ]
  })
}

resource "aws_iam_role" "codebuild" {
  name = "${var.developer}-codebuild"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "codedeploy" {
  name = "${var.developer}-codedeploy"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "codedeploy.amazonaws.com"
        },
        "Effect" : "Allow"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy.name
}


resource "aws_iam_role" "ecs_task" {
  name = "${var.developer}-ecs-task"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Effect" : "Allow"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:*",
          "logs:*"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : [
          data.aws_secretsmanager_secret.database_name.arn,
          data.aws_secretsmanager_secret.database_host.arn,
          data.aws_secretsmanager_secret.database_port.arn,
          data.aws_secretsmanager_secret.database_password.arn,
          data.aws_secretsmanager_secret.database_username.arn,

          data.aws_secretsmanager_secret.cognito_user_pool.arn,
          data.aws_secretsmanager_secret.cognito_client_ids.arn,

          data.aws_secretsmanager_secret.app_secret_key.arn

        ]
      }
    ]
  })
}

resource "aws_iam_role" "cloudwatch_event_pipeline_iam_role" {
  name = "${var.project_name}-cloudwatch-event-pipeline"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "cloudwatch_event_pipeline_iam_role_policy" {
  name = "${var.project_name}-cw-event-pipeline-policy"
  role = aws_iam_role.cloudwatch_event_pipeline_iam_role.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "codepipeline:StartPipelineExecution"
        ],
        "Resource" : [
          aws_codepipeline.deploy_codepipeline.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ecs_instance_role" {
  name               = "${var.developer}-ecs-instance"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_policy.json
}


data "aws_iam_policy_document" "ecs_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

  depends_on = [
    aws_iam_role.ecs_instance_role
  ]
}