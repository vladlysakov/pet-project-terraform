resource "aws_codebuild_source_credential" "github_access" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.ci_cd_github_token
}

resource "aws_codepipeline" "build_codepipeline" {
  name     = "${var.developer}-build-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = [
        "source_output"
      ]

      configuration = {
        Owner      = var.ci_cd_github_owner
        Repo       = var.ci_cd_github_repo
        Branch     = var.ci_cd_github_branch
        OAuthToken = var.ci_cd_github_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"

      input_artifacts  = [
        "source_output"
      ]
      output_artifacts = [
        "build_output"
      ]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild.id
      }
    }
  }

  depends_on = [
    aws_iam_role.codepipeline_role,
    aws_s3_bucket.codepipeline_bucket,
    aws_codebuild_project.codebuild,
  ]

}


resource "aws_codepipeline" "deploy_codepipeline" {
  name     = "${var.developer}-deploy-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      run_order        = 1
      name             = "Image"
      category         = "Source"
      owner            = "AWS"
      provider         = "ECR"
      version          = "1"

      output_artifacts = ["image_output"]

      configuration = {
        ImageTag       = "latest"
        RepositoryName = aws_ecr_repository.ecr_repository.name
      }
    }

    action {
      run_order        = 2
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = [
        "source_output"
      ]

      configuration = {
        Owner                = var.ci_cd_github_owner
        Repo                 = var.ci_cd_github_repo
        Branch               = var.ci_cd_github_branch
        OAuthToken           = var.ci_cd_github_token
        PollForSourceChanges = false
      }
    }
  }


  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"

      input_artifacts = [
        "image_output",
        "source_output",
      ]

      configuration   = {
        AppSpecTemplateArtifact : "source_output",
        AppSpecTemplatePath : "appspec-dev.yaml",
        TaskDefinitionTemplateArtifact : "source_output",
        TaskDefinitionTemplatePath : "taskdef-dev.json",
        ApplicationName : aws_codedeploy_app.deploy.name,
        DeploymentGroupName : aws_codedeploy_deployment_group.deployment_group.deployment_group_name
        Image1ArtifactName : "image_output",
        Image1ContainerName : "IMAGE"
      }
    }
  }

  depends_on = [
    aws_iam_role.codepipeline_role,
    aws_s3_bucket.codepipeline_bucket,
    aws_ecr_repository.ecr_repository,
    aws_codedeploy_app.deploy,
    aws_codedeploy_deployment_group.deployment_group,
  ]
}
