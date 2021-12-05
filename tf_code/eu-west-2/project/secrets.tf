#resource "aws_secretsmanager_secret" "database_host" {
#  name                    = "${var.developer}-db-host"
#  description             = "Database host"
#  recovery_window_in_days = 0
#}
#
#resource "aws_secretsmanager_secret" "database_port" {
#  name                    = "${var.developer}-db-port"
#  description             = "Database port"
#  recovery_window_in_days = 0
#}
#
#resource "aws_secretsmanager_secret" "database_username" {
#  name                    = "${var.developer}-db-username"
#  description             = "Database username"
#  recovery_window_in_days = 0
#}
#
#resource "aws_secretsmanager_secret" "database_password" {
#  name                    = "${var.developer}-db-password"
#  description             = "Database password"
#  recovery_window_in_days = 0
#}
#
#resource "aws_secretsmanager_secret" "database_name" {
#  name                    = "${var.developer}-db-name"
#  description             = "Database name"
#  recovery_window_in_days = 0
#}
#
#resource "aws_secretsmanager_secret" "cognito_user_pool" {
#  name                    = "${var.developer}-cognito-user-pool"
#  description             = "Cognito user pool"
#  recovery_window_in_days = 0
#}
#
#resource "aws_secretsmanager_secret" "cognito_client_ids" {
#  name                    = "${var.developer}-cognito-client-ids"
#  description             = "Client IDS for available applications"
#  recovery_window_in_days = 0
#}
#
#resource "aws_secretsmanager_secret" "app_secret_key" {
#  name                    = "${var.developer}-application-secret-key"
#  description             = "Secret key for Django app"
#  recovery_window_in_days = 0
#}


data "aws_secretsmanager_secret" "database_host" {
  arn = "arn:aws:secretsmanager:eu-west-2:721033716810:secret:vlysakov-db-host-EuJIuF"
}

data "aws_secretsmanager_secret" "database_port" {
  arn = "arn:aws:secretsmanager:eu-west-2:721033716810:secret:vlysakov-db-port-67kTru"
}

data "aws_secretsmanager_secret" "database_username" {
  arn = "arn:aws:secretsmanager:eu-west-2:721033716810:secret:vlysakov-db-username-QuGW3H"
}

data "aws_secretsmanager_secret" "database_password" {
  arn = "arn:aws:secretsmanager:eu-west-2:721033716810:secret:vlysakov-db-password-EuJIuF"
}

data "aws_secretsmanager_secret" "database_name" {
  arn = "arn:aws:secretsmanager:eu-west-2:721033716810:secret:vlysakov-db-name-9UvPlQ"
}

data "aws_secretsmanager_secret" "cognito_user_pool" {
  arn = "arn:aws:secretsmanager:eu-west-2:721033716810:secret:vlysakov-cognito-user-pool-CYXEqo"
}

data "aws_secretsmanager_secret" "cognito_client_ids" {
  arn = "arn:aws:secretsmanager:eu-west-2:721033716810:secret:vlysakov-cognito-client-ids-RaaKX1"
}

data "aws_secretsmanager_secret" "app_secret_key" {
  arn = "arn:aws:secretsmanager:eu-west-2:721033716810:secret:vlysakov-application-secret-key-ly95EH"
}
