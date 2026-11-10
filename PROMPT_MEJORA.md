# Prompt para Mejorar el Codigo Base

Copia y pega el contenido del bloque de abajo en un asistente de IA (Claude, ChatGPT)
para obtener el proyecto completo y arrancable. Guarda los archivos que te devuelva en la
carpeta del repo, respetando exactamente las rutas.

Si preferis trabajar en tu editor con un agente local (Claude Code, Cursor, Copilot), usa `AGENTS.md` en vez de este archivo: dice lo mismo pero para que escriba los archivos en disco.

## Las dos reglas que no se negocian

1. **Completa el boilerplate.** Todo lo que el proyecto necesita para compilar y arrancar: manifiesto de dependencias, punto de entrada, configuracion, capa de interfaz, y las capas del patron arquitectonico declarado. Eso es andamiaje y es tu trabajo.
2. **NO resuelvas el reto.** Los entregables de las fases son el trabajo de la persona. El hueco pedagogico se deja como esta: el proyecto arranca, pero lo que el reto pide implementar NO esta implementado.

Dicho de otra forma: si algo impide compilar, arreglalo. Si algo es logica de negocio incompleta, validaciones ausentes, un secreto hardcodeado o un patron mejorable, dejalo exactamente como esta — es lo que la persona tiene que encontrar.

## Mapa de componentes

El repo tiene una carpeta por componente. Cada uno se instala y verifica dentro de la suya.

| Componente | Carpeta | Rol | Capa | Track | Tecnologias |
|---|---|---|---|---|---|
| `app` | `app/` | practice, chapter | server | Node | Express, DynamoDB |
| `infra` | `infra/` | support | infra | Terraform (AWS) | Terraform |
| `infra-local` | (raiz) | support | infra | Compose local | DynamoDB |

## Orden de arranque

1. `docker compose up -d` (en la raiz) — levanta la infraestructura local.
2. `cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate` — componente `infra` (support).
3. `cd app && npm install && npm run build` — componente `app` (practice, chapter).

### Contratos entre componentes

