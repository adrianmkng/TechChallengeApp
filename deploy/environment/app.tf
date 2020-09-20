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
  launch_template      {
    id = aws_launch_template.techchallenge.id
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
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    app_version = var.app_version
  }
}

