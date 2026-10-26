# Fase 6: Contenedores (Dockerfile y .dockerignore)

## Descripción
En esta fase se configuró la contenerización del microservicio `order-manager` mediante un `Dockerfile` multi-stage y un archivo `.dockerignore` para optimizar el tamaño y la seguridad de la imagen final.

## Estrategia de Contenerización
- **Multi-stage Build**:
  - *Etapa 1 (Build)*: Compilación mediante `maven:3.9-eclipse-temurin-17-alpine`.
  - *Etapa 2 (Runtime)*: Ejecución ligera sobre `eclipse-temurin:17-jre-alpine`.
- **Seguridad**: Ejecución del proceso con un usuario no-root (`spring:spring`).
- **Puerto expuesto**: `8098`.
- **Exclusiones (.dockerignore)**: Exclusión de carpetas `target/`, `.vscode/`, `.git/` y documentación.