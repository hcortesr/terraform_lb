resource "aws_lb" "lb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups = aws_security_group.sg_lb.id
  subnets            = [
    "subnet-01efa1873f7ce2171"
  ]
  enable_deletion_protection = true

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