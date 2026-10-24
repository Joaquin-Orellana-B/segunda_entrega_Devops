# Fase 9: Automatización, CI/CD y Gestión de Dependencias

## Descripción
En esta fase se implementó el pipeline de Integración Continua (CI/CD) mediante GitHub Actions y la automatización del escaneo de seguridad de dependencias con Dependabot.

## Componentes Configurados

1. **Pipeline de GitHub Actions (`.github/workflows/ci-cd.yml`)**:
   - **Job `test-and-build`**: Descarga el código, configura JDK 17 y ejecuta la suite completa de pruebas unitarias e integración (`mvn verify`). Guarda los artefactos de ejecución.
   - **Job `docker-integration`**: Depende del éxito de la etapa previa (`needs: test-and-build`), construye la imagen Docker, levanta la orquestación con Compose y valida la respuesta del endpoint `/actuator/health`.

2. **Gestión de Vulnerabilidades (`.github/dependabot.yml`)**:
   - Configuración de revisiones semanales automáticas para librerías Maven (`pom.xml`) e imágenes base de Docker (`Dockerfile`).