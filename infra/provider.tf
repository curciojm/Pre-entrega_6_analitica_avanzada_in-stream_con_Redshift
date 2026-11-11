provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Pre-entrega-6-Lakehouse"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "untagged"
  region = var.aws_region
}