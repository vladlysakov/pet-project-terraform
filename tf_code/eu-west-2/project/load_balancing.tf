resource "aws_lb" "load_balancer" {
  name            = "${var.developer}-lb"
  security_groups = [aws_security_group.load_balancer_sg.id]
  subnets         = aws_subnet.public_subnet.*.id
  depends_on      = [aws_security_group.load_balancer_sg]

  tags = {
    Environment = "${var.developer}-development"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance_lb_tg.arn
  }
}

#resource "aws_lb_listener" "https_listener" {
#  load_balancer_arn = aws_lb.load_balancer.arn
#  port              = "443"
#  protocol          = "HTTPS"
#  #  certificate_arn   = ""
#data.aws_subnet.private_subnet.id
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.instance_lb_tg.arn
#  }
#}

resource "aws_lb_target_group" "instance_lb_tg" {
  name     = "${var.developer}-lb-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = var.alb_health_check_url
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb_target_group" "http_target_group" {
  name     = "${var.developer}-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    matcher             = 200
    path                = var.alb_health_check_url
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
  }
}
