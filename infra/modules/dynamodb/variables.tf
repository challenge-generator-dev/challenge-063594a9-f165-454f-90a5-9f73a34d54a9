# Variables específicas para el módulo DynamoDB
# Estas variables permiten personalizar la configuración de la tabla DynamoDB.

variable "table_name" {
  description = "Nombre de la tabla DynamoDB"
  type        = string
}

variable "billing_mode" {
  description = "Modo de facturación para la tabla DynamoDB (PROVISIONED o PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "Clave hash (partition key) para la tabla DynamoDB"
  type        = string
}

variable "range_key" {
  description = "Clave de rango (sort key) para la tabla DynamoDB"
  type        = string
  default     = null
}

variable "attributes" {
  description = "Lista de atributos para la tabla DynamoDB"
  type = list(object({
    name = string
    type = string
  }))
}

variable "gsi" {
  description = "Lista de Global Secondary Indexes para la tabla DynamoDB"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = string
    projection_type = string
    read_capacity   = number
    write_capacity  = number
  }))
  default = []
}

variable "ttl_attribute" {
  description = "Nombre del atributo para TTL en la tabla DynamoDB"
  type        = string
  default     = null
}

variable "stream_enabled" {
  description = "Habilitar streams en la tabla DynamoDB"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Tipo de vista para el stream de DynamoDB (KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionales para la tabla DynamoDB"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Entorno donde se despliega la tabla DynamoDB"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto para etiquetar la tabla DynamoDB"
  type        = string
}