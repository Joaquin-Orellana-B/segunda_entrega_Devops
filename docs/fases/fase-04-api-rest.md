# Fase 4: API REST, Controladores y DTOs

## Descripción
En esta fase se implementó la capa de presentación REST (`OrderController`) y los objetos de transferencia de datos (DTOs) con anotaciones de validación, conectando las peticiones HTTP con la capa de servicio.

## Componentes Creados y Validados

1. **`CreateOrderRequest` (DTO)**:
   - Encapsula la petición de creación de pedidos.
   - Validaciones: `@NotBlank` y `@Size` en `customerName`, `@Valid` en lista de ítems.

2. **`AddItemRequest` (DTO)**:
   - Encapsula la adición de productos a un pedido.
   - Validaciones: `@NotBlank`, `@Min`, `@Max`, `@DecimalMin` y `@Digits`.

3. **`OrderController` (`@RestController`)**:
   - Mapeo base: `/api/orders`.
   - Endpoints GET: consulta general, por estado y por ID.
   - Endpoint POST `/api/orders`: responde `201 Created`.
   - Endpoint POST `/api/orders/{id}/items`: agrega productos a pedidos en `PENDING`.
   - Endpoints PUT: flujos de transición (`confirm`, `ship`, `deliver`, `cancel`).
   - Endpoint DELETE `/api/orders/{id}`: responde `204 No Content`.

## Evidencia de Compilación
- Estructura de endpoints expuesta correctamente y compilación exitosa sin conflictos de mapeo de rutas.