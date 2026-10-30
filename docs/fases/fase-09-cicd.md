# Fase 9: Automatización, CI/CD y Gestión de Dependencias

## Descripción
En esta fase se implementó el pipeline de Integración Continua (CI/CD) mediante GitHub Actions y la automatización del escaneo de seguridad de dependencias con Dependabot.

## Componentes Configurados

1. **Pipeline de GitHub Actions (`.github/workflows/ci-cd.yml`)**:
   - Ejecuta las pruebas y valida el arranque con Docker Compose.
   - En pushes a `main`, publica en GHCR la misma imagen validada por Compose, etiquetada con el SHA completo del commit.
   - Despliega por SSH la imagen publicada en el servidor configurado en el environment `production`; verifica `/actuator/health` y compara la imagen del contenedor con la etiqueta del commit.
   - Registra el commit, la imagen y el run del workflow en el resumen de GitHub Actions.

2. **Configuración del despliegue**:
   - El environment `production` requiere los secrets `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY` y `SSH_KNOWN_HOSTS`, además de la variable `DEPLOY_PATH`.
   - GHCR mantiene el paquete privado; el servidor lo descarga con un token clásico limitado a `read:packages`, configurado como secret `GHCR_READ_TOKEN`.
   - Las credenciales de PostgreSQL se proporcionan en el archivo `.env` del servidor y no se guardan en Git.

3. **Gestión de Vulnerabilidades (`.github/dependabot.yml`)**:
   - Configuración de revisiones semanales automáticas para librerías Maven (`pom.xml`) e imágenes base de Docker (`Dockerfile`).