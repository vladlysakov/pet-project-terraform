resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.developer}-codepipeline-bucket"
  acl    = "private"
}
