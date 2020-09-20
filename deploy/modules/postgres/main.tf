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
}

