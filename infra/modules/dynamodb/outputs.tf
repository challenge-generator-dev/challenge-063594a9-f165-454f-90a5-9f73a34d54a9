// Outputs del modulo DynamoDB para exponer atributos de la tabla
// Estos outputs permiten al modulo consumidor acceder a la informacion
// de los recursos creados y utilizarlos en su propia configuracion

output "table_name" {
  description = "Nombre de la tabla DynamoDB"
  value       = aws_dynamodb_table.main.name
}

output "table_arn" {
  description = "ARN completo de la tabla DynamoDB"
  value       = aws_dynamodb_table.main.arn
}

output "table_id" {
  description = "ID unico de la tabla DynamoDB"
  value       = aws_dynamodb_table.main.id
}

output "table_stream_arn" {
  description = "ARN del stream de DynamoDB si esta habilitado"
  value       = var.stream_enabled ? aws_dynamodb_table.main.stream_arn : null
}

output "table_stream_label" {
  description = "Etiqueta del stream de DynamoDB si esta habilitado"
  value       = var.stream_enabled ? aws_dynamodb_table.main.stream_label : null
}

output "gsi_names" {
  description = "Lista de nombres de los indices globales secundarios"
  value       = [for gsi in aws_dynamodb_table.main.global_secondary_index : gsi.name]
}

output "gsi_arns" {
  description = "Lista de ARNs de los indices globales secundarios"
  value       = [for gsi in aws_dynamodb_table.main.global_secondary_index : gsi.arn]
}

output "hash_key_attribute_name" {
  description = "Nombre del atributo de clave primaria (hash)"
  value       = aws_dynamodb_table.main.hash_key
}

output "range_key_attribute_name" {
  description = "Nombre del atributo de clave de ordenacion (range)"
  value       = var.range_key
}

output "billing_mode" {
  description = "Modo de facturacion de la tabla"
  value       = aws_dynamodb_table.main.billing_mode
}

output "stream_topic_arn" {
  description = "ARN del topic SNS para notificaciones de stream"
  value       = var.stream_enabled ? aws_sns_topic.dynamodb_stream_topic[0].arn : null
}

output "log_group_name" {
  description = "Nombre del grupo de logs de CloudWatch"
  value       = var.stream_enabled ? aws_cloudwatch_log_group.dynamodb_logs[0].name : null
}

output "tags" {
  description = "Tags aplicados a la tabla"
  value       = aws_dynamodb_table.main.tags
}

output "ttl_enabled" {
  description = "Indica si TTL esta habilitado en la tabla"
  value       = var.ttl_attribute != null
}