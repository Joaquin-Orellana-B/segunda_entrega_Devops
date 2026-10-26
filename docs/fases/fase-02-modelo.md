# Fase 2: Modelo de Datos y Repositorio JPA

## Descripción
En esta fase se definió el modelo relacional del dominio de pedidos utilizando Spring Data JPA y Hibernate, estableciendo la persistencia en la base de datos H2 en memoria.

## Componentes Creados y Validados

1. **`OrderStatus` (Enum)**:
   - Define los estados del pedido: `PENDING`, `CONFIRMED`, `SHIPPED`, `DELIVERED`, `CANCELLED`.

2. **`OrderItem` (`@Embeddable`)**:
   - Representa el producto, cantidad y precio unitario dentro de la tabla `order_items`.
   - Incluye lógica de cálculo de subtotal.

3. **`Order` (`@Entity`)**:
   - Representa la tabla `orders`.
   - Colección `@ElementCollection` hacia `order_items`.
   - Hook `@PrePersist` para timestamp y montos por defecto.
   - Recálculo automático de total mediante `addItem()`.

4. **`OrderRepository` (`@Repository`)**:
   - Interfaz `JpaRepository<Order, Long>`.
   - Métodos de búsqueda derivados: `findByStatus` y `findByCustomerNameContainingIgnoreCase`.

## Evidencia
- Al iniciar la aplicación, Hibernate genera e impacta automáticamente el esquema de tablas `orders` y `order_items` en H2 sin errores.