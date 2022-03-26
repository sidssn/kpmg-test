resource "aws_lb" "alb" {
  name               = "kpmg-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public.id]

  enable_deletion_protection = false
}

resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.vpc.id
  name   = "kpmg-lb-sg"
}

resource "aws_security_group_rule" "lb_sg_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "lb_sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_alb_target_group" "lb_tg" {
  name        = "kpmg-lb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.lb_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  alb_target_group_arn   = aws_alb_target_group.lb_tg.arn
}