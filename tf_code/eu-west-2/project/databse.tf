resource "aws_db_instance" "postgresql_db_instance" {
  identifier                = "${var.developer}-db-instance"
  final_snapshot_identifier = "${var.developer}-db-instance-snapshot"
  name                      = var.database_name
  allocated_storage         = var.allocated_storage
  max_allocated_storage     = var.max_allocated_storage
  storage_type              = var.storage_type
  engine                    = var.database_engine
  engine_version            = var.database_engine_version
  instance_class            = var.database_type
  username                  = var.database_user
  password                  = var.database_password
  port                      = var.database_port

  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.database_sg.id
  ]

  depends_on = [
    aws_security_group.database_sg,
    aws_db_subnet_group.database_subnet_group,
  ]
}
