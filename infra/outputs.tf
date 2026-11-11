output "kinesis_stream_name" {
  description = "Nombre del Kinesis Data Stream."
  value       = aws_kinesis_stream.stock_quotes.name
}

output "kinesis_stream_arn" {
  description = "ARN del Kinesis Data Stream."
  value       = aws_kinesis_stream.stock_quotes.arn
}

output "flink_application_name" {
  description = "Nombre de la aplicación AWS Managed Flink."
  value       = aws_kinesisanalyticsv2_application.stock_lakehouse.name
}

output "flink_application_arn" {
  description = "ARN de la aplicación AWS Managed Flink."
  value       = aws_kinesisanalyticsv2_application.stock_lakehouse.arn
}

output "lakehouse_bucket_name" {
  description = "Nombre del bucket S3 del Lakehouse."
  value       = aws_s3_bucket.lakehouse.bucket
}

output "flink_artifact_bucket_name" {
  description = "Nombre del bucket S3 que almacena el JAR."
  value       = aws_s3_bucket.flink_artifacts.bucket
}

output "glue_database_name" {
  description = "Nombre de la base de datos del Glue Data Catalog."
  value       = aws_glue_catalog_database.lakehouse.name
}

# ============================================================
# Amazon Redshift
# ============================================================

output "redshift_cluster_identifier" {
  description = "Identificador del clúster Amazon Redshift."
  value       = aws_redshift_cluster.main.cluster_identifier
}
# redshift_endpoint: identifica dónde está alojado el clúster y su puerto.
output "redshift_endpoint" {
  description = "Endpoint de conexión del clúster Redshift."
  value       = aws_redshift_cluster.main.endpoint
}
# redshift_database_name: identifica la base que utilizaremos para ejecutar SQL.
output "redshift_database_name" {
  description = "Nombre de la base de datos de Redshift."
  value       = aws_redshift_cluster.main.database_name
}

output "redshift_iam_role_arn" {
  description = "ARN del rol IAM asociado a Redshift."
  value       = aws_iam_role.redshift.arn
}

output "redshift_security_group_id" {
  description = "ID del Security Group asociado a Redshift."
  value       = aws_security_group.redshift.id
}

output "redshift_subnet_group_name" {
  description = "Nombre del subnet group de Redshift."
  value       = aws_redshift_subnet_group.main.name
}