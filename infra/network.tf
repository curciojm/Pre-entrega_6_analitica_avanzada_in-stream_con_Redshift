data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_redshift_subnet_group" "main" {
  name        = "redshift-subnet-group-${var.environment}"
  description = "Subnet group for the Redshift Lakehouse cluster"
  subnet_ids  = data.aws_subnets.default.ids

  tags = {
    Name        = "redshift-subnet-group-${var.environment}"
    Project     = "Pre-entrega-6-Lakehouse"
    Environment = var.environment
  }
}

resource "aws_security_group" "redshift" {
  name        = "redshift-security-group-${var.environment}"
  description = "Security group for the Redshift Lakehouse cluster"
  vpc_id      = data.aws_vpc.default.id

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "redshift-security-group-${var.environment}"
    Project     = "Pre-entrega-6-Lakehouse"
    Environment = var.environment
  }
}

resource "aws_security_group" "kinesis_endpoint" {
  name        = "kinesis-endpoint-security-group-${var.environment}"
  description = "Allow HTTPS from Redshift to Kinesis VPC endpoint"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "HTTPS from Redshift"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.redshift.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "kinesis-endpoint-security-group-${var.environment}"
    Project     = "Pre-entrega-6-Lakehouse"
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "kinesis" {
  vpc_id              = data.aws_vpc.default.id
  service_name        = "com.amazonaws.${var.aws_region}.kinesis-streams"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = [
    sort(data.aws_subnets.default.ids)[0]
  ]

  security_group_ids = [
    aws_security_group.kinesis_endpoint.id
  ]

  tags = {
    Name        = "kinesis-vpc-endpoint-${var.environment}"
    Project     = "Pre-entrega-6-Lakehouse"
    Environment = var.environment
  }
}
