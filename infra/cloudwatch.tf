resource "aws_cloudwatch_log_group" "flink" {
  name              = "/aws/kinesis-analytics/stock-lakehouse-${var.environment}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "flink" {
  name           = "kinesis-analytics-log-stream"
  log_group_name = aws_cloudwatch_log_group.flink.name
}