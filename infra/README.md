# Módulo de Infraestructura - Order Management

## Propósito

Este módulo define la infraestructura necesaria para el sistema de gestión de órdenes, incluyendo la tabla DynamoDB como almacenamiento principal y los recursos de AWS asociados para su operación.

## Estructura del Módulo

```
infra/
├── environments/
│   └── dev/
│       └── terraform.tfvars    # Valores para entorno de desarrollo
├── modules/
│   └── dynamodb/
│       ├── main.tf             # Definición del recurso DynamoDB
│       ├── variables.tf        # Variables del módulo
│       └── outputs.tf          # Salidas del módulo
├── main.tf                     # Orquestación principal
├── variables.tf                # Variables globales
├── outputs.tf                  # Salidas globales
├── providers.tf                # Configuración de providers
└── versions.tf                 # Requisitos de versión
```

## Recursos Definidos

### Tabla DynamoDB - Órdenes

- **Nombre**: `orders-{environment}` (ej. `orders-dev`)
- **Modo de facturación**: Pay-per-request
- **Clave primaria**: `order_id` (String)
- **Índices secundarios globales**:
  - `CustomerIdIndex`: Permite consultas por cliente
  - `StatusIndex`: Permite consultas por estado de orden
- **Transmisión de cambios**: Habilitada (NEW_AND_OLD_IMAGES)
- **Recuperación punto-en-tiempo**: Habilitada

## Uso Local

### Prerrequisitos

- Terraform >= 1.9.5
- AWS CLI configurado con credenciales
- Provider AWS ~> 5.68.0

### Comandos de Validación

```bash
# Navegar al directorio del módulo
cd infra

# Inicializar Terraform
terraform init

# Validar sintaxis de archivos
terraform validate

# Planificar cambios (ver qué se creará)
terraform plan -var-file=environments/dev/terraform.tfvars

# Aplicar cambios (crear recursos)
terraform apply -var-file=environments/dev/terraform.tfvars

# Destruir recursos (limpieza)
terraform destroy -var-file=environments/dev/terraform.tfvars
```

## Variables Principales

| Variable | Descripción | Valor Default |
|----------|-------------|---------------|
| `environment` | Entorno de despliegue | `dev` |
| `project_name` | Nombre del proyecto | `order-management` |
| `aws_region` | Región AWS | `us-east-1` |
| `dynamodb_table_name` | Nombre de la tabla | `orders` |
| `dynamodb_billing_mode` | Modo de facturación | `PAY_PER_REQUEST` |
| `dynamodb_hash_key` | Clave de partición | `order_id` |

## Salidas Exportadas

- **Tabla DynamoDB**: ARN, nombre, ID del stream
- **Endpoint de acceso**: URL regional de DynamoDB

## Consideraciones de Seguridad

- La tabla utiliza cifrado por defecto con AWS managed keys
- El acceso se controla mediante políticas de IAM
- Los GSIs tienen capacidad dedicada para evitar interferencia
- PITR habilitado para recuperación ante desastres
- Streams habilitados para integración con EventBridge/Kafka

## Integración con Otros Módulos

Este módulo se integra con:
- **API REST** (Java/Spring Boot): Lee la tabla para consultas
- **EventBridge**: Consume streams para procesamiento asíncrono
- **Lambda**: Procesa eventos de cambios en la tabla

## Limpieza de Recursos

Para eliminar todos los recursos creados:

```bash
terraform destroy -var-file=environments/dev/terraform.tfvars
```

**Nota**: La destrucción de la tabla DynamoDB es irreversible. Asegúrate de tener backups si es necesario.