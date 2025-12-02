#Alarma: CPU alta en instancia web1
resource "aws_cloudwatch_metric_alarm" "web1_high_cpu" {
  alarm_name          = "isc-web1-high-cpu"
  alarm_description   = "ACPU web1 supera 70% durante 2 minutos"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    InstanceId = aws_instance.web1.id
  }

  treat_missing_data        = "notBreaching"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}

#Alarma: CPU alta en instancia web2
resource "aws_cloudwatch_metric_alarm" "web2_high_cpu" {
  alarm_name          = "isc-web2-high-cpu"
  alarm_description   = "CPU web2 supera 70% durante 2 minutos"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    InstanceId = aws_instance.web2.id
  }

  treat_missing_data        = "notBreaching"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}

#Alarma: CPU alta en la base de datos RDS
resource "aws_cloudwatch_metric_alarm" "db_high_cpu" {
  alarm_name          = "isc-db-high-cpu"
  alarm_description   = "CPU RDS supera 70% durante 2 minutos"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.app_db.id
  }

  treat_missing_data        = "notBreaching"
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}
