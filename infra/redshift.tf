
# ============================================================
# Amazon Redshift - Cluster Provisioned
# ============================================================

resource "aws_redshift_cluster" "main" {
  # Identificación del clúster
  cluster_identifier = var.redshift_cluster_identifier
  database_name      = var.redshift_database_name

  # Configuración de cómputo
  node_type       = var.redshift_node_type
  cluster_type    = "single-node"
  number_of_nodes = var.redshift_number_of_nodes

  # Credenciales administradas por AWS Secrets Manager
  master_username        = var.redshift_master_username
  manage_master_password = true
  # manage_master_password = true indica que AWS debe gestionar la contraseña maestra mediante Secrets Manager

  # Configuración de red, conexion network.tf
  cluster_subnet_group_name = aws_redshift_subnet_group.main.name
  vpc_security_group_ids    = [aws_security_group.redshift.id]
  publicly_accessible       = false

  # Seguridad y almacenamiento
  encrypted = true

  # Rol IAM que utilizará Redshift
  # aws_iam_role recorda es QUIEN tiene el permiso
  iam_roles = [
    aws_iam_role.redshift.arn
  ]

  # Política de snapshot al eliminar el clúster
  # Elegí inicialmente skip_final_snapshot = false. Esto significa que, cuando eliminemos el clúster, AWS generará una copia final antes de borrarlo
  skip_final_snapshot       = true # pasar a false cuando termines
  final_snapshot_identifier = "${var.redshift_cluster_identifier}-final"

  tags = {
    Name        = var.redshift_cluster_identifier
    Project     = "Pre-entrega-6-Lakehouse"
    Environment = var.environment
  }
}
