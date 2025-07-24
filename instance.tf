resource "aws_instance" "lb_instances" {
    ami = "ami-0cbbe2c6a1bb2ad63"
    instance_type = "t2.micro"
    count = 2

    user_data = file("userdata.sh")
}


# Security group
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "The sg for my ec2"
  tags = {
    Name = "ecs_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_sg" {
  security_group_id = aws_security_group.ec2_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

# Target group
resource "aws_lb_target_group" "lb_target_group" {
    name = "lb-target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "attachment_1" {

    count = length(aws_instance.lb_instances)

    target_group_arn = aws_lb_target_group.lb_target_group.arn
    target_id = aws_instance.lb_instances[count.index].id
    port = 80

    
}