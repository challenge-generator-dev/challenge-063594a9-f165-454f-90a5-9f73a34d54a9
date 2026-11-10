// Definicion de outputs para exponer informacion de los recursos creados
// Estos valores pueden ser consumidos por otras configuraciones de Terraform
// o por aplicaciones externas que necesitan la configuracion de infraestructura

// Outputs de la tabla DynamoDB de ordenes
output "dynamodb_table_name" {
  description = "Nombre de la tabla DynamoDB de ordenes"
  value       = module.dynamodb_orders.table_name
}

output "dynamodb_table_arn" {
  description = "ARN de la tabla DynamoDB de ordenes"
  value       = module.dynamodb_orders.table_arn
}

output "dynamodb_table_id" {
  description = "ID de la tabla DynamoDB de ordenes"
  value       = module.dynamodb_orders.table_id
}

output "dynamodb_table_stream_arn" {
  description = "ARN del stream de DynamoDB (si esta habilitado)"
  value       = module.dynamodb_orders.table_stream_arn
  sensitive   = false
}

output "dynamodb_table_stream_label" {
  description = "Etiqueta del stream de DynamoDB"
  value       = module.dynamodb_orders.table_stream_label
  sensitive   = false
}

output "dynamodb_gsi_names" {
  description = "Nombres de los indices secundarios globales configurados"
  value       = module.dynamodb_orders.gsi_names
}

output "dynamodb_gsi_arns" {
  description = "ARNs de los indices secundarios globales"
  value       = module.dynamodb_orders.gsi_arns
}

output "dynamodb_hash_key_attribute_name" {
  description = "Nombre del atributo de clave primaria (hash)"
  value       = module.dynamodb_orders.hash_key_attribute_name
}

output "dynamodb_range_key_attribute_name" {
  description = "Nombre del atributo de clave de ordenamiento (range)"
  value       = module.dynamodb_orders.range_key_attribute_name
}

output "dynamodb_billing_mode" {
  description = "Modo de facturacion de la tabla (PAY_PER_REQUEST o PROVISIONED)"
  value       = module.dynamodb_orders.billing_mode
}

// Outputs del bucket de estado de Terraform (si esta habilitado)
output "terraform_state_bucket_name" {
  description = "Nombre del bucket S3 para estado de Terraform"
  value       = var.enable_remote_state ? aws_s3_bucket.terraform_state[0].bucket : null
  sensitive   = false
}

output "terraform_state_bucket_arn" {
  description = "ARN del bucket S3 para estado de Terraform"
  value       = var.enable_remote_state ? aws_s3_bucket.terraform_state[0].arn : null
  sensitive   = false
}

// Outputs de la tabla de locks de Terraform
output "terraform_locks_table_name" {
  description = "Nombre de la tabla DynamoDB para locks de Terraform"
  value       = var.enable_remote_state ? aws_dynamodb_table.terraform_locks[0].name : null
  sensitive   = false
}

output "terraform_locks_table_arn" {
  description = "ARN de la tabla DynamoDB para locks de Terraform"
  value       = var.enable_remote_state ? aws_dynamodb_table.terraform_locks[0].arn : null
  sensitive   = false
}

// Outputs del topic de SNS para eventos de ordenes
output "order_events_topic_arn" {
  description = "ARN del topic SNS para eventos de ordenes"
  value       = var.dynamodb_stream_enabled ? aws_sns_topic.order_events[0].arn : null
  sensitive   = false
}

output "order_events_topic_name" {
  description = "Nombre del topic SNS para eventos de ordenes"
  value       = var.dynamodb_stream_enabled ? aws_sns_topic.order_events[0].name : null
  sensitive   = false
}

// Outputs del grupo de logs de CloudWatch
output "cloudwatch_log_group_name" {
  description = "Nombre del grupo de logs de CloudWatch"
  value       = aws_cloudwatch_log_group.application_logs.name
  sensitive   = false
}

output "cloudwatch_log_group_arn" {
  description = "ARN del grupo de logs de CloudWatch"
  value       = aws_cloudwatch_log_group.application_logs.arn
  sensitive   = false
}

// Outputs de informacion general del despliegue
output "deployment_info" {
  description = "Informacion consolidada del despliegue"
  value = {
    region              = var.aws_region
    environment         = var.environment
    project_name        = var.project_name
    dynamodb_table      = module.dynamodb_orders.table_name
    dynamodb_arn        = module.dynamodb_orders.table_arn
    stream_enabled      = var.dynamodb_stream_enabled
    log_group           = aws_cloudwatch_log_group.application_logs.name
    terraform_workspace = terraform.workspace
  }
  sensitive = false
}

output "tags_applied" {
  description = "Tags que se aplicaron a todos los recursos"
  value = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "terraform"
    }
  )
  sensitive = false
}