resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  # name                 = var.name
  username             = var.username

  password             = var.password
  parameter_group_name = var.parameter_group_name
  final_snapshot_identifier= false
  skip_final_snapshot = false
  db_subnet_group_name = var.db-subnet-grp
  vpc_security_group_ids = [aws_security_group.SecurityGroup.id]
}

output "rds-endpoint" {
  value = aws_db_instance.default.endpoint
}
locals {
  rds-endpoint = aws_db_instance.default.endpoint
}
resource "local_file" "endpoint" {
  content = "${local.rds-endpoint}"
  filename = "endpoint.txt"
}