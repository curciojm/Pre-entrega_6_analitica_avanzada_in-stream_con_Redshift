resource "aws_redshift_cluster" "main" {
  cluster_identifier = var.redshift_cluster_identifier
  database_name      = var.redshift_database_name

  node_type       = var.redshift_node_type
  cluster_type    = "single-node"
  number_of_nodes = var.redshift_number_of_nodes

  master_username        = var.redshift_master_username
  manage_master_password = true

  cluster_subnet_group_name = aws_redshift_subnet_group.main.name
  vpc_security_group_ids    = [aws_security_group.redshift.id]
  publicly_accessible       = false

  encrypted = true

  iam_roles = [
    aws_iam_role.redshift.arn
  ]

  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.redshift_cluster_identifier}-final"

  tags = {
    Name        = var.redshift_cluster_identifier
    Project     = "Pre-entrega-6-Lakehouse"
    Environment = var.environment
  }
}
