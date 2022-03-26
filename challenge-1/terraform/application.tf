resource "aws_autoscaling_group" "asg" {
  name                      = "kpmg-frontend"
  min_size = 1
  max_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = [aws_subnet.private.id]

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "kpmg-frontend-asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "frontend" {
  name          = "kpmg-frontend"
  image_id      = "ami-03e88be9ecff64781" # Linux AMI ID in eu-west-2
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.node.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.node.id
    ]
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "kpmg"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "kpmg"
    }
  }

  tags = {
    Name = "kpmg"
  }
}

resource "aws_iam_instance_profile" "node" {
  name = "kpmg_instance_profile"
  role = aws_iam_role.node.name

  tags = {
    Name = "kpmg"
  }
}

resource "aws_iam_role" "node" {
  name = "kpmg_node"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "node" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_security_group" "node" {
  vpc_id = aws_vpc.vpc.id
  name   = "kpmg-node"
}

resource "aws_security_group_rule" "node_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "HTTP"
  security_group_id = aws_security_group.node.id
  source_security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "node_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.node.id
}