- `app` expone http (api: http://localhost:3000):
  - `POST /orders`
  - `GET /orders/:id`
  - `PUT /orders/:id`
  - `DELETE /orders/:id`
  - `GET /orders`

## Herramientas

- **Terraform**: Herramienta de trabajo del candidato: usala en la fase donde se depura o se prueba la solucion (no es una dependencia del proyecto).

## Lo que le falta a este proyecto

Esto NO lo tenes que adivinar: salio de comparar el proyecto contra la arquitectura declarada del reto y de un analisis estatico del codigo. Completalo TODO.

### Boilerplate del stack que falta

Sin esto no compila ni arranca. Es andamiaje, no toca nada de lo pedagogico:

- **app/src/app.module.ts** — Sin el modulo raiz, Nest no tiene arbol de dependencias que resolver y el bootstrap falla.

### Referencias colgando en el codigo que si esta

Cada una rompe la compilacion:

- `app/src/middleware/validation.middleware.ts` — `ValidationErrorDetail.push`: Se invoca `push` sobre `ValidationErrorDetail`, pero esa clase no declara ese metodo. Agregalo con su implementacion real, o usa uno de los que si declara.

## Como saber que terminaste

```bash
(cd app && npm install && npm run build) && (cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate) && docker compose config -q
```

Ese comando corriendo sin errores es la definicion de "listo".

---

```
## Briefing del reto (autoridad)
Este bloque manda sobre los archivos adjuntos. El stack y el rol salen de AQUÍ, no de un topic genérico ni de markdown placeholder.

### Perfil
Chapter Backend, Especialidad Desarrollador, Tecnología Node, Advanced L2

### Brecha de conocimiento
CRUD de ordenes en DynamoDB expuesto por una API REST (corrida e2e 20261110141755634), Implementa operaciones CRUD de ordenes sobre una tabla DynamoDB expuestas por una API REST

### Misión / candidato
Persistir y consultar ordenes

### Reto
- Tema: CRUD de ordenes sobre DynamoDB
- Seniority: advanced-l2
- Tipo: practical
- Título: Implementación de operaciones CRUD para órdenes en DynamoDB
- Tiempo estimado: 8 horas

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Creación de la tabla DynamoDB y API REST — objetivo: Configurar la tabla DynamoDB y exponer las operaciones CRUD a través de una API REST. — entregable (NO resolver): Tabla DynamoDB configurada y API REST que expone operaciones CRUD.
- Fase 2: Manejo de errores y validaciones — objetivo: Implementar el manejo de errores y validaciones en las operaciones CRUD. — entregable (NO resolver): API REST con manejo de errores y validaciones para las operaciones CRUD.
- Fase 3: Optimización y refactorización — objetivo: Optimizar y refactorizar el código para mejorar la eficiencia y mantenibilidad. — entregable (NO resolver): Código refactorizado y optimizado para las operaciones CRUD en la API REST.

Eres un asistente experto en análisis, corrección y generación de archivos de cualquier tipo:
código fuente, documentación, hojas de cálculo, documentos Word, configuraciones, entre otros.
Voy a enviarte una cadena de texto que contiene uno o más archivos. Cada archivo está delimitado por un marcador con el siguiente formato:
// === ARCHIVO: ruta/del/archivo.extension ===
o también puede aparecer como:
## === ARCHIVO: ruta/del/archivo.extension ===
Lo que sigue al marcador puede ser:

El contenido real del archivo (código, texto, YAML, etc.)
Una descripción en lenguaje natural de lo que debe contener el archivo


TU TAREA
PASO 0 — ¿Esto es un proyecto o una carcasa?
Antes de extraer archivos, leé el Briefing (si está) y diagnosticá el adjunto.

Es CARCASA si ocurre CUALQUIERA de estas:
- No hay manifiesto de dependencias del stack del briefing (manifest.json de VTEX IO / package.json / pom.xml / build.gradle / requirements.txt / go.mod / *.tf / *.csproj, según corresponda)
- Hay un "binario" que en realidad es un comentario ("no puede ser mostrado como texto plano", placeholder .fig/.docx vacío)
- Los markdowns ya completan entregables de fases posteriores ("se implementó fade-in", lista de áreas ya resuelta)

Si es CARCASA:
- MATERIALIZÁ un proyecto que arranca en el stack del briefing (VTEX IO Store Framework, Angular, Terraform, pytest, Nest, etc.). Incluí manifiesto, punto de entrada y capa de interfaz reales.
- NO copies los markdowns de "solución" como si fueran el producto. Son ruido de generación.
- NO resuelvas las fases del briefing (están marcadas PROHIBIDO). Dejá el hueco pedagógico: el flujo existe, las microinteracciones/calidad/infra que el reto pide NO están hechas.
- Después seguí al PASO 5 (entrega de archivos).

Si es un proyecto REAL (manifiesto + código que compila o arranca):
- Seguí PASO 1 en adelante. 🔴 compilación sí. 🟡 pedagógico no.

PASO 1 — Detección y extracción
Identifica todos los archivos presentes en la cadena. Para cada archivo extrae:

Su ruta completa (ej: src/main/java/com/pragma/Service.java)
Su contenido o descripción

PASO 2 — Clasificación por tipo
Clasifica cada archivo en una de estas categorías:
A) Código fuente (Java, Python, TypeScript, JavaScript, Kotlin, etc.)
B) Configuración / documentación (YAML, properties, Markdown, JSON, txt, etc.)
C) Excel (.xlsx, .xls, .csv)
D) Word (.docx, .doc)
E) Otro tipo de archivo binario o especial
PASO 3 — Clasificación de errores en código fuente

Objetivo prioritario: que el proyecto compile. No corrijas flujo de negocio ni lógica funcional.

Antes de modificar cualquier archivo de código fuente, clasifica cada problema encontrado en una de estas dos categorías:
🔴 ERROR DE COMPILACIÓN — corregir siempre
Son errores que impiden que el proyecto arranque, sin valor pedagógico:

Import faltante o incorrecto
Clase, método o variable referenciada que no existe en ningún archivo del proyecto
Error de sintaxis
Anotación con atributos inválidos
Dependencia ausente en pom.xml, package.json, etc.
Archivo referenciado que no existe y debe ser creado con implementación mínima

→ CORREGIR estos errores.
🟡 PROBLEMA FUNCIONAL O DE CALIDAD — preservar siempre
Son problemas que no impiden compilar. Pueden ser intencionales para el aprendizaje:

Clave secreta hardcodeada ("secret", "password123")
API deprecada que funciona pero tiene reemplazo moderno
Lógica de negocio incorrecta o incompleta
Código redundante o de baja legibilidad
Falta de validaciones en flujo de negocio
Patrones de diseño incorrectos pero funcionales
Concurrencia no segura
Configuración funcional pero no óptima

→ PRESERVAR tal cual. No corregir, no mejorar, no comentar.
PASO 4 — Procesamiento según tipo de archivo
Tipo A — Código fuente
Aplica únicamente las correcciones clasificadas como 🔴 ERROR DE COMPILACIÓN.
No alteres ningún elemento clasificado como 🟡 PROBLEMA FUNCIONAL O DE CALIDAD.
Si falta un archivo referenciado, créalo con la implementación mínima necesaria para compilar.
Tipo B — Configuración / documentación
Extrae el contenido tal cual, sin modificaciones salvo errores evidentes de sintaxis
(ej: YAML mal indentado).
Tipo C — Excel (.xlsx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un archivo Excel funcional con:

Fila de encabezados en negrita con color de fondo distintivo
Columnas con ancho ajustado al contenido
Tipos de dato correctos por columna
Validaciones si la descripción lo indica
Hojas nombradas descriptivamente si hay más de una
Filas de ejemplo si no hay datos reales

Tipo D — Word (.docx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un documento Word funcional con:

Estilos de título (Título 1, Título 2) para jerarquía de secciones
Fuente legible (Calibri o equivalente), tamaño 11-12pt para cuerpo
Márgenes estándar
Tabla de contenido si tiene múltiples secciones
Tablas con encabezados en negrita si aplica

Tipo E — Otro
Genera el archivo con el contenido o estructura más apropiada según la descripción.
PASO 5 — Entrega de archivos
Entregá cada archivo con su ruta completa, respetando exactamente la estructura de rutas
indicada por los marcadores: un bloque por archivo, precedido por su ruta. No generes ZIPs
ni archivos adjuntos.
La entrega debe incluir:

Archivos de código con únicamente los errores de compilación corregidos
Archivos de configuración y documentación sin cambios
Archivos nuevos creados para resolver dependencias de compilación faltantes
Archivos Excel y Word generados desde descripción

IMPORTANTE: Entregá los archivos completos al finalizar. No preguntes si el usuario
quiere recibirlos. Simplemente entregalos; No debes desplegar en el chat el resumen de lo que arreglaste, solo entregá los archivos.

REGLAS IMPORTANTES

No omitas ningún archivo aunque no tenga errores ni modificaciones
Respeta los nombres y rutas exactas indicadas por los marcadores
Si un archivo no tiene marcador claro, infiere el nombre desde su contenido
Si la cadena contiene solo documentación, placeholders o binarios fake, NO la reproduzcas:
aplicá PASO 0 (materializar el proyecto del briefing). Reproducir la carcasa es un fallo.
No agregues texto después del último archivo entregado
No preguntes si el usuario quiere los archivos: simplemente entregalos siempre
Si detectas que falta un archivo de configuración necesario para compilar
(pom.xml, package.json, requirements.txt, build.gradle, etc.), créalo e inclúyelo
inferiendo su contenido desde los imports y frameworks detectados en el código
Nunca corrijas problemas 🟡 aunque parezcan obvios o fáciles de mejorar.
El participante que recibirá este proyecto los debe encontrar y resolver él mismo.


INPUT
Aquí está la cadena con los archivos:

// === ARCHIVO: app/package.json ===
{
  "name": "orders-api",
  "version": "1.0.0",
  "description": "API REST para gestionar órdenes en DynamoDB",
  "main": "src/main.ts",
  "scripts": {
    "build": "tsc",
    "start": "ts-node src/main.ts",
    "dev": "ts-node src/main.ts",
    "test": "jest",
    "lint": "eslint . --ext .ts"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "@aws-sdk/client-dynamodb": "^3.637.0",
    "@aws-sdk/lib-dynamodb": "^3.637.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.1",
    "dotenv": "^16.4.5",
    "express": "^4.21.0",
    "swagger-ui-express": "^5.0.1",
    "uuid": "^9.0.1"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/jest": "^29.5.12",
    "@types/node": "^22.7.4",
    "@types/swagger-ui-express": "^4.1.6",
    "@types/uuid": "^9.0.8",
    "@typescript-eslint/eslint-plugin": "^7.18.0",
    "@typescript-eslint/parser": "^7.18.0",
    "eslint": "^8.57.0",
    "jest": "^29.7.0",
    "supertest": "^6.3.4",
    "ts-node": "^10.9.2",
    "typescript": "^5.7.2"
  }
}

// === ARCHIVO: app/tsconfig.json ===
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "noImplicitAny": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "**/*.test.ts"]
}

// === ARCHIVO: app/src/domain/order.ts ===
export class Order {
  id: string;
  clientId: string;
  productId: string;
  quantity: number;
  orderDate: Date;
  status: string;

  constructor(
    id: string,
    clientId: string,
    productId: string,
    quantity: number,
    orderDate: Date,
    status: string = 'PENDING'
  ) {
    this.id = id;
    this.clientId = clientId;
    this.productId = productId;
    this.quantity = quantity;
    this.orderDate = orderDate;
    this.status = status;
  }
}

export interface OrderCreateDTO {
  clientId: string;
  productId: string;
  quantity: number;
}

export interface OrderUpdateDTO {
  productId?: string;
  quantity?: number;
  status?: string;
}

export class OrderDTO {
  id: string;
  clientId: string;
  productId: string;
  quantity: number;
  orderDate: Date;
  status: string;

  constructor(
    id: string,
    clientId: string,
    productId: string,
    quantity: number,
    orderDate: Date,
    status: string
  ) {
    this.id = id;
    this.clientId = clientId;
    this.productId = productId;
    this.quantity = quantity;
    this.orderDate = orderDate;
    this.status = status;
  }

  static fromOrder(order: Order): OrderDTO {
    return new OrderDTO(
      order.id,
      order.clientId,
      order.productId,
      order.quantity,
      order.orderDate,
      order.status
    );
  }

  static fromObject(obj: {
    id: string;
    clientId: string;
    productId: string;
    quantity: number;
    orderDate: Date | string;
    status: string;
  }): OrderDTO {
    const orderDate = obj.orderDate instanceof Date ? obj.orderDate : new Date(obj.orderDate);
    return new OrderDTO(
      obj.id,
      obj.clientId,
      obj.productId,
      obj.quantity,
      orderDate,
      obj.status
    );
  }

  toPlainObject(): Record<string, unknown> {
    return {
      id: this.id,
      clientId: this.clientId,
      productId: this.productId,
      quantity: this.quantity,
      orderDate: this.orderDate.toISOString(),
      status: this.status
    };
  }
}

// === ARCHIVO: app/src/domain/repositories/order.repository.ts ===
import { OrderCreateDTO, OrderUpdateDTO, OrderDTO } from '../order';

export interface OrderRepository {
    create(order: OrderCreateDTO): Promise<OrderDTO>;
    findById(id: string): Promise<OrderDTO | null>;
    update(id: string, order: OrderUpdateDTO): Promise<OrderDTO | null>;
    delete(id: string): Promise<void>;
    list(): Promise<OrderDTO[]>;
}

// === ARCHIVO: app/src/infrastructure/repositories/dynamodb.order.repository.ts ===
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand, DeleteCommand, ScanCommand } from '@aws-sdk/lib-dynamodb';
import { OrderRepository } from '../../domain/repositories/order.repository';
import { Order, OrderCreateDTO, OrderUpdateDTO, OrderDTO } from '../../domain/order';
import { v4 as uuidv4 } from 'uuid';

export class DynamoDBOrderRepository implements OrderRepository {
    private client: DynamoDBDocumentClient;
    private tableName: string;

    constructor(client: DynamoDBClient, tableName: string) {
        this.client = DynamoDBDocumentClient.from(client);
        this.tableName = tableName;
    }

    async create(orderCreateDTO: OrderCreateDTO): Promise<OrderDTO> {
        const orderId = uuidv4();
        const orderDate = new Date();
        const order = new Order(
            orderId,
            orderCreateDTO.clientId,
            orderCreateDTO.productId,
            orderCreateDTO.quantity,
            orderDate
        );

        const params = {
            TableName: this.tableName,
            Item: {
                id: order.id,
                clientId: order.clientId,
                productId: order.productId,
                quantity: order.quantity,
                orderDate: orderDate.toISOString(),
                status: order.status
            }
        };

        await this.client.send(new PutCommand(params));
        return this.toOrderDTO(order);
    }

    async findById(id: string): Promise<OrderDTO | null> {
        const params = {
            TableName: this.tableName,
            Key: { id }
        };

        const result = await this.client.send(new GetCommand(params));
        if (!result.Item) {
            return null;
        }

        return this.toOrderDTOFromItem(result.Item);
    }

    async update(id: string, orderUpdateDTO: OrderUpdateDTO): Promise<OrderDTO | null> {
        const updateExpressions: string[] = [];
        const expressionAttributeValues: Record<string, unknown> = {};
        const expressionAttributeNames: Record<string, string> = {};

        if (orderUpdateDTO.productId !== undefined) {
            updateExpressions.push('#productId = :productId');
            expressionAttributeNames['#productId'] = 'productId';
            expressionAttributeValues[':productId'] = orderUpdateDTO.productId;
        }

        if (orderUpdateDTO.quantity !== undefined) {
            updateExpressions.push('quantity = :quantity');
            expressionAttributeValues[':quantity'] = orderUpdateDTO.quantity;
        }

        if (orderUpdateDTO.status !== undefined) {
            updateExpressions.push('status = :status');
            expressionAttributeValues[':status'] = orderUpdateDTO.status;
        }

        if (updateExpressions.length === 0) {
            const existingOrder = await this.findById(id);
            if (!existingOrder) {
                return null;
            }
            return existingOrder;
        }

        const params = {
            TableName: this.tableName,
            Key: { id },
            UpdateExpression: `SET ${updateExpressions.join(', ')}`,
            ExpressionAttributeValues: expressionAttributeValues,
            ExpressionAttributeNames: expressionAttributeNames,
            ReturnValues: 'ALL_NEW' as const
        };

        const result = await this.client.send(new UpdateCommand(params));
        if (!result.Attributes) {
            return null;
        }

        return this.toOrderDTOFromItem(result.Attributes);
    }

    async delete(id: string): Promise<void> {
        const params = {
            TableName: this.tableName,
            Key: { id }
        };

        await this.client.send(new DeleteCommand(params));
    }

    async list(): Promise<OrderDTO[]> {
        const params = {
            TableName: this.tableName
        };

        const result = await this.client.send(new ScanCommand(params));
        if (!result.Items) {
            return [];
        }

        return result.Items.map(item => this.toOrderDTOFromItem(item));
    }

    private toOrderDTO(order: Order): OrderDTO {
        return new OrderDTO(
            order.id,
            order.clientId,
            order.productId,
            order.quantity,
            order.orderDate,
            order.status
        );
    }

    private toOrderDTOFromItem(item: Record<string, unknown>): OrderDTO {
        return new OrderDTO(
            item.id as string,
            item.clientId as string,
            item.productId as string,
            item.quantity as number,
            new Date(item.orderDate as string),
            item.status as string
        );
    }
}

// === ARCHIVO: app/src/application/services/order.service.ts ===
import { OrderCreateDTO, OrderDTO, OrderUpdateDTO } from '../../domain/order';
import { OrderRepository } from '../../domain/repositories/order.repository';

export class OrderService {
  constructor(private readonly orderRepository: OrderRepository) {}

  async create(createDTO: OrderCreateDTO): Promise<OrderDTO> {
    this.validateCreateDTO(createDTO);
    const order = await this.orderRepository.create(createDTO);
    return order;
  }

  async findById(id: string): Promise<OrderDTO | null> {
    if (!id || id.trim() === '') {
      throw new Error('El ID de la orden es requerido');
    }
    return this.orderRepository.findById(id);
  }

  async update(id: string, updateDTO: OrderUpdateDTO): Promise<OrderDTO | null> {
    if (!id || id.trim() === '') {
      throw new Error('El ID de la orden es requerido');
    }
    this.validateUpdateDTO(updateDTO);
    const existingOrder = await this.orderRepository.findById(id);
    if (!existingOrder) {
      return null;
    }
    if (existingOrder.status === 'COMPLETED' || existingOrder.status === 'CANCELLED') {
      throw new Error(`No se puede modificar una orden en estado ${existingOrder.status}`);
    }
    return this.orderRepository.update(id, updateDTO);
  }

  async delete(id: string): Promise<void> {
    if (!id || id.trim() === '') {
      throw new Error('El ID de la orden es requerido');
    }
    const existingOrder = await this.orderRepository.findById(id);
    if (!existingOrder) {
      throw new Error('Orden no encontrada');
    }
    if (existingOrder.status === 'COMPLETED') {
      throw new Error('No se puede eliminar una orden completada');
    }
    return this.orderRepository.delete(id);
  }

  async list(): Promise<OrderDTO[]> {
    return this.orderRepository.list();
  }

  async listByStatus(status: string): Promise<OrderDTO[]> {
    const allOrders = await this.orderRepository.list();
    return allOrders.filter(order => order.status === status);
  }

  async listByClient(clientId: string): Promise<OrderDTO[]> {
    if (!clientId || clientId.trim() === '') {
      throw new Error('El ID del cliente es requerido');
    }
    const allOrders = await this.orderRepository.list();
    return allOrders.filter(order => order.clientId === clientId);
  }

  async listByProduct(productId: string): Promise<OrderDTO[]> {
    if (!productId || productId.trim() === '') {
      throw new Error('El ID del producto es requerido');
    }
    const allOrders = await this.orderRepository.list();
    return allOrders.filter(order => order.productId === productId);
  }

  private validateCreateDTO(dto: OrderCreateDTO): void {
    if (!dto.clientId || dto.clientId.trim() === '') {
      throw new Error('El ID del cliente es requerido');
    }
    if (!dto.productId || dto.productId.trim() === '') {
      throw new Error('El ID del producto es requerido');
    }
    if (!dto.quantity || dto.quantity <= 0) {
      throw new Error('La cantidad debe ser mayor a cero');
    }
    if (dto.quantity > 10000) {
      throw new Error('La cantidad no puede exceder 10000 unidades');
    }
  }

  private validateUpdateDTO(dto: OrderUpdateDTO): void {
    if (dto.quantity !== undefined) {
      if (dto.quantity <= 0) {
        throw new Error('La cantidad debe ser mayor a cero');
      }
      if (dto.quantity > 10000) {
        throw new Error('La cantidad no puede exceder 10000 unidades');
      }
    }
    if (dto.status !== undefined) {
      const validStatuses = ['PENDING', 'PROCESSING', 'COMPLETED', 'CANCELLED'];
      if (!validStatuses.includes(dto.status)) {
        throw new Error(`Estado inválido. Estados válidos: ${validStatuses.join(', ')}`);
      }
    }
  }
}

// === ARCHIVO: app/src/infrastructure/controllers/order.controller.ts ===
import { Router, Request, Response, NextFunction } from 'express';
import { OrderService } from '../../application/services/order.service';
import { OrderCreateDTO, OrderUpdateDTO } from '../../domain/order';
import { validate } from 'class-validator';
import { plainToInstance } from 'class-transformer';

export class OrderController {
  private router: Router;

  constructor(private readonly orderService: OrderService) {
    this.router = Router();
    this.setupRoutes();
  }

  private setupRoutes(): void {
    this.router.post('/', this.createOrder.bind(this));
    this.router.get('/:id', this.getOrder.bind(this));
    this.router.put('/:id', this.updateOrder.bind(this));
    this.router.delete('/:id', this.deleteOrder.bind(this));
    this.router.get('/', this.listOrders.bind(this));
  }

  getRouter(): Router {
    return this.router;
  }

  async createOrder(req: Request, res: Response): Promise<void> {
    try {
      const createDTO = plainToInstance(OrderCreateDTO, req.body);
      const errors = await validate(createDTO);
      if (errors.length > 0) {
        res.status(400).json({
          message: 'Error de validación',
          errors: errors.map(err => ({
            property: err.property,
            constraints: err.constraints
          }))
        });
        return;
      }
      const order = await this.orderService.create(createDTO);
      res.status(201).json(order);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async getOrder(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const order = await this.orderService.findById(id);
      if (!order) {
        res.status(404).json({ message: 'Orden no encontrada' });
        return;
      }
      res.json(order);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async updateOrder(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const updateDTO = plainToInstance(OrderUpdateDTO, req.body);
      const errors = await validate(updateDTO);
      if (errors.length > 0) {
        res.status(400).json({
          message: 'Error de validación',
          errors: errors.map(err => ({
            property: err.property,
            constraints: err.constraints
          }))
        });
        return;
      }
      const order = await this.orderService.update(id, updateDTO);
      if (!order) {
        res.status(404).json({ message: 'Orden no encontrada' });
        return;
      }
      res.json(order);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async deleteOrder(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      await this.orderService.delete(id);
      res.status(204).send();
    } catch (error) {
      this.handleError(error, res);
    }
  }

  async listOrders(req: Request, res: Response): Promise<void> {
    try {
      const { status, clientId, productId } = req.query;
      let orders;
      if (status && typeof status === 'string') {
        orders = await this.orderService.listByStatus(status);
      } else if (clientId && typeof clientId === 'string') {
        orders = await this.orderService.listByClient(clientId);
      } else if (productId && typeof productId === 'string') {
        orders = await this.orderService.listByProduct(productId);
      } else {
        orders = await this.orderService.list();
      }
      res.json(orders);
    } catch (error) {
      this.handleError(error, res);
    }
  }

  private handleError(error: unknown, res: Response): void {
    if (error instanceof Error) {
      const message = error.message;
      if (message.includes('requerida') || message.includes('inválido') || message.includes('validación')) {
        res.status(400).json({ message });
      } else if (message.includes('no encontrada')) {
        res.status(404).json({ message });
      } else if (message.includes('No se puede')) {
        res.status(409).json({ message });
      } else {
        res.status(500).json({ message: 'Error interno del servidor' });
      }
    } else {
      res.status(500).json({ message: 'Error interno del servidor' });
    }
  }
}

// === ARCHIVO: app/src/config/aws.config.ts ===
import { DynamoDBClient, DynamoDBClientConfig } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient } from '@aws-sdk/lib-dynamodb';
import * as dotenv from 'dotenv';

dotenv.config();

export interface AWSConfig {
  region: string;
  endpoint?: string;
  credentials: {
    accessKeyId: string;
    secretAccessKey: string;
  };
}

export function getAWSConfig(): AWSConfig {
  const config: AWSConfig = {
    region: process.env.AWS_REGION || 'us-east-1',
    credentials: {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID || '',
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || ''
    }
  };
  if (process.env.AWS_ENDPOINT) {
    config.endpoint = process.env.AWS_ENDPOINT;
  }
  return config;
}

export function createDynamoDBClient(): DynamoDBClient {
  const config: AWSConfig = getAWSConfig();
  const clientConfig: DynamoDBClientConfig = {
    region: config.region,
    credentials: config.credentials
  };
  if (config.endpoint) {
    clientConfig.endpoint = config.endpoint;
  }
  return new DynamoDBClient(clientConfig);
}

export function createDocumentClient(dynamoDBClient: DynamoDBClient): DynamoDBDocumentClient {
  return DynamoDBDocumentClient.from(dynamoDBClient, {
    marshallOptions: {
      removeUndefinedValues: true,
      convertClassInstanceToMap: true,
      convertTopLevelContainer: true
    },
    unmarshallOptions: {
      wrapNumbers: false
    }
  });
}

export function getDynamoDBDocumentClient(): DynamoDBDocumentClient {
  const dynamoDBClient = createDynamoDBClient();
  return createDocumentClient(dynamoDBClient);
}

export function getTableName(): string {
  return process.env.DYNAMODB_TABLE_NAME || 'orders';
}

export function getDynamoDBConfig(): { tableName: string; client: DynamoDBDocumentClient } {
  const dynamoDBClient = createDynamoDBClient();
  const documentClient = createDocumentClient(dynamoDBClient);
  const tableName = getTableName();
  return { tableName, client: documentClient };
}

// === ARCHIVO: app/src/middleware/error.middleware.ts ===
import { Request, Response, NextFunction, RequestHandler } from 'express';

export class AppError extends Error {
  public readonly statusCode: number;
  public readonly isOperational: boolean;
  public readonly errorCode?: string;

  constructor(message: string, statusCode: number = 500, errorCode?: string) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;
    this.errorCode = errorCode;
    Error.captureStackTrace(this, this.constructor);
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string = 'Resource') {
    super(`${resource} not found`, 404, 'NOT_FOUND');
  }
}

export class ValidationAppError extends AppError {
  public readonly errors: ValidationErrorDetail[];

  constructor(message: string, errors: ValidationErrorDetail[] = []) {
    super(message, 400, 'VALIDATION_ERROR');
    this.errors = errors;
  }
}

export interface ValidationErrorDetail {
  field: string;
  message: string;
  code?: string;
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(message, 409, 'CONFLICT');
  }
}

export class UnauthorizedError extends AppError {
  constructor(message: string = 'Unauthorized') {
    super(message, 401, 'UNAUTHORIZED');
  }
}

export class ForbiddenError extends AppError {
  constructor(message: string = 'Forbidden') {
    super(message, 403, 'FORBIDDEN');
  }
}

export interface ErrorResponse {
  success: boolean;
  message: string;
  errorCode?: string;
  errors?: ValidationErrorDetail[];
  timestamp: string;
  path?: string;
}

const isOperationalError = (error: Error): error is AppError => {
  return error instanceof AppError;
};

const formatErrorResponse = (
  error: Error,
  request: Request,
  errorCode?: string
): ErrorResponse => {
  const response: ErrorResponse = {
    success: false,
    message: error.message,
    timestamp: new Date().toISOString(),
    path: request.path,
  };

  if (errorCode) {
    response.errorCode = errorCode;
  }

  if (error instanceof ValidationAppError) {
    response.errors = error.errors;
  }

  return response;
};

export const errorHandler: RequestHandler = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction
): void => {
  if (process.env.NODE_ENV === 'development') {
    console.error(`[ERROR] ${err.message}`);
    console.error(err.stack);
  }

  if (isOperationalError(err)) {
    const response = formatErrorResponse(
      err,
      _req,
      err.errorCode
    );
    res.status(err.statusCode).json(response);
    return;
  }

  const unexpectedError = new AppError('Internal server error', 500, 'INTERNAL_ERROR');
  const response = formatErrorResponse(
    unexpectedError,
    _req,
    'INTERNAL_ERROR'
  );
  res.status(500).json(response);
};

export const notFoundHandler: RequestHandler = (_req, res, _next): void => {
  const error = new AppError('Route not found', 404, 'ROUTE_NOT_FOUND');
  const response = formatErrorResponse(error, _req, 'ROUTE_NOT_FOUND');
  res.status(404).json(response);
};

export const asyncHandler = (
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>
): RequestHandler => {
  return (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

export const errorMiddleware: RequestHandler[] = [
  notFoundHandler,
  errorHandler,
];

export const createErrorResponse = (
  message: string,
  errorCode?: string,
  errors?: ValidationErrorDetail[]
): ErrorResponse => {
  const response: ErrorResponse = {
    success: false,
    message,
    timestamp: new Date().toISOString(),
  };

  if (errorCode) {
    response.errorCode = errorCode;
  }

  if (errors) {
    response.errors = errors;
  }

  return response;
};

// === ARCHIVO: app/src/middleware/validation.middleware.ts ===
import { Request, Response, NextFunction, RequestHandler } from 'express';
import { validate, ValidationError as ClassValidationError } from 'class-validator';
import { plainToInstance, ClassConstructor } from 'class-transformer';
import { ValidationAppError, ValidationErrorDetail } from './error.middleware';

export interface ValidationOptions {
  whitelist?: boolean;
  forbidNonWhitelisted?: boolean;
  transform?: boolean;
  skipMissingProperties?: boolean;
}

const defaultValidationOptions: ValidationOptions = {
  whitelist: true,
  forbidNonWhitelisted: true,
  transform: true,
  skipMissingProperties: false,
};

const parseValidationErrors = (
  errors: ClassValidationError[]
): ValidationErrorDetail[] => {
  const validationErrors: ValidationErrorDetail[] = [];

  for (const error of errors) {
    if (error.constraints) {
      const field = error.property;
      const messages = Object.values(error.constraints);

      for (const message of messages) {
        validationErrors.push({
          field,
          message,
          code: getErrorCode(error),
        });
      }
    }

    if (error.children && error.children.length > 0) {
      const childErrors = parseValidationErrors(error.children);
      validationErrors.push(...childErrors);
    }
  }

  return validationErrors;
};

const getErrorCode = (error: ClassValidationError): string => {
  if (error.constraints) {
    const constraintKeys = Object.keys(error.constraints);
    if (constraintKeys.length > 0) {
      return constraintKeys[0].toUpperCase();
    }
  }
  return 'INVALID_VALUE';
};

export const validateBody = <T extends object>(
  dtoClass: ClassConstructor<T>,
  options: ValidationOptions = defaultValidationOptions
): RequestHandler => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    try {
      const transformOptions = {
        exposeUnsetFields: options.transform ?? true,
        excludeExtraneousValues: options.whitelist ?? true,
      };

      const dtoInstance = plainToInstance(dtoClass, req.body, transformOptions);

      const validationErrors = await validate(dtoInstance, {
        whitelist: options.whitelist ?? true,
        forbidNonWhitelisted: options.forbidNonWhitelisted ?? true,
        skipMissingProperties: options.skipMissingProperties ?? false,
      });

      if (validationErrors.length > 0) {
        const errors = parseValidationErrors(validationErrors);
        const message = errors.length === 1
          ? `Validation failed: ${errors[0].message}`
          : 'Validation failed';

        next(new ValidationAppError(message, errors));
        return;
      }

      req.body = dtoInstance;
      next();
    } catch (error) {
      next(error);
    }
  };
};

export const validateParams = <T extends object>(
  dtoClass: ClassConstructor<T>,
  options: ValidationOptions = defaultValidationOptions
): RequestHandler => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    try {
      const transformOptions = {
        exposeUnsetFields: options.transform ?? true,
        excludeExtraneousValues: options.whitelist ?? true,
      };

      const dtoInstance = plainToInstance(dtoClass, req.params, transformOptions);

      const validationErrors = await validate(dtoInstance, {
        whitelist: options.whitelist ?? true,
        forbidNonWhitelisted: options.forbidNonWhitelisted ?? true,
        skipMissingProperties: options.skipMissingProperties ?? false,
      });

      if (validationErrors.length > 0) {
        const errors = parseValidationErrors(validationErrors);
        const message = errors.length === 1
          ? `Validation failed: ${errors[0].message}`
          : 'Validation failed';

        next(new ValidationAppError(message, errors));
        return;
      }

      req.params = dtoInstance as any;
      next();
    } catch (error) {
      next(error);
    }
  };
};

export const validateQuery = <T extends object>(
  dtoClass: ClassConstructor<T>,
  options: ValidationOptions = { ...defaultValidationOptions, skipMissingProperties: true }
): RequestHandler => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    try {
      const transformOptions = {
        exposeUnsetFields: options.transform ?? true,
        excludeExtraneousValues: options.whitelist ?? true,
      };

      const dtoInstance = plainToInstance(dtoClass, req.query, transformOptions);

      const validationErrors = await validate(dtoInstance, {
        whitelist: options.whitelist ?? true,
        forbidNonWhitelisted: options.forbidNonWhitelisted ?? true,
        skipMissingProperties: options.skipMissingProperties ?? true,
      });

      if (validationErrors.length > 0) {
        const errors = parseValidationErrors(validationErrors);
        const message = errors.length === 1
          ? `Validation failed: ${errors[0].message}`
          : 'Validation failed';

        next(new ValidationAppError(message, errors));
        return;
      }

      req.query = dtoInstance as any;
      next();
    } catch (error) {
      next(error);
    }
  };
};

export const createValidationMiddleware = <T extends object>(
  dtoClass: ClassConstructor<T>,
  target: 'body' | 'params' | 'query' = 'body',
  options: ValidationOptions = defaultValidationOptions
): RequestHandler => {
  switch (target) {
    case 'body':
      return validateBody(dtoClass, options);
    case 'params':
      return validateParams(dtoClass, options);
    case 'query':
      return validateQuery(dtoClass, options);
    default:
      return validateBody(dtoClass, options);
  }
};

// === ARCHIVO: app/swagger.json ===
{
  "openapi": "3.0.3",
  "info": {
    "title": "Orders API",
    "description": "API REST para gestionar órdenes en DynamoDB",
    "version": "1.0.0",
    "contact": {
      "name": "API Support",
      "email": "support@example.com"
    },
    "license": {
      "name": "ISC",
      "url": "https://opensource.org/licenses/ISC"
    }
  },
  "servers": [
    {
      "url": "http://localhost:3000",
      "description": "Development server"
    }
  ],
  "tags": [
    {
      "name": "orders",
      "description": "Operaciones CRUD para la gestión de órdenes"
    }
  ],
  "paths": {
    "/orders": {
      "get": {
        "tags": ["orders"],
        "summary": "Listar todas las órdenes",
        "description": "Retorna una lista de todas las órdenes existentes en el sistema",
        "operationId": "listOrders",
        "responses": {
          "200": {
            "description": "Lista de órdenes obtenida exitosamente",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/OrderDTO"
                  }
                }
              }
            }
          },
          "500": {
            "description": "Error interno del servidor",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          }
        }
      },
      "post": {
        "tags": ["orders"],
        "summary": "Crear una nueva orden",
        "description": "Crea una nueva orden en el sistema con los datos proporcionados",
        "operationId": "createOrder",
        "requestBody": {
          "description": "Datos de la orden a crear",
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/OrderCreateDTO"
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Orden creada exitosamente",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/OrderDTO"
                }
              }
            }
          },
          "400": {
            "description": "Error de validación en los datos de la orden",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ValidationErrorResponse"
                }
              }
            }
          },
          "500": {
            "description": "Error interno del servidor",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          }
        }
      }
    },
    "/orders/{id}": {
      "get": {
        "tags": ["orders"],
        "summary": "Obtener una orden por ID",
        "description": "Retorna los detalles de una orden específica identificada por su ID",
        "operationId": "getOrder",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "ID único de la orden",
            "required": true,
            "schema": {
              "type": "string",
              "format": "uuid"
            },
            "example": "550e8400-e29b-41d4-a716-446655440000"
          }
        ],
        "responses": {
          "200": {
            "description": "Orden encontrada exitosamente",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/OrderDTO"
                }
              }
            }
          },
          "404": {
            "description": "Orden no encontrada",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          },
          "500": {
            "description": "Error interno del servidor",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          }
        }
      },
      "put": {
        "tags": ["orders"],
        "summary": "Actualizar una orden existente",
        "description": "Actualiza los datos de una orden existente identificada por su ID",
        "operationId": "updateOrder",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "ID único de la orden",
            "required": true,
            "schema": {
              "type": "string",
              "format": "uuid"
            },
            "example": "550e8400-e29b-41d4-a716-446655440000"
          }
        ],
        "requestBody": {
          "description": "Datos a actualizar de la orden",
          "required": true,
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/OrderUpdateDTO"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "Orden actualizada exitosamente",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/OrderDTO"
                }
              }
            }
          },
          "400": {
            "description": "Error de validación en los datos de actualización",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ValidationErrorResponse"
                }
              }
            }
          },
          "404": {
            "description": "Orden no encontrada",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          },
          "500": {
            "description": "Error interno del servidor",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          }
        }
      },
      "delete": {
        "tags": ["orders"],
        "summary": "Eliminar una orden",
        "description": "Elimina una orden existente identificada por su ID",
        "operationId": "deleteOrder",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "ID único de la orden",
            "required": true,
            "schema": {
              "type": "string",
              "format": "uuid"
            },
            "example": "550e8400-e29b-41d4-a716-446655440000"
          }
        ],
        "responses": {
          "204": {
            "description": "Orden eliminada exitosamente"
          },
          "404": {
            "description": "Orden no encontrada",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          },
          "500": {
            "description": "Error interno del servidor",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/ErrorResponse"
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "OrderDTO": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "format": "uuid",
            "description": "Identificador único de la orden"
          },
          "clientId": {
            "type": "string",
            "description": "Identificador del cliente que realiza la orden"
          },
          "productId": {
            "type": "string",
            "description": "Identificador del producto ordenado"
          },
          "quantity": {
            "type": "integer",
            "minimum": 1,
            "description": "Cantidad de productos ordenados"
          },
          "orderDate": {
            "type": "string",
            "format": "date-time",
            "description": "Fecha y hora de la orden"
          },
          "status": {
            "type": "string",
            "enum": ["PENDING", "CONFIRMED", "CANCELLED", "COMPLETED"],
            "description": "Estado actual de la orden",
            "default": "PENDING"
          }
        },
        "required": ["id", "clientId", "productId", "quantity", "orderDate", "status"]
      },
      "OrderCreateDTO": {
        "type": "object",
        "properties": {
          "clientId": {
            "type": "string",
            "description": "Identificador del cliente que realiza la orden"
          },
          "productId": {
            "type": "string",
            "description": "Identificador del producto ordenado"
          },
          "quantity": {
            "type": "integer",
            "minimum": 1,
            "description": "Cantidad de productos ordenados"
          }
        },
        "required": ["clientId", "productId", "quantity"]
      },
      "OrderUpdateDTO": {
        "type": "object",
        "properties": {
          "productId": {
            "type": "string",
            "description": "Identificador del producto ordenado"
          },
          "quantity": {
            "type": "integer",
            "minimum": 1,
            "description": "Cantidad de productos ordenados"
          },
          "status": {
            "type": "string",
            "enum": ["PENDING", "CONFIRMED", "CANCELLED", "COMPLETED"],
            "description": "Estado actual de la orden"
          }
        }
      },
      "ErrorResponse": {
        "type": "object",
        "properties": {
          "success": {
            "type": "boolean",
            "example": false
          },
          "message": {
            "type": "string",
            "description": "Mensaje descriptivo del error"
          },
          "errorCode": {
            "type": "string",
            "description": "Código de error específico de la aplicación"
          },
          "timestamp": {
            "type": "string",
            "format": "date-time",
            "description": "Marca de tiempo del error"
          },
          "path": {
            "type": "string",
            "description": "Ruta de la solicitud que causó el error"
          }
        },
        "required": ["success", "message", "timestamp"]
      },
      "ValidationErrorResponse": {
        "type": "object",
        "properties": {
          "success": {
            "type": "boolean",
            "example": false
          },
          "message": {
            "type": "string",
            "description": "Mensaje descriptivo del error de validación"
          },
          "errorCode": {
            "type": "string",
            "example": "VALIDATION_ERROR"
          },
          "errors": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "field": {
                  "type": "string",
                  "description": "Nombre del campo que falló la validación"
                },
                "message": {
                  "type": "string",
                  "description": "Mensaje descriptivo del error de validación"
                },
                "code": {
                  "type": "string",
                  "description": "Código de error de validación"
                }
              },
              "required": ["field", "message"]
            },
            "description": "Lista de errores de validación individuales"
          },
          "timestamp": {
            "type": "string",
            "format": "date-time",
            "description": "Marca de tiempo del error"
          }
        },
        "required": ["success", "message", "timestamp"]
      }
    },
    "securitySchemes": {
      "bearerAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT"
      }
    }
  },
  "security": [
    {
      "bearerAuth": []
    }
  ]
}

// === ARCHIVO: app/src/main.ts ===
import dotenv from 'dotenv';
import { app } from './app';

dotenv.config();

const PORT = process.env.PORT || 3000;

const startServer = async (): Promise<void> => {
  try {
    app.listen(PORT, () => {
      console.log(`Servidor ejecutándose en el puerto ${PORT}`);
      console.log(`Ambiente: ${process.env.NODE_ENV || 'development'}`);
      console.log(`Endpoint base: http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('Error al iniciar el servidor:', error);
    process.exit(1);
  }
};

