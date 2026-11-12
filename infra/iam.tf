data "aws_caller_identity" "current" {}

resource "aws_iam_role" "flink_execution" {
  name = "stock-lakehouse-flink-execution-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "kinesisanalytics.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "flink_permissions" {
  name = "stock-lakehouse-flink-permissions"
  role = aws_iam_role.flink_execution.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "KinesisReadPermissions"
        Effect = "Allow"

        Action = [
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListShards",
          "kinesis:SubscribeToShard"
        ]

        Resource = aws_kinesis_stream.stock_quotes.arn
      },

      {
        Sid    = "LakehouseBucketPermissions"
        Effect = "Allow"

        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ]

        Resource = aws_s3_bucket.lakehouse.arn
      },

      {
        Sid    = "LakehouseObjectPermissions"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]

        Resource = "${aws_s3_bucket.lakehouse.arn}/*"
      },

      {
        Sid    = "FlinkArtifactReadPermissions"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]

        Resource = "${aws_s3_bucket.flink_artifacts.arn}/*"
      },


      {
        Sid    = "GlueCatalogPermissions"
        Effect = "Allow"

        Action = [
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetTable",
          "glue:GetTables",
          "glue:CreateTable",
          "glue:UpdateTable"
        ]

        Resource = [
          "arn:aws:glue:${var.aws_region}:${data.aws_caller_identity.current.account_id}:catalog",
          "arn:aws:glue:${var.aws_region}:${data.aws_caller_identity.current.account_id}:database/${aws_glue_catalog_database.lakehouse.name}",
          "arn:aws:glue:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${aws_glue_catalog_database.lakehouse.name}/*"
        ]
      },

      {
        Sid    = "CloudWatchDescribeLogGroups"
        Effect = "Allow"

        Action = [
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      },

      {
        Sid    = "CloudWatchDescribeLogStreams"
        Effect = "Allow"

        Action = [
          "logs:DescribeLogStreams"
        ]

        Resource = "${aws_cloudwatch_log_group.flink.arn}:log-stream:*"
      },

      {
        Sid    = "CloudWatchPutLogEvents"
        Effect = "Allow"

        Action = [
          "logs:PutLogEvents"
        ]

        Resource = aws_cloudwatch_log_stream.flink.arn
      }
    ]
  })
}

resource "aws_iam_role" "redshift" {
  name = "stock-lakehouse-redshift-${var.environment}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "redshift.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "redshift_permissions" {
  name = "stock-lakehouse-redshift-permissions-${var.environment}"
  role = aws_iam_role.redshift.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "KinesisReadPermissions"
        Effect = "Allow"

        Action = [
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListShards"
        ]

        Resource = aws_kinesis_stream.stock_quotes.arn
      },

      {
        Sid      = "KinesisListPermissions"
        Effect   = "Allow"
        Action   = ["kinesis:ListStreams"]
        Resource = "*"
      },

      {
        Sid    = "GlueCatalogReadPermissions"
        Effect = "Allow"

        Action = [
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetPartition",
          "glue:GetPartitions"
        ]

        Resource = [
          "arn:aws:glue:${var.aws_region}:${data.aws_caller_identity.current.account_id}:catalog",
          "arn:aws:glue:${var.aws_region}:${data.aws_caller_identity.current.account_id}:database/${aws_glue_catalog_database.lakehouse.name}",
          "arn:aws:glue:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${aws_glue_catalog_database.lakehouse.name}/*"
        ]
      },

      {
        Sid    = "LakehouseBucketReadPermissions"
        Effect = "Allow"

        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.lakehouse.arn
      },

      {
        Sid      = "LakehouseObjectReadPermissions"
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.lakehouse.arn}/*"
      }
    ]
  })
}
