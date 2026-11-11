# El valor predeterminado no es obligatorio: es el valor que Terraform utiliza cuando no recibe uno explícito.
# default es el que usa por default si no se pone otra cosa en tfvars, es archivo es prioridad.
# Es el valor predeterminado de la variable, no necesariamente el nombre de un recurso.
variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura."
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Entorno de despliegue."
  type        = string
  default     = "dev"
}

variable "kinesis_stream_name" {
  description = "Nombre del Kinesis Data Stream existente que utilizará Flink."
  type        = string
  default     = "dev-kinesis-lakehouse-stream"
}

variable "flink_artifact_bucket_name" {
  description = "Nombre del bucket S3 que almacenará el artefacto JAR de Flink."
  type        = string
}

variable "lakehouse_bucket_name" {
  description = "Nombre del bucket S3 donde se almacenarán los datos de Iceberg."
  type        = string
}

variable "flink_jar_path" {
  description = "Ruta local del JAR compilado de la aplicación Flink."
  type        = string
}

# Configuración de Amazon Redshift Provisioned

variable "redshift_cluster_identifier" {
  description = "Identificador del clúster de Amazon Redshift."
  type        = string
  default     = "redshift-lakehouse-dev"
}

variable "redshift_database_name" {
  description = "Nombre de la base de datos inicial de Redshift."
  type        = string
  default     = "analytics"
}

variable "redshift_master_username" {
  description = "Usuario administrador del clúster Redshift."
  type        = string
  default     = "admin"
}

variable "redshift_node_type" {
  description = "Tipo de nodo del clúster Redshift."
  type        = string
}

variable "redshift_number_of_nodes" {
  description = "Cantidad de nodos del clúster Redshift."
  type        = number
  default     = 1
}