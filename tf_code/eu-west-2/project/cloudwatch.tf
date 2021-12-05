resource "aws_cloudwatch_log_group" "cloudwatch_group" {
  name              = "${var.developer}-cloudwatch_group"
  retention_in_days = 3
}

resource "aws_cloudwatch_event_rule" "codepipeline_build_success" {
  name        = "${var.developer}-build-seccess-rule"
  description = "Event to trigger deploy pipeline"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codepipeline"
  ],
  "detail-type": [
    "CodePipeline Pipeline Execution State Change"
  ],
  "detail": {
    "state": [
      "SUCCEEDED"
    ],
    "pipeline": [
      "${aws_codepipeline.build_codepipeline.name}"
    ]
  }
}
PATTERN

  depends_on = [
    aws_codepipeline.build_codepipeline
  ]
}


resource "aws_cloudwatch_event_target" "codepipeline_event_target" {
  rule      = aws_cloudwatch_event_rule.codepipeline_build_success.name
  target_id = "CodePipeline"
  arn       = aws_codepipeline.deploy_codepipeline.arn
  role_arn  = aws_iam_role.cloudwatch_event_pipeline_iam_role.arn

  depends_on = [
    aws_codepipeline.deploy_codepipeline,
    aws_iam_role.cloudwatch_event_pipeline_iam_role,
    aws_cloudwatch_event_rule.codepipeline_build_success,
  ]
}