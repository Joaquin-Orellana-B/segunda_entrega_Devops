# Fase 7: Perfil de Configuración Docker

## Descripción
En esta fase se creó el perfil de entorno `docker` (`application-docker.properties`) para desacoplar las propiedades de ejecución local (H2 en memoria) de las propiedades de producción/contenedorización (PostgreSQL).

## Componentes Creados y Validados

1. **`application-docker.properties`**:
   - Sobrescribe el origen de datos hacia el servicio `db:5432/orderdb`.
   - Modifica el dialecto de Hibernate a PostgreSQL.
   - Mantiene la exposición del puerto `8098` y los endpoints de monitoreo de Actuator (`/actuator/health`).

## Beneficios
- **Desacoplamiento**: Permite alternar entre la base H2 de pruebas locales y PostgreSQL en contenedores pasando la variable de entorno `SPRING_PROFILES_ACTIVE=docker`.