# Configuración de providers para Terraform
# Este archivo define los providers necesarios para desplegar la infraestructura en AWS.
# Se utilizan versiones específicas para garantizar compatibilidad y estabilidad.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  required_version = ">= 1.9.0"
}

# Configuración del provider AWS
# Define la región por defecto y permite la personalización mediante variables.
provider "aws" {
  region = var.aws_region

  # Tags estandarizados para todos los recursos
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }

  # Configuración de endpoints para acceso a servicios AWS
  # Permite personalización avanzada si es necesario
  endpoints {
    # DynamoDB = "http://localhost:8000"
    # SNS     = "http://localhost:4566"
  }
}

# Configuración de alias para providers alternativos
# Útil para desplegar en múltiples regiones o cuentas
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}