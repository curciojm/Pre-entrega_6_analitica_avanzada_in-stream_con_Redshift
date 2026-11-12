resource "aws_glue_catalog_database" "lakehouse" {
  name         = "stock_lakehouse_${var.environment}"
  description  = "Glue database for the Stock Lakehouse project"
  location_uri = "s3://${aws_s3_bucket.lakehouse.bucket}/warehouse/"

  tags = {
    Project = "Pre-entrega-6-Lakehouse"
  }
}