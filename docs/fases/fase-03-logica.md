# Fase 3: Servicios y Excepciones de Negocio

## Descripción
En esta fase se implementó la capa de servicios (`OrderService`) encargada de concentrar la lógica de dominio y las reglas del negocio de pedidos, junto con las excepciones personalizadas para el manejo de errores.

## Componentes Creados y Validados

1. **`OrderNotFoundException` (`RuntimeException`)**:
   - Se lanza al no encontrar un pedido por su identificador único (ID).

2. **`InvalidOrderStateException` (`RuntimeException`)**:
   - Se lanza al intentar realizar transiciones no permitidas en el flujo de estados o modificar pedidos fuera de estado `PENDING`.

3. **`GlobalExceptionHandler` (`@RestControllerAdvice`)**:
   - Mapea `OrderNotFoundException` a HTTP 404 (Not Found).
   - Mapea `InvalidOrderStateException` a HTTP 409 (Conflict).
   - Estructura las respuestas de error en formato JSON estandarizado.

4. **`OrderService` (`@Service`)**:
   - Métodos de lectura: `getAllOrders`, `getOrdersByStatus`, `getOrderById`.
   - Control de transiciones: `confirmOrder`, `shipOrder`, `deliverOrder`, `cancelOrder`.
   - Modificación de contenido: `addItem` (restringido a estado `PENDING`).
   - Gestión transaccional mediante `@Transactional`.

## Evidencia de Compilación
- Se compiló el proyecto garantizando la correcta inyección de dependencias y la resolución de tipos en la capa de servicios.