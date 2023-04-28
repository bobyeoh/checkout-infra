resource "random_string" "username" {
  length  = 8
  special = false
}

resource "random_string" "password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "db" {
  identifier           = "${var.app_name}-${var.environment}"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  db_name              = var.db_name
  username             = random_string.username.result
  password             = random_string.password.result
  publicly_accessible  = false
  multi_az             = false
  skip_final_snapshot  = true
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.app_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids
}
