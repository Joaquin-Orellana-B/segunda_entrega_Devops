# 📋 Order Manager API

[![CI/CD Pipeline](https://github.com/Joaquin-Orellana-B/segunda_entrega_Devops/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/Joaquin-Orellana-B/segunda_entrega_Devops/actions)
![Java](https://img.shields.io/badge/Java-17-blue)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.3.4-brightgreen)
![Docker](https://img.shields.io/badge/Docker-Multi--stage-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15--Alpine-blue)

Microservicio RESTful para la gestión del ciclo de vida de pedidos, desarrollado como proyecto práctico de la asignatura **Ingeniería DevOps (DOY0101)** en **Duoc UC**.

---

## 🎯 Descripción y Matriz de Indicadores

El proyecto aborda la automatización completa del ciclo de vida de software: desde el desarrollo local hasta la construcción de imágenes, orquestación de contenedores y despliegue continuo mediante **GitHub Actions**.

---

## 🛠️ Stack Tecnológico y Arquitectura

- **Lenguaje & Framework**: Java 17, Spring Boot 3.3.4 (Data JPA, Web, Validation, Actuator).
- **Bases de Datos**: H2 Database (desarrollo local/tests) y PostgreSQL 15 Alpine (producción/contenedores).
- **Contenerización**: Docker (Multi-stage build).
- **Orquestación**: Docker Compose (Servicios `db` y `app` con `healthcheck`).
- **CI/CD**: GitHub Actions y Dependabot.

```text
[ Cliente / Postman ] ──> [ Spring Boot API (Port 8098) ] ──> [ PostgreSQL (Port 5432) ]
                                     │
                          [ Actuator Health Check ]
```


## Estructura del proyecto


```text
segunda_entrega_Devops/
├── .github/
│   ├── workflows/ci-cd.yml         # Pipeline de Integración Continua
│   └── dependabot.yml              # Escaneo semanal de dependencias
├── docs/fases/                     # Bitácora detallada de las 10 fases
├── src/
│   ├── main/java/com/example/ordermanager/
│   └── main/resources/
│       ├── application.properties         # Configuración Local (H2)
│       └── application-docker.properties  # Configuración Docker (PostgreSQL)
├── Dockerfile                      # Empaquetado Multi-stage
├── docker-compose.yml              # Orquestación App + DB
├── .dockerignore                   # Exclusión de archivos pesados
└── pom.xml                         # Gestión de dependencias y plugins
```

### Estrategia de Ramificación (Git Branching)

El proyecto utiliza una estrategia de desarrollo basada en ramas para garantizar la estabilidad del código:

* **`main`**: Rama de producción. Contiene el código estable y listo para despliegue. Cada *push* o *merge* activa la ejecución completa del pipeline CI/CD (pruebas, análisis de seguridad, empaquetado e integración).
* **`Developer/Iniciales`**: Ramas de integración y desarrollo activo. Permite validar los cambios mediante ejecuciones automatizadas de pruebas en GitHub Actions antes de fusionar a la rama principal.

### Convenciones de Naming de Ramas

A diferencia de *Trunk-Based Development*, para este proyecto se optó por una estrategia adaptada de **Git Flow**, basada en **ramas de desarrollo de larga duración por integrante**. 

Bajo este esquema, la rama `main` se mantiene como el tronco principal y estable de producción, mientras que cada desarrollador dispone de su propia rama permanente para avanzar en la construcción y prueba de las distintas fases antes de consolidar el código mediante *Pull Requests*.

#### Estructura y Convención de Nombres
Las ramas individuales siguen la convención de nomenclatura `Developer/inicial_nombre_inicial_apellido`:

* **`main`**: Rama principal de producción. Contiene el código estable, verificado y listo para despliegue o entrega final.

* -- Ramas desarrolladores

* **`Developer/JO`
* **`Developer/BS`.
* **`Developer/VC`

### Convenciones de Commits

Adoptamos el estándar de **Conventional Commits** con la siguiente estructura general:
`<tipo>(<ámbito_opcional>): <descripción corta en presente>`

#### Tipos utilizados
* **`feat`**: Nueva funcionalidad o requerimiento de negocio (ej. `feat(fase-2): agrega modelo JPA y repositorios de órdenes`).
* **`fix`**: Corrección de errores o fallos (ej. `fix(fase-4): corrige código de respuesta HTTP en controlador REST`).
* **`docs`**: Cambios exclusivamente en documentación (ej. `docs: actualiza el README con instrucciones de ejecución y fases`).
* **`test`**: Adición o modificación de pruebas unitarias o de integración (ej. `test(fase-5): agrega 24 pruebas unitarias e integración`).
* **`ci` / `build`**: Cambios en archivos de automatización, configuración de Maven o Docker (ej. `ci(fase-9): añade pipeline de GitHub Actions`).

Se decidió utilizar esta convención porque facilita comprender rápidamente qué cambio se realizó en cada commit, permite mantener una trazabilidad clara del historial de Git y respalda el flujo de Integración Continua (CI).

### Estrategia de Revisión (Pull Requests)

Los cambios realizados por los integrantes del equipo son revisados mediante **Pull Requests (PR)** antes de ser integrados a la rama principal `main`.

#### Criterios de Aceptación para Aprobar un PR
Para autorizar la aprobación y fusión (*merge*) de un Pull Request, se consideran los siguientes puntos:

* **Funcionalidad**: El código cumple con los requerimientos solicitados para la fase correspondiente.
* **Compilación y Pruebas**: La aplicación ejecuta correctamente en entorno local y supera la validación automatizada en el pipeline de CI/CD (GitHub Actions).
* **Coherencia**: Los cambios mantienen la arquitectura y estructura del proyecto.
* **Convención de Commits**: Los mensajes de commit respetan la estructura de *Conventional Commits*.

#### Flujo del Proceso

```text
Crear/Actualizar Rama
          ↓
   Realizar Cambios
          ↓
        Commit
          ↓
    Push a GitHub
          ↓
  Crear Pull Request
          ↓
Revisión e Integración CI/CD
          ↓
 Correcciones (si aplica)
          ↓
      Aprobación
          ↓
    Merge a main
```


##  Guía de Ejecución

### Ejecución con Docker Compose (App + PostgreSQL)

#### Levantar la infraestructura completa en segundo plano
docker compose up -d --build

#### Verificar estado de salud de los contenedores
docker compose ps

#### Ver logs en tiempo real
docker compose logs -f app

#### Detener y limpiar contenedores y volúmenes
docker compose down -v

## Pruebas Automatizadas y Cobertura

La suite consta de **28 pruebas automatizadas** que garantizan la estabilidad del sistema:

* **Pruebas Unitarias (`OrderServiceTest`):** 15 pruebas de lógica de negocio y manejo de excepciones utilizando Mockito.
* **Pruebas de Integración Web (`OrderControllerTest`):** 13 pruebas de endpoints HTTP y mapeo JSON con MockMvc.

### 📊 Cobertura de Código (JaCoCo)
El proyecto cuenta con el plugin de **JaCoCo** configurado para auditar la cobertura de las pruebas:
* **Capa de Servicios (`service`):** **91%** de cobertura en la lógica de negocio central.
* **Cobertura Global:** **63%** de cobertura total del proyecto.

### 🚀 Ejecución de Tests y Generación del Reporte

**Opción 1: Mediante Docker **

docker run --rm -v "${PWD}:/app" -w /app maven:3.9-eclipse-temurin-17 mvn clean verify

## Pipeline CI/CD y Trazabilidad

El workflow `.github/workflows/ci-cd.yml` ejecuta las pruebas y valida el despliegue con Docker Compose. Al subir cambios a `main`, publica en GHCR la imagen identificada por el SHA del commit y la despliega por SSH en el servidor configurado en el environment `production`. El job registra el commit y la imagen en el resumen de GitHub Actions y verifica el health check y la imagen que está ejecutando el contenedor.

### Configurar el despliegue

1. En GitHub, habilita GHCR para el repositorio. La imagen se mantiene privada y el servidor la descarga usando un token de solo lectura.
2. En **Settings → Environments**, crea el environment `production`.
3. Agrega estos secrets al environment:
   - `SSH_HOST`: host o dirección del servidor.
   - `SSH_USER`: usuario SSH con permiso para ejecutar Docker y Docker Compose.
   - `SSH_PRIVATE_KEY`: llave privada de despliegue. No la agregues al repositorio.
   - `SSH_KNOWN_HOSTS`: clave del host SSH obtenida y verificada por un canal confiable; no desactives la verificación de host.
   - `GHCR_USERNAME`: usuario de GitHub propietario de un token personal clásico con permiso `read:packages`.
   - `GHCR_READ_TOKEN`: el token clásico con permiso `read:packages`. No uses un token con permisos de escritura.
4. Agrega la variable `DEPLOY_PATH`, por ejemplo `/opt/order-manager`. El usuario SSH debe poder escribir en esa carpeta.
5. Instala Docker Engine, Docker Compose y `curl` en el servidor. Configura el acceso del usuario de despliegue a Docker.
6. Crea manualmente un archivo `.env` dentro de `DEPLOY_PATH` con `POSTGRES_DB`, `POSTGRES_USER` y `POSTGRES_PASSWORD`. Usa una contraseña fuerte, aplica permisos `chmod 600 .env` y no la subas a GitHub.
7. Configura el firewall para permitir el puerto `8098` solo según las necesidades del servicio. PostgreSQL queda enlazado a `127.0.0.1:5432`, no a todas las interfaces.
8. Fusiona un cambio validado en `main`. El despliegue ocurre solo para pushes a esa rama. En el resumen del job aparecerán el SHA y la imagen versionada.

Para desarrollo local, copia `.env.example` a `.env` y reemplaza la contraseña de ejemplo. El `.env` está excluido de Git.

## Endpoints de la API REST

| Método | Endpoint | Descripción | Estado HTTP Esperado |
| :--- | :--- | :--- | :--- |
| **GET** | `/actuator/health` | Estado de salud del sistema | `200 OK` |
| **GET** | `/api/orders` | Lista todos los pedidos | `200 OK` |
| **GET** | `/api/orders/{id}` | Obtiene detalle de un pedido por ID | `200 OK` / `404 Not Found` |
| **POST** | `/api/orders` | Crea un nuevo pedido | `201 Created` / `400 Bad Request` |
| **POST** | `/api/orders/{id}/items` | Agrega un ítem a un pedido | `200 OK` / `400 Bad Request` |
| **PUT** | `/api/orders/{id}/status` | Actualiza estado del pedido | `200 OK` / `409 Conflict` |
| **DELETE** | `/api/orders/{id}` | Elimina un pedido | `204 No Content` / `404 Not Found` |

## Solución de Problemas Frecuentes

Advertencia de ByteBuddy / Java 17 en tests:

Solución: Pasar la propiedad -Dnet.bytebuddy.experimental=true al ejecutar los tests.

## Uso de Inteligencia Artificial
Herramienta,Uso en el Proyecto
Gemini: "Apoyo en la estructuración de plantillas Markdown, generación del flujo en GitHub Actions y resolución de errores de entorno."

## Reflexiones Individuales

### Reflexión — Valentina Cortez

En este trabajo, mis compañeros y yo inicialmente desarrollamos versiones distintas del proyecto, después de organizarnos bien se seleccionó la mejor propuesta al proyecto y luego pude profundizar en cómo Docker permite empaquetar y ejecutar una aplicación en un entorno reproducible. Aprendí que los contenedores ayudan a que la aplicación y sus dependencias se ejecuten de forma más consistente en distintos equipos. Como aspecto por mejorar, reconozco que necesito organizar mejor el tiempo y avanzar por etapas, en lugar de dejar tareas para el final. En un próximo proyecto planificaría hitos pequeños y revisaría el progreso con anticipación.

### Reflexión — Joaquín Orellana

Las herramientas aplicadas en este proyecto despertaron un profundo interés en mí. La posibilidad de utilizar Docker y la contenerización me pareció una tecnología increíble, ya que hasta este punto no me había tocado trabajar con ella. Al estar en primer año, aún me encuentro aprendiendo las mejores prácticas y pipelines de trabajo; con frecuencia me ocurría que, al cambiar de computador, debía reconfigurar todo el entorno desde cero para continuar con un proyecto. En este contexto, comprendí cómo los contenedores facilitan enormemente la portabilidad y la flexibilidad al desarrollar software en distintos equipos.

Por otro lado, la implementación de pruebas unitarias me pareció fundamental. A pesar de que el código que escribo aún no es masivo, a veces resulta complejo realizar revisiones manuales y asegurar la calidad del sistema. Esta herramienta, combinada con la automatización de GitHub Actions, permite definir criterios mínimos de calidad que se gestionan de forma automática. En general, considero una gran oportunidad haber desarrollado un proyecto integrando estas herramientas DevOps.

### Reflexión — Bastián Sandoval

La realización de este trabajo fue muy desafiante, ya que me tenia que familiarizar con errores que nunca había visto, había que ver como se conectaban y relacionaban cada script de java y docker para que el despliegue y la orquestación tengan sentido y funcione con la base de datos. En especial la orquestación con compose, dado que no me salían los estados healty para poder agregar info a la bd, por lo que estuve peleando harto rato, hasta que al final lo pude lograr con perseverancia, mucho animo y apoyo. Me siento realizado, confiado y capaz para enfrentar un desafío como este.

También debo admitir que el entorno de spring boot me confundido, pero nada puede superar leer atentamente la documentación disponible que hay en internet y en las guías para poder entender todo y no perderse.

