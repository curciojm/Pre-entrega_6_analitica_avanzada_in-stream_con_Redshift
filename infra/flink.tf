resource "aws_s3_object" "flink_jar" {
  bucket = aws_s3_bucket.flink_artifacts.id

  key    = "application/stock-lakehouse.jar"
  source = var.flink_jar_path
  # etag: utiliza el MD5 del archivo para detectar cambios y actualizar el objeto cuando corresponda
  etag = filemd5(var.flink_jar_path)
}

# Este recurso crea la aplicación de AWS Managed Service for Apache Flink
resource "aws_kinesisanalyticsv2_application" "stock_lakehouse" {
  provider = aws.untagged

  name                   = "stock-lakehouse-${var.environment}"
  runtime_environment    = "FLINK-1_20"
  service_execution_role = aws_iam_role.flink_execution.arn

  description = "Stock market streaming Lakehouse application"

  cloudwatch_logging_options {
    log_stream_arn = aws_cloudwatch_log_stream.flink.arn
  }

  application_configuration {


    application_code_configuration {
      code_content {
        s3_content_location {
          bucket_arn = aws_s3_bucket.flink_artifacts.arn
          file_key   = aws_s3_object.flink_jar.key
        }
      }
      # REVISAR ZIPFILE
      code_content_type = "ZIPFILE"
    }

    environment_properties {
      property_group {
        property_group_id = "ApplicationProperties"

        property_map = {
          KINESIS_STREAM_ARN = aws_kinesis_stream.stock_quotes.arn
          AWS_REGION         = var.aws_region
          LAKEHOUSE_BUCKET   = aws_s3_bucket.lakehouse.id
          GLUE_DATABASE      = "stock_lakehouse_${var.environment}"
        }
      }
    }

    flink_application_configuration {

      checkpoint_configuration {
        configuration_type            = "CUSTOM"
        checkpointing_enabled         = true
        checkpoint_interval           = 60000
        min_pause_between_checkpoints = 5000
      }

      parallelism_configuration {
        configuration_type   = "CUSTOM"
        parallelism          = 2
        parallelism_per_kpu  = 1
        auto_scaling_enabled = false
      }

      monitoring_configuration {
        configuration_type = "CUSTOM"
        log_level          = "INFO"
        metrics_level      = "APPLICATION"
      }
    }

    application_snapshot_configuration {
      snapshots_enabled = false
    }
  }

  start_application = false
}