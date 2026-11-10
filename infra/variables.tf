# Definición de variables globales para la infraestructura
# Estas variables se utilizan en múltiples módulos y recursos.

# Variable para el entorno (dev, staging, prod)
variable "environment" {
  description = "Entorno donde se despliega la infraestructura"
  type        = string
  default     = "dev"
}

# Variable para el nombre del proyecto
variable "project_name" {
  description = "Nombre del proyecto para nombrar recursos"
  type        = string
  default     = "order-management"
}

# Variable para la región de AWS
variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
  default     = "us-east-1"
}

# Variable para los tags adicionales
# Permite agregar tags personalizados a los recursos.
variable "tags" {
  description = "Tags adicionales para los recursos"
  type        = map(string)
  default     = {}
}

# Variables específicas para el módulo DynamoDB
variable "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB para órdenes"
  type        = string
  default     = "orders"
}

variable "dynamodb_billing_mode" {
  description = "Modo de facturación para la tabla DynamoDB (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "dynamodb_hash_key" {
  description = "Clave hash (partition key) para la tabla DynamoDB"
  type        = string
  default     = "order_id"
}

variable "dynamodb_range_key" {
  description = "Clave de rango (sort key) para la tabla DynamoDB"
  type        = string
  default     = null
}

variable "dynamodb_attributes" {
  description = "Lista de atributos para la tabla DynamoDB"
  type = list(object({
    name = string
    type = string
  }))
  default = [
    {
      name = "order_id"
      type = "S"
    },
    {
      name = "client_id"
      type = "S"
    },
    {
      name = "product_id"
      type = "S"
    },
    {
      name = "order_date"
      type = "S"
    }
  ]
}

variable "dynamodb_gsi" {
  description = "Lista de Global Secondary Indexes para la tabla DynamoDB"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
    read_capacity   = number
    write_capacity  = number
  }))
  default = [
    {
      name            = "client_index"
      hash_key        = "client_id"
      range_key       = null
      projection_type = "ALL"
      read_capacity   = null
      write_capacity  = null
    },
    {
      name            = "product_index"
      hash_key        = "product_id"
      range_key       = null
      projection_type = "ALL"
      read_capacity   = null
      write_capacity  = null
    }
  ]
}

variable "dynamodb_ttl_attribute" {
  description = "Nombre del atributo para TTL en la tabla DynamoDB"
  type        = string
  default     = null
}

variable "dynamodb_stream_enabled" {
  description = "Habilitar streams en la tabla DynamoDB"
  type        = bool
  default     = false
}

variable "dynamodb_stream_view_type" {
  description = "Tipo de vista para el stream de DynamoDB (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = null
}

# Variable para habilitar el estado remoto de Terraform
# Utilizado para almacenar el estado en S3 con bloqueo en DynamoDB
variable "enable_remote_state" {
  description = "Habilitar el uso de estado remoto de Terraform en S3"
  type        = bool
  default     = true
}

# Variable para el ARN de la función Lambda
# Suscribirse al topic SNS para procesar eventos de órdenes
variable "lambda_function_arn" {
  description = "ARN de la función Lambda que procesa eventos de órdenes"
  type        = string
  default     = ""
}

# Variable para los días de retención de logs en CloudWatch
# Define cuánto tiempo se mantienen los logs de la aplicación
variable "log_retention_days" {
  description = "Número de días de retención para los logs de CloudWatch"
  type        = number
  default     = 7
}