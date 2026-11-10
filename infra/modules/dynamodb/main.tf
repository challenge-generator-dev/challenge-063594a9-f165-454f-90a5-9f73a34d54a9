// Configuracion del modulo de DynamoDB para almacenamiento de ordenes
// Define la tabla principal con opciones de streaming y GSI

resource "aws_dynamodb_table" "main" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key

  // Habilitacion de DynamoDB Streams para captura de cambios
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  // Definicion dinamica de atributos segun la configuracion
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  // Indice secundario global para queries alternativas
  dynamic "global_secondary_index" {
    for_each = var.gsi
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = lookup(global_secondary_index.value, "range_key", null)
      projection_type = lookup(global_secondary_index.value, "projection_type", "KEYS_ONLY")
      read_capacity   = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity  = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  // Configuracion de TTL para expiracion automatica de items
  dynamic "ttl" {
    for_each = var.ttl_attribute != null ? [var.ttl_attribute] : []
    content {
      attribute_name = ttl.value
      enabled        = true
    }
  }

  // Tags estandarizados para todos los recursos
  tags = merge(
    var.tags,
    {
      "Environment" = var.environment
      "Project"     = var.project_name
      "ManagedBy"   = "Terraform"
      "Module"      = "dynamodb"
    }
  )

  lifecycle {
    ignore_changes = [tags["Environment"], tags["Project"]]
  }
}

// Grupo de logs de CloudWatch para DynamoDB Streams
// Permite monitoreo y analisis de eventos de la tabla
resource "aws_cloudwatch_log_group" "dynamodb_logs" {
  count = var.stream_enabled ? 1 : 0

  name              = "/aws/dynamodb/${var.table_name}"
  retention_in_days = 7

  tags = merge(
    var.tags,
    {
      "Environment" = var.environment
      "Project"     = var.project_name
      "ManagedBy"   = "Terraform"
    }
  )
}

// Topic de SNS para notificaciones de eventos de DynamoDB Streams
// Integracion para procesamiento asincrono de cambios en la tabla
resource "aws_sns_topic" "dynamodb_stream_topic" {
  count = var.stream_enabled ? 1 : 0

  name = "${var.table_name}-stream-notifications"

  tags = merge(
    var.tags,
    {
      "Environment" = var.environment
      "Project"     = var.project_name
      "ManagedBy"   = "Terraform"
    }
  )
}

// Suscripcion de Lambda al topic de SNS para procesamiento de eventos
// Configura el flujo de eventos desde DynamoDB Streams hacia una funcion Lambda
resource "aws_sns_topic_subscription" "dynamodb_stream_subscription" {
  count = var.stream_enabled ? 1 : 0

  topic_arn = aws_sns_topic.dynamodb_stream_topic[0].arn
  protocol  = "lambda"
  endpoint  = "arn:aws:lambda:${var.environment}:function:${var.project_name}-stream-processor"
}