# ==============================================================================
# Definición de Versiones de Terraform y Providers
# ==============================================================================
# Este archivo controla la versión mínima de Terraform requerida para ejecutar
# esta configuración y establece las políticas de versionado para los providers.
# 
# La gestión centralizada de versiones es fundamental para:
# - Garantizar reproducibilidad del infraestructura entre entornos
# - Evitar breaking changes no deseados durante ejecuciones de Terraform
# - Mantener compatibilidad entre providers y el core de Terraform
# ==============================================================================

terraform {
  # Versión mínima requerida de Terraform
  # Terraform 1.9.0+ introdujo cambios significativos en el objeto terraform:
  # - Los atributos terraform.version y terraform.required_providers fueron deprecados
  # - Ahora solo está disponible terraform.workspace para consultar el workspace actual
  # - Las versiones de providers se definen en el bloque required_providers de cada provider
  required_version = ">= 1.9.0"
}

# ==============================================================================
# Notas sobre Gestión de Versiones en Terraform
# ==============================================================================
# 
# IMPORTANCIA DEL VERSIONADO EN INFRAESTRUCTURA COMO CÓDIGO:
# 
# 1. REPRODUCIBILIDAD: Al especificar una versión mínima, se garantiza que todos
#    los miembros del equipo y los pipelines de CI/CD utilizan una versión capaz
#    de ejecutar la configuración correctamente. Cada ejecución produce el mismo
#    resultado esperado, independientemente del entorno donde se ejecute.
# 
# 2. COMPATIBILIDAD: Las versiones de providers deben ser compatibles con la
#    versión de Terraform. El provider AWS versión 5.x requiere Terraform >= 1.0
#    y proporciona acceso a todos los servicios y features recientes de AWS.
# 
# 3. ESTABILIDAD: Usar restricciones flexibles (>=) en lugar de versiones exactas
#    permite recibir patches de seguridad y mejoras menores mientras se mantiene
#    la compatibilidad API. Esto reduce la carga de mantenimiento al no requerir
#    actualizaciones constantes.
# 
# 4. CONTROL DE CAMBIOS: Cuando se necesita actualizar a una nueva versión mayor,
#    es importante revisar las notas de lanzamiento (CHANGELOG) para identificar
#    breaking changes y planificar la migración appropriately.
# 
# PROVIDERS DEFINIDOS EN ESTE PROYECTO:
# 
# - AWS Provider (hashicorp/aws): Proveedor principal para recursos de AWS
#   Versión mínima: 5.0.0 - Esta versión introduce soporte para servicios nuevos
#   y mejoras en la gestión de recursos existentes. Incluye soporte para:
#   * DynamoDB Streams mejorados
#   * Configuración de tablas con GSI y TTL
#   * Integración con SNS para eventos
#   * Mejoras en el manejo de políticas de lifecycle
# 
# - Random Provider (hashicorp/random): Proveedor para generación de valores
#   aleatorios no deterministas. Útil para:
#   * Generación de IDs únicos para recursos
#   * Passwords temporales seguros
#   * Valores de salt para funciones hash
#   * Nombres de recursos que requieren unicidad
# 
# NOTA IMPORTANTE: Las versiones específicas de providers y su configuración
# detallada se gestionan en el archivo providers.tf. Este archivo solo declara
# la versión mínima de Terraform requerida para el proyecto.
# 
# REFERENCIAS:
# - Documentación oficial de Terraform: https://www.terraform.io/docs
# - AWS Provider CHANGELOG: https://github.com/hashicorp/terraform-provider-aws/releases
# - Random Provider: https://registry.terraform.io/providers/hashicorp/random
# ==============================================================================