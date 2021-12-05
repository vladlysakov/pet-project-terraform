resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.developer}-users"

  username_attributes      = ["phone_number"]
  auto_verified_attributes = ["phone_number"]

  password_policy {
    minimum_length                   = 8
    require_symbols                  = true
    require_numbers                  = true
    require_uppercase                = true
    require_lowercase                = true
    temporary_password_validity_days = 1
  }

  username_configuration {
    case_sensitive = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  device_configuration {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = false
  }

  sms_configuration {
    external_id    = "diploma_external_id"
    sns_caller_arn = aws_iam_role.sns_caller.arn
  }

  verification_message_template {
    sms_message = "Hello, {username}! Your verification code is {####}."
  }

  user_pool_add_ons {
    advanced_security_mode = "AUDIT"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  generate_secret               = false
  name                          = "${var.developer}-user-pool-client"
  user_pool_id                  = aws_cognito_user_pool.user_pool.id
  access_token_validity         = var.tokens_validity
  refresh_token_validity        = 365
  id_token_validity             = var.tokens_validity
  prevent_user_existence_errors = "LEGACY"
  enable_token_revocation       = true
  callback_urls                 = [var.default_url]
  default_redirect_uri          = var.default_url
  explicit_auth_flows           = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "minutes"
  }
}