startServer();

// === ARCHIVO: app/src/app.ts ===
import express, { Application, Request, Response, NextFunction, Router } from 'express';
import { getDynamoDBDocumentClient, getTableName } from './config/aws.config';
import { OrderRepository } from './domain/repositories/order.repository';
import { DynamoDBOrderRepository } from './infrastructure/repositories/dynamodb.order.repository';
import { OrderService } from './application/services/order.service';
import { OrderController } from './infrastructure/controllers/order.controller';
import { errorMiddleware } from './middleware/error.middleware';
import swaggerUi from 'swagger-ui-express';
import * as swaggerDocument from '../swagger.json';

export const app: Application = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const documentClient = getDynamoDBDocumentClient();
const tableName = getTableName();

const orderRepository: OrderRepository = new DynamoDBOrderRepository(
  documentClient,
  tableName
);

const orderService: OrderService = new OrderService(orderRepository);

const orderController: OrderController = new OrderController(orderService);

app.get('/health', (_req: Request, res: Response) => {
  res.status(200).json({
    success: true,
    message: 'API de Órdenes funcionando correctamente',
    timestamp: new Date().toISOString()
  });
});

app.use('/orders', orderController.getRouter());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.use((_req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    message: 'Ruta no encontrada',
    timestamp: new Date().toISOString(),
    path: _req.path
  });
});

