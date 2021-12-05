resource "aws_launch_configuration" "launch_configuration" {
  name            = "${var.developer}-launch_configuration"
  image_id        = var.image_id
  instance_type   = var.instance_type
  spot_price      = var.spot_price
  security_groups = [aws_security_group.ec2_sg.id]
  user_data       = <<EOF
                      #!/bin/bash
                      echo ECS_CLUSTER=${data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_name} >> /etc/ecs/ecs.config
                      EOF
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_security_group.ec2_sg,
    data.terraform_remote_state.ecs_cluster,
  ]
}


resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "${var.developer}-asg"
  max_size                  = var.autoscaling_group_max_size
  min_size                  = var.autoscaling_group_min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.autoscaling_group_desired_capacity
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  vpc_zone_identifier       = aws_subnet.private_subnet.*.id

  depends_on = [
    aws_launch_configuration.launch_configuration
  ]
}


resource "aws_instance" "simple_server" {
  name          = "${var.developer}-simple-server"
  ami           = var.image_id
  instance_type = var.instance_type
}




