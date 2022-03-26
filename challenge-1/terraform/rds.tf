resource "aws_db_instance" "kpmg_postgres" {
  allocated_storage    = 10
  engine               = "postgresql"
  engine_version       = "9.6"
  instance_class       = "db.t3.micro"
  name                 = "kpmg-db"
  username             = "rds-user"
  password             = aws_ssm_parameter.rds_password.value
  skip_final_snapshot  = true
}

resource "aws_ssm_parameter" "rds_password" {
  name = "kpmg-rds-password"
  type = "String"
  value = "default" # Would be something we should set on the console and not in git
}

resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.vpc.id
  name   = "kpmg-node_backend"
}

resource "aws_security_group_rule" "rds" {
  type              = "ingress"
  from_port         = 5433
  to_port           = 5433
  protocol          = "HTTP"
  security_group_id = aws_security_group.rds.id
  source_security_group_id = aws_security_group.node_backend.id
}