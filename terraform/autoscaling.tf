resource "aws_launch_configuration" "autoscaleconfig" {
  name_prefix     = "autoscaleconfig"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.mykey.key_name
  security_groups = [aws_security_group.allow-ssh.id]
}

resource "aws_autoscaling_group" "autoscaling" {
  name                      = "autoscaling"
  vpc_zone_identifier       = [aws_subnet.public-subnet-1.id]
  launch_configuration      = aws_launch_configuration.autoscaleconfig.name
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    Name                 = "myfirstkey"
    propagate_at_launch = true
  }
}

