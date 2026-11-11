resource "aws_s3_bucket" "flink_artifacts" {
  bucket        = var.flink_artifact_bucket_name
  force_destroy = true # cambiar a false al final
}

resource "aws_s3_bucket" "lakehouse" {
  bucket        = var.lakehouse_bucket_name
  force_destroy = true
}

# Bloqueo de acceso público del bucket de artefactos
resource "aws_s3_bucket_public_access_block" "flink_artifacts" {
  bucket = aws_s3_bucket.flink_artifacts.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Bloqueo de acceso público del bucket Lakehouse
resource "aws_s3_bucket_public_access_block" "lakehouse" {
  bucket = aws_s3_bucket.lakehouse.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Cifrado del bucket de artefactos
resource "aws_s3_bucket_server_side_encryption_configuration" "flink_artifacts" {
  bucket = aws_s3_bucket.flink_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lakehouse" {
  bucket = aws_s3_bucket.lakehouse.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Cada vez que sobrescribimos el objeto mediante una operación de escritura que crea una nueva versión, S3 conserva la anterior

# Versionado del bucket de artefactos
resource "aws_s3_bucket_versioning" "flink_artifacts" {
  bucket = aws_s3_bucket.flink_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Versionado del bucket Lakehouse
resource "aws_s3_bucket_versioning" "lakehouse" {
  bucket = aws_s3_bucket.lakehouse.id

  versioning_configuration {
    status = "Enabled"
  }
}