# Fase 8: Orquestación con Docker Compose

## Descripción
En esta fase se configuró la orquestación multi-contenedor mediante `docker-compose.yml`, integrando el microservicio `order-manager` con un motor de base de datos relacional PostgreSQL.

## Componentes y Servicios Definidos

1. **Servicio `db` (PostgreSQL 15 Alpine)**:
   - Contenedor: `order-db`.
   - Persistencia: Volumen nombrado `postgres_data`.
   - Healthcheck: Control con `pg_isready` para verificar disponibilidad de conexiones.

2. **Servicio `app` (Order Manager)**:
   - Contenedor: `order-manager-app`.
   - Construcción basada en el `Dockerfile` multi-stage.
   - Activación del perfil `docker` mediante `SPRING_PROFILES_ACTIVE=docker`.
   - Dependencia estricta: `depends_on` sujeto a `service_healthy` de la base de datos.

3. **Aislamiento de Red**:
   - Red tipo bridge `order-net` para comunicación interna segura.