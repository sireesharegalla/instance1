# scale up alarm

resource "aws_autoscaling_policy" "mypolicy_scaleup" {
  name                   = "mypolicy_scaleup"
  autoscaling_group_name = aws_autoscaling_group.autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "autoscale_alarm_scaleup" {
  alarm_name          = "autoscale_alarm_scaleup"
  alarm_description   = "mycpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.mypolicy_scaleup.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "mypolicy_scaledown" {
  name                   = "mypolicy_scaledown"
  autoscaling_group_name = aws_autoscaling_group.autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "autoscale_alarm_scaledown" {
  alarm_name          = "scaledown_alarm"
  alarm_description   = "scaledown_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.mypolicy_scaledown.arn]
}

