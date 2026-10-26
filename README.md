# Order Manager API

API REST para gestionar pedidos, desarrollada con Java 25 LTS, Spring Boot 4.0.9 y Maven. Esta entrega cubre pruebas automatizadas, contenedores, orquestación, análisis de calidad y seguridad, y un despliegue simulado en GitHub Actions.

> El proyecto adapta las fases 5–10 de la guía DevOps al dominio **Order Manager**. La simulación cloud ejecuta los contenedores en un runner temporal de GitHub Actions; no publica la imagen en un registry ni crea infraestructura cloud persistente.

## Requisitos

- JDK 25. Comprueba `java -version` y configura `JAVA_HOME` para que Maven use ese JDK.
- Maven 3.9 o posterior.
- Docker Engine y Docker Compose v2 para contenedores.
- Para ejecutar el pipeline completo: repositorio en GitHub con Actions habilitado. SonarCloud requiere además un proyecto y las variables/secreto descritos abajo.

## Ejecutar localmente

Desde la raíz del repositorio:

```bash
mvn spring-boot:run
```

La aplicación usa el perfil predeterminado y una base H2 en memoria. La API escucha en <http://localhost:8098>; la consola H2 está en <http://localhost:8098/h2-console>.

Endpoints principales:

| Método | Ruta | Descripción |
| --- | --- | --- |
| `GET` | `/api/orders` | Listar pedidos |
| `GET` | `/api/orders/{id}` | Consultar un pedido |
| `GET` | `/api/orders/status/{status}` | Filtrar por estado |
| `POST` | `/api/orders` | Crear un pedido |
| `POST` | `/api/orders/{id}/items` | Agregar un artículo |
| `PUT` | `/api/orders/{id}/confirm` | Confirmar un pedido |
| `PUT` | `/api/orders/{id}/ship` | Marcar como enviado |
| `PUT` | `/api/orders/{id}/deliver` | Marcar como entregado |
| `PUT` | `/api/orders/{id}/cancel` | Cancelar un pedido |
| `DELETE` | `/api/orders/{id}` | Eliminar un pedido |

La API de salud de Actuator es <http://localhost:8098/actuator/health>.

## Fase 5: pruebas automatizadas

Ejecuta la compilación, las pruebas y el reporte de cobertura:

```bash
mvn --batch-mode clean verify
```

JUnit ejecuta pruebas unitarias del servicio y pruebas web del controlador; JaCoCo genera el reporte en `target/site/jacoco/index.html`. Los resultados de JUnit quedan en `target/surefire-reports/`.

Para comprobar el resultado en PowerShell:

```powershell
Get-Content .\target\surefire-reports\*.txt | Select-String "Tests run:"
```

## Fases 6–8: Docker, perfil y Compose

El [Dockerfile](Dockerfile) usa una compilación multi-stage con Maven y Java 25, y ejecuta el JAR en una imagen JRE como usuario no root (`10001`). La imagen define un healthcheck HTTP. El archivo [.dockerignore](.dockerignore) excluye artefactos, archivos de entorno y otros recursos que no deben entrar al contexto de construcción.

El perfil `docker` configura PostgreSQL y deshabilita la consola H2. Compose levanta la API y PostgreSQL, espera a que la base de datos esté saludable, conserva sus datos en un volumen y aplica límites de memoria, CPU y procesos, healthchecks y `no-new-privileges`.

Comprueba la configuración e inicia el entorno:

```bash
docker compose config --quiet
docker compose up --build --detach
docker compose ps
```

Comprueba salud y API:

```bash
curl --fail http://localhost:8098/actuator/health
curl --fail http://localhost:8098/api/orders
```

En PowerShell puedes usar:

```powershell
Invoke-RestMethod http://localhost:8098/actuator/health
Invoke-RestMethod http://localhost:8098/api/orders
```

Detén los contenedores conservando los datos:

```bash
docker compose down
```

Elimina también el volumen de PostgreSQL:

```bash
docker compose down --volumes
```

Compose usa credenciales de demostración (`orders` / `orders-local`) por defecto. Son únicamente para desarrollo local; no se deben usar en producción ni guardar credenciales reales en el repositorio. Para personalizar el entorno, define `POSTGRES_DB`, `POSTGRES_USER` y `POSTGRES_PASSWORD` antes de ejecutar Compose.

Los límites de CPU y memoria son controles de recursos, **no escalado automático**. Esta configuración no implementa réplicas, autoescalado ni alta disponibilidad.

## Fase 9: pipeline CI/CD

