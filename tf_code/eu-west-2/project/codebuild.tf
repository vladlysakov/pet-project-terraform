resource "aws_codebuild_project" "codebuild" {
  name         = "${var.developer}-codebuild"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type            = "GITHUB"
    location        = var.ci_cd_github_project_url
    git_clone_depth = 2

    git_submodules_config {
      fetch_submodules = true
    }
  }
}
