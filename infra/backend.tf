terraform {
  backend "s3" {
    bucket       = "dataeng-terraform-state-pre-entrega-6-2026"
    key          = "terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true
  }
}