El workflow [ci-cd.yml](.github/workflows/ci-cd.yml) se ejecuta en *push* a `main`/`master`, en pull requests hacia esas ramas y por `workflow_dispatch`. Usa Java 25 y Maven. Sus jobs son:

1. **Pruebas y empaquetado Maven:** ejecuta `mvn verify`; un fallo de compilación o pruebas bloquea los jobs dependientes.
2. **SonarCloud y Quality Gate:** analiza el proyecto después de las pruebas y falla si el Quality Gate no se cumple.
3. **Construcción y seguridad de imagen:** construye la imagen Docker y Trivy analiza vulnerabilidades de severidad alta y crítica; las que tengan corrección disponible bloquean el job.
4. **Despliegue simulado:** solo en un *push* a `main`/`master` y después de aprobar SonarCloud y Trivy, inicia API y PostgreSQL con Docker Compose, comprueba el endpoint de salud y limpia los contenedores.

El despliegue **no** se ejecuta en pull requests ni al iniciar manualmente `workflow_dispatch`; esos eventos sirven para comprobar el pipeline, no para desplegar. La simulación ocurre en un runner efímero de GitHub Actions y no deja un servicio en línea al terminar el job.

### Configurar SonarCloud

Vincula el repositorio a un proyecto de SonarCloud y, en **Settings → Secrets and variables → Actions**, configura:

- Secreto `SONAR_TOKEN`: token de análisis.
- Variable `SONAR_PROJECT_KEY`: clave del proyecto.
- Variable `SONAR_ORGANIZATION`: identificador de la organización.

El job valida que estén configurados y falla explícitamente si falta alguno. Habilita también Dependabot alerts y security updates en los ajustes de seguridad del repositorio.

## Cómo demostrar los criterios de la rúbrica

1. Abre un pull request hacia `main` o `master`. En **Actions**, muestra la ejecución del job de pruebas, el análisis SonarCloud y el escaneo Trivy. El job de despliegue no debe ejecutarse para el pull request.
2. Fusiona el pull request y verifica la ejecución iniciada por el *push* a la rama principal. Muestra que las pruebas, SonarCloud y Trivy finalizaron antes del job de despliegue.
3. En el job de despliegue, muestra `docker compose up`, la respuesta exitosa de `/actuator/health` y la limpieza final del entorno.
4. Como evidencia local complementaria, muestra `docker compose ps` con API y base de datos saludables, las respuestas de salud y de `/api/orders`, y el reporte HTML de JaCoCo.

| Criterio | Evidencia |
| --- | --- |
| Pipeline CI/CD | Ejecución del workflow en GitHub Actions |
| Pruebas automatizadas | Job Maven aprobado y reportes JUnit |
| Escalabilidad y seguridad para contenedores | Límites de recursos, healthchecks, usuario no root, `no-new-privileges`, SonarCloud y Trivy |
| Despliegue cloud simulado | Job de Compose exitoso en el runner, endpoint saludable y limpieza del entorno |

## Fase 10: guía del repositorio

Este README documenta requisitos, ejecución local, endpoints, pruebas, contenedores, configuración del pipeline y evidencias sugeridas para revisar el proyecto desde cero.

## Archivos principales

- `src/main/java/`: API REST, lógica de pedidos, modelo y persistencia.
- `src/test/java/`: pruebas unitarias y web.
- `src/main/resources/application.properties`: configuración local con H2.
- `src/main/resources/application-docker.properties`: configuración del perfil Docker.
- `Dockerfile`, `.dockerignore` y `docker-compose.yml`: imagen y orquestación.
- `.github/workflows/ci-cd.yml`: pipeline.
- `.github/dependabot.yml`: actualizaciones propuestas para Maven y GitHub Actions.
- `sonar-project.properties`: configuración de análisis y cobertura.

## Reflexión individual

En este trabajo, mi compañero y yo desarrollamos versiones distintas del proyecto y luego pude profundizar en cómo Docker permite empaquetar y ejecutar una aplicación en un entorno reproducible. Aprendí que los contenedores ayudan a que la aplicación y sus dependencias se ejecuten de forma más consistente en distintos equipos. Como aspecto por mejorar, reconozco que necesito organizar mejor el tiempo y avanzar por etapas, en lugar de dejar tareas para el final. En un próximo proyecto planificaría hitos pequeños y revisaría el progreso con anticipación.

## Uso de herramientas de IA

Si se utilizó GitHub Copilot u otra herramienta de IA en esta entrega, describe aquí el uso real y revisa el contenido con el equipo. Las justificaciones técnicas y reflexiones individuales exigidas por la evaluación deben ser redactadas y validadas por sus autores.
