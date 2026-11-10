# Implementación de operaciones CRUD para órdenes en DynamoDB

El sistema debe permitir la creación, lectura, actualización y eliminación de órdenes en una tabla de DynamoDB, expuestas a través de una API REST. Las órdenes tienen atributos como ID, cliente, producto, cantidad y fecha. El sistema debe manejar errores como órdenes no encontradas y validaciones como productos inexistentes.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | CRUD de ordenes sobre DynamoDB |
| **Nivel** | advanced-l2 |
| **Tipo** | practical |
| **Tiempo estimado** | 8 horas |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y entregará cada archivo con su ruta.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Node.js 18+, npm, VS Code o similar.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y entregará cada archivo con su ruta. Guárdalos en la carpeta donde quieras trabajar, respetando las rutas.
- Ejecuta `npm install && npm run build` (o `npm start`). Si no hay errores, estás listo.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no entrega todos los archivos al terminar el análisis, escríbele: "entrégame todos los archivos con su ruta".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Creación de la tabla DynamoDB y API REST

**Objetivo:** Configurar la tabla DynamoDB y exponer las operaciones CRUD a través de una API REST.

**Tiempo estimado:** 3 horas

**Instrucciones:**

- Diseña la estructura de la tabla DynamoDB para almacenar órdenes.
- Implementa las operaciones CRUD en la API REST.
- Verifica que las operaciones CRUD funcionen correctamente.

**Entregable:** Tabla DynamoDB configurada y API REST que expone operaciones CRUD.

<details>
<summary>Pistas de conocimiento</summary>

- Considera las mejores prácticas para el diseño de tablas en DynamoDB.
- Utiliza Terraform para gestionar la infraestructura.

</details>

### Fase 2: Manejo de errores y validaciones

**Objetivo:** Implementar el manejo de errores y validaciones en las operaciones CRUD.

**Tiempo estimado:** 3 horas

**Instrucciones:**

- Agrega manejo de errores para casos como órdenes no encontradas.
- Implementa validaciones para atributos como productos inexistentes.
- Verifica que el sistema maneje correctamente los errores y validaciones.

**Entregable:** API REST con manejo de errores y validaciones para las operaciones CRUD.

<details>
<summary>Pistas de conocimiento</summary>

- Considera los diferentes tipos de errores que pueden ocurrir y cómo manejarlos.
- Utiliza Terraform para gestionar la infraestructura.

</details>

### Fase 3: Optimización y refactorización

**Objetivo:** Optimizar y refactorizar el código para mejorar la eficiencia y mantenibilidad.

**Tiempo estimado:** 2 horas

**Instrucciones:**

- Identifica áreas de mejora en el código.
- Refactoriza el código para mejorar la eficiencia y mantenibilidad.
- Verifica que las operaciones CRUD sigan funcionando correctamente después de la refactorización.

**Entregable:** Código refactorizado y optimizado para las operaciones CRUD en la API REST.

<details>
<summary>Pistas de conocimiento</summary>

- Considera patrones de diseño y mejores prácticas para la refactorización.
- Utiliza Terraform para gestionar la infraestructura.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es una operación CRUD y cómo se implementa en una API REST?
- **paraQueSirve**: ¿Para qué sirve el manejo de errores en las operaciones CRUD?
- **comoSeUsa**: ¿Cómo se usa Terraform para gestionar la infraestructura de la API REST?
- **erroresComunes**: ¿Cuáles son los errores comunes en las operaciones CRUD y cómo se manejan?
- **queDecisionesImplica**: ¿Qué decisiones implica la refactorización del código para mejorar la eficiencia y mantenibilidad?

## Criterios de Evaluacion

- Configuración correcta de la tabla DynamoDB.
- Implementación de las operaciones CRUD en la API REST.
- Manejo de errores y validaciones en las operaciones CRUD.
- Refactorización y optimización del código.

## Como trabajar con un asistente de IA

Hay dos caminos, elegi uno:

- **AGENTS.md** (recomendado) — instrucciones nativas del repo. Abri esta carpeta con tu agente local (Claude Code, Cursor, Codex, Copilot, Gemini) y las carga solo. Sabe que archivos faltan y con que comando se verifica, y completa el scaffold escribiendo en disco.
- **PROMPT_MEJORA.md** — para copiar y pegar en un chat (claude.ai, ChatGPT) si no tenes un agente en el IDE. Declara lo mismo que AGENTS.md; los archivos que te devuelva el chat los guardas en esta carpeta respetando las rutas.

Ninguno de los dos resuelve las fases del reto: eso es tu trabajo.

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

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
(cd app && npm install && npm run build) && (cd infra && terraform fmt -check -recursive && terraform init -backend=false && terraform validate) && docker compose config -q
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
