resource "aws_db_subnet_group" "private" {
  name       = "main"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.7"
  instance_class       = "db.t2.micro"
  name                 = var.name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.private.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.allow_rds_access.id]
}

resource "aws_security_group" "allow_rds_access" {
  name        = "rds-access"
  description = "Allow private access to postgres"
  vpc_id      = var.vpc_id

  ingress {
    description = "Postgres DB access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.trusted_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.trusted_cidrs
  }
}
