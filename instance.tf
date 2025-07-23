resource "aws_instance" "lb-instances" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    count = 2
}

resource "aws_lb_target_group" "lb-target-group" {
    name = "lb-target-group"
    port = 80
    protocol = "HTTP"

}

resource "aws_lb_target_group_attachment" "attachment-1" {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    target_id = aws_instance.lb_instances[*].id
    port = 80
}

