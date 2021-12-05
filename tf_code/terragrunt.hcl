remote_state {
  backend = "s3"
  config  = {
    bucket         = "lysakov-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "lysakov-tfstate-locks"
  }
}
