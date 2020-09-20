resource "aws_iam_role" "ssm_instance_role" {
  name = "ssm_instance_role"
  assume_role_policy = <<TRUSTPOLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
TRUSTPOLICY
}

resource "aws_iam_role_policy_attachment" "ssm_attachment" {
  role = aws_iam_role.ssm_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_instance_role.name
}

resource "aws_autoscaling_group" "techchallenge" {
  name                      = var.name
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  load_balancers            = [aws_elb.techchallenge.name]
  launch_template      {
    id = aws_launch_template.techchallenge.id
    version = "$Latest"
  }
  vpc_zone_identifier       = module.network.private_subnets.*.id
}

data "aws_ami" "latest_amazonlinux2" {
  most_recent = true
  owners = ["137112412989"] # Amazon

  filter {
      name   = "name"
      values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

resource "aws_launch_template" "techchallenge" {
  name = var.name
  image_id = data.aws_ami.latest_amazonlinux2.id
  instance_type = "t2.micro"
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }
  user_data = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [aws_security_group.techchallenge_node_access.id]
}

resource "aws_security_group" "techchallenge_node_access" {
  name        = "${var.name}-node-access"
  description = "Node access for ${var.name}"
  vpc_id      = module.network.vpc.id

  ingress {
    description = "ELB traffic access"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.elb_access.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    app_version = var.app_version
    db_username = var.db_username
    db_password = var.db_password
    db_name     = "app"
    db_host     = module.database.address
    db_port     = module.database.port
    listen_host = "0.0.0.0"
    listen_port = "3000"
  }
}

resource "aws_elb" "techchallenge" {
  name            = var.name
  subnets         = module.network.public_subnets.*.id
  security_groups = [aws_security_group.elb_access.id]

  connection_draining         = true
  connection_draining_timeout = 30

  listener {
    instance_port     = 3000
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:3000/"
    interval            = 30
  }
}

resource "aws_security_group" "elb_access" {
  name        = "${var.name}-elb"
  description = "ELB access for ${var.name}"
  vpc_id      = module.network.vpc.id

  ingress {
    description = "Public HTTP traffic access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

