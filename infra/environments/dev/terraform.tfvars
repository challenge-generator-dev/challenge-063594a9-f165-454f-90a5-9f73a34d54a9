# Valores de variables para el entorno de desarrollo
# Estos valores se cargan automáticamente al ejecutar terraform en el directorio environments/dev

# Configuración del entorno
environment  = "dev"
project_name = "order-management"
aws_region   = "us-east-1"

# Tags estándar para todos los recursos
tags = {
  Environment = "dev"
  Project     = "order-management"
  ManagedBy   = "terraform"
  Owner       = "platform-team"
}

# Configuración de la tabla DynamoDB
dynamodb_table_name       = "orders-dev"
dynamodb_billing_mode     = "PAY_PER_REQUEST"
dynamodb_hash_key         = "order_id"
dynamodb_range_key        = null
dynamodb_ttl_attribute    = "expires_at"
dynamodb_stream_enabled   = true
dynamodb_stream_view_type = "NEW_AND_OLD_IMAGES"

# Atributos de la tabla DynamoDB
# DynamoDB requiere declarar atributos usados en claves
dynamodb_attributes = [
  {
    name = "order_id"
    type = "S"
  },
  {
    name = "customer_id"
    type = "S"
  },
  {
    name = "status"
    type = "S"
  },
  {
    name = "created_at"
    type = "S"
  }
]

# Índices secundarios globales (GSI)
# GSI-1: Query por customer_id (acceso común en sistemas de pedidos)
dynamodb_gsi = [
  {
    name            = "CustomerIdIndex"
    hash_key        = "customer_id"
    range_key       = "created_at"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  },
  # GSI-2: Query por status (para listar órdenes por estado)
  {
    name            = "StatusIndex"
    hash_key        = "status"
    range_key       = "created_at"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }
]

# Configuración de red (VPC donde se desplegará la tabla)
# En desarrollo usamos la VPC por defecto
vpc_id     = null
subnet_ids = []
# dynamodb_endpoint = true  # Habilitar endpoint de VPC para DynamoDB

# Configuración de acceso a la tabla
# Policy personalizada para acceso a la tabla
dynamodb_policy_actions = [
  "dynamodb:GetItem",
  "dynamodb:PutItem",
  "dynamodb:UpdateItem",
  "dynamodb:DeleteItem",
  "dynamodb:Query",
  "dynamodb:Scan"
]

# Habilitar backups puntuales
enable_point_in_time_recovery = true

# Configuración de logging
enable_dynamodb_streams = true