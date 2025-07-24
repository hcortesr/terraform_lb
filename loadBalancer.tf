resource "aws_lb" "lb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.sg_lb.id]
  subnets = data.aws_subnets.default_vpc_subnets.ids
  
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

# Load balancer security groups
resource "aws_security_group" "sg_lb" {
  name        = "alb_sg"
  description = "The sg for my loadbalancer"
  tags = {
    Name = "Alb_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "example" {
  security_group_id = aws_security_group.sg_lb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
resource "aws_vpc_security_group_egress_rule" "example" {
  security_group_id = aws_security_group.sg_lb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# Listener
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}