app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  errorMiddleware(err, _req, res, _next);
});

// === ARCHIVO: infra/providers.tf ===
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

// === ARCHIVO: infra/variables.tf ===
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

// === ARCHIVO: infra/modules/dynamodb/variables.tf ===
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

// === ARCHIVO: infra/environments/dev/terraform.tfvars ===
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

// === ARCHIVO: infra/README.md ===
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

// === ARCHIVO: infra/modules/dynamodb/main.tf ===
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

// === ARCHIVO: infra/modules/dynamodb/outputs.tf ===
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

// === ARCHIVO: infra/versions.tf ===
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

// === ARCHIVO: infra/main.tf ===
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

// === ARCHIVO: infra/outputs.tf ===
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

// === ARCHIVO: docker-compose.yml ===
# Infraestructura local del reto. SOLO desarrollo: credenciales de ejemplo (local-dev-only), puertos en loopback.
# Levantar: docker compose up -d --wait
name: infra-local
services:
  dynamodb-local:
    image: "amazon/dynamodb-local:2.5.2"
    command: ["-jar","DynamoDBLocal.jar","-sharedDb","-inMemory"]
    ports:
      - "127.0.0.1:8000:8000"
    healthcheck:
      test: ["CMD-SHELL","bash -c ':> /dev/tcp/127.0.0.1/8000' || exit 1"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 5s


// === ARCHIVO: infra-local/README.md ===
# Infraestructura local

Servicios de soporte para el reto, definidos en `docker-compose.yml` (raiz del repo).

```bash
docker compose up -d --wait
```

| Servicio | Imagen | Puertos (host) |
|---|---|---|
| DynamoDB Local | `amazon/dynamodb-local:2.5.2` | 8000 |

Credenciales: solo de desarrollo local (`local-dev-only`, `local`). No son secretos ni deben reutilizarse.
Los scripts de `infra-local/` (tablas, topics) se ejecutan con el compose en estado healthy.


// === ARCHIVO: infra-local/dynamodb/create-tables.sh ===
#!/usr/bin/env bash
# Crea las tablas en DynamoDB Local (idempotente). Credenciales dummy: DynamoDB Local no valida firmas.
set -euo pipefail

export AWS_ACCESS_KEY_ID=local
export AWS_SECRET_ACCESS_KEY=local
export AWS_REGION=us-east-1
ENDPOINT="${DYNAMODB_ENDPOINT:-http://localhost:8000}"

create_table() {
  local name="$1" pk="$2" sk="${3:-}"
  if aws dynamodb describe-table --table-name "$name" --endpoint-url "$ENDPOINT" >/dev/null 2>&1; then
    echo "Tabla $name ya existe"
    return
  fi
  local attrs="AttributeName=$pk,AttributeType=S"
  local keys="AttributeName=$pk,KeyType=HASH"
  if [ -n "$sk" ]; then
    attrs="$attrs AttributeName=$sk,AttributeType=S"
    keys="$keys AttributeName=$sk,KeyType=RANGE"
  fi
  # shellcheck disable=SC2086
  aws dynamodb create-table --table-name "$name" --attribute-definitions $attrs --key-schema $keys \
    --billing-mode PAY_PER_REQUEST --endpoint-url "$ENDPOINT" >/dev/null
  echo "Tabla $name creada"
}

create_table "app-items" "id"

```
