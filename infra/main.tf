// Configuracion principal de Terraform para el proyecto de gestion de ordenes
// Este archivo orquesta la creacion de recursos AWS mediante el uso de modulos

// Configuracion del proveedor AWS con region y parametros comunes

// Modulo de DynamoDB para almacenar ordenes
// Este modulo crea la tabla con la estructura optimizada para queries
module "dynamodb_orders" {
  source = "./modules/dynamodb"

  // Parametros de la tabla
  table_name       = var.dynamodb_table_name
  billing_mode     = var.dynamodb_billing_mode
  hash_key         = var.dynamodb_hash_key
  range_key        = var.dynamodb_range_key
  attributes       = var.dynamodb_attributes
  gsi              = var.dynamodb_gsi
  ttl_attribute    = var.dynamodb_ttl_attribute
  stream_enabled   = var.dynamodb_stream_enabled
  stream_view_type = var.dynamodb_stream_view_type

  // Metadatos para tags y nomenclatura
  tags         = var.tags
  environment  = var.environment
  project_name = var.project_name
}

// Configuracion de Remote State en S3 para persistencia del estado de Terraform
// Esto permite colaboracion entre multiples usuarios y protege el estado local
resource "aws_s3_bucket" "terraform_state" {
  count = var.enable_remote_state ? 1 : 0

  bucket = "${var.project_name}-${var.environment}-terraform-state"

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-terraform-state"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  count = var.enable_remote_state ? 1 : 0

  bucket = aws_s3_bucket.terraform_state[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  count = var.enable_remote_state ? 1 : 0

  bucket = aws_s3_bucket.terraform_state[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// Bloqueo de deletion del bucket de estado para prevenir perdidas accidentales
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  count = var.enable_remote_state ? 1 : 0

  bucket = aws_s3_bucket.terraform_state[0].id

  rule {
    id     = "prevent-delete"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}

// Configuracion de DynamoDB para locking del estado de Terraform
// Previene corrupcion del estado cuando multiples personas trabajan simultaneamente
resource "aws_dynamodb_table" "terraform_locks" {
  count = var.enable_remote_state ? 1 : 0

  name         = "${var.project_name}-${var.environment}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  range_key    = "Digest"

  attribute {
    name = "LockID"
    type = "S"
  }

  attribute {
    name = "Digest"
    type = "S"
  }

  ttl {
    attribute_name = "ExpirationTime"
    enabled        = true
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-terraform-locks"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

// Configuracion de SNS para notificaciones de cambios en la tabla
// Integrado con DynamoDB Streams para procesamiento de eventos
resource "aws_sns_topic" "order_events" {
  count = var.dynamodb_stream_enabled ? 1 : 0

  name = "${var.project_name}-${var.environment}-order-events"

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-order-events"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

// Suscripcion al topic de SNS para procesamiento de eventos
// Permite que Lambda u otros servicios consuman eventos de la tabla
resource "aws_sns_topic_subscription" "order_events_lambda" {
  count     = var.dynamodb_stream_enabled && var.lambda_function_arn != null ? 1 : 0
  topic_arn = aws_sns_topic.order_events[0].arn
  endpoint  = var.lambda_function_arn
  protocol  = "lambda"
}

// Configuracion de CloudWatch para logs de la aplicacion
// Grupo de logs centralizado para todos los servicios del proyecto
resource "aws_cloudwatch_log_group" "application_logs" {
  name              = "/aws/${var.project_name}/${var.environment}/application"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.tags,
    {
      Name        = "${var.project_name}-${var.environment}-application-logs"
      Environment = var.environment
      Project     = var.project_name
    }
  )
}