# El state no es una fotografía del código Terraform, sino del estado conocido de los recursos que Terraform administra en la infraestructura
terraform {
  # Es la ruta o clave del objeto dentro del bucket S3 donde Terraform almacena el archivo de estado
  backend "s3" {
    bucket       = "dataeng-terraform-state-pre-entrega-6-2026"
    key          = "terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}