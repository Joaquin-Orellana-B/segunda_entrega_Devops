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

### Matriz de Cumplimiento de la Rúbrica (IE1 - IE5)

| Indicador | Descripción Rúbrica | Implementación en el Proyecto | Ubicación |
| :--- | :--- | :--- | :--- |
| **IE1 / IL2.1** | Contenerización de la aplicación | `Dockerfile` Multi-stage build con usuario no-root (`spring`) e imagen ligera `alpine`. | `Dockerfile`, `.dockerignore` |
| **IE2 / IL2.2** | Pruebas automatizadas en el pipeline | 28 pruebas automatizadas (15 de servicio + 13 de controlador) integradas en CI/CD. | `src/test/`, `.github/workflows/ci-cd.yml` |
| **IE3 / IL2.3** | Parámetros de escalabilidad y seguridad | Control de vulnerabilidades con Dependabot y análisis estático con SonarQube/JaCoCo. | `.github/dependabot.yml`, `pom.xml` |
| **IE4 / IL2.4** | Despliegue automático y trazabilidad | Pipeline en GitHub Actions que compila, prueba, construye y valida la salud en cada `push`. | `.github/workflows/ci-cd.yml` |
| **IE5 / IL2.5** | Orquestación de contenedores | Docker Compose con PostgreSQL, healthchecks (`pg_isready`), volumen persistente y red aislada. | `docker-compose.yml` |

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

* **`main`**: Rama de producción. Contiene el código estable y listo para despliegue. Cada *push* o *merge* activa la ejecución completa del pipeline CI/CD (pruebas, análisis de seguridad, empaquetado e integración)[cite: 3].
* **`develop/JO`**: Rama de integración y desarrollo activo. Permite validar los cambios mediante ejecuciones automatizadas de pruebas en GitHub Actions antes de fusionar a la rama principal.

### Convenciones de Naming de Ramas

A diferencia de *Trunk-Based Development* (que utiliza ramas efímeras de corta duración), para este proyecto se optó por una estrategia adaptada de **Git Flow**, basada en **ramas de desarrollo de larga duración por integrante**. 

Bajo este esquema, la rama `main` se mantiene como el tronco principal y estable de producción, mientras que cada desarrollador dispone de su propia rama permanente para avanzar en la construcción y prueba de las distintas fases antes de consolidar el código mediante *Pull Requests*.

#### Estructura y Convención de Nombres
Las ramas individuales siguen la convención de nomenclatura `Developer/inicial_nombre_inicial_apellido`:

* **`main`**: Rama principal de producción. Contiene el código estable, verificado y listo para despliegue o entrega final[cite: 3].
* **`Developer/J_O`** (o `Developer/JO`): Rama permanente de desarrollo e integración activa de Joaquín Orellana[cite: 2].
* **`Developer/I_A2`**: Rama permanente de desarrollo e integración del segundo desarrollador.
* **`Developer/I_A3`**: Rama permanente de desarrollo e integración del tercer desarrollador.

### Convenciones de Commits

Adoptamos el estándar de **Conventional Commits** con la siguiente estructura general:
`<tipo>(<ámbito_opcional>): <descripción corta en presente>`

#### Tipos utilizados
* **`feat`**: Nueva funcionalidad o requerimiento de negocio (ej. `feat(fase-2): agrega modelo JPA y repositorios de órdenes`).
* **`fix`**: Corrección de errores o fallos (ej. `fix(fase-4): corrige código de respuesta HTTP en controlador REST`).
* **`docs`**: Cambios exclusivamente en documentación (ej. `docs: actualiza el README con instrucciones de ejecución y fases`)[cite: 1, 3].
* **`test`**: Adición o modificación de pruebas unitarias o de integración (ej. `test(fase-5): agrega 24 pruebas unitarias e integración`)[cite: 1].
* **`ci` / `build`**: Cambios en archivos de automatización, configuración de Maven o Docker (ej. `ci(fase-9): añade pipeline de GitHub Actions`).

Se decidió utilizar esta convención porque facilita comprender rápidamente qué cambio se realizó en cada commit, permite mantener una trazabilidad clara del historial de Git y respalda el flujo de Integración Continua (CI).

### Estrategia de Revisión (Pull Requests)

Los cambios realizados por los integrantes del equipo son revisados mediante **Pull Requests (PR)** antes de ser integrados a la rama principal `main`[cite: 2, 3].

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

La suite consta de 28 pruebas automatizadas que garantizan la estabilidad del sistema:

Pruebas Unitarias (OrderServiceTest): 15 pruebas de lógica de negocio y excepciones usando Mockito.

Pruebas de Integración Web (OrderControllerTest): 13 pruebas de endpoints HTTP y mapeo JSON con MockMvc.

Para ejecutar los tests localmente:

mvn clean test -Dnet.bytebuddy.experimental=true

## Pipeline CI/CD y Trazabilidad

El archivo .github/workflows/ci-cd.yml define dos jobs automatizados en GitHub Actions:

test-and-build:

Descarga el código y configura JDK 17 Temurin.

Ejecuta mvn clean verify (compila y corre los 28 tests).

Genera y almacena los reportes de prueba como artefacto.

docker-integration:

Se ejecuta únicamente si los tests pasaron exitosamente (needs: test-and-build).

Construye la imagen Docker y levanta el entorno con docker compose up -d.

Realiza un health check llamando a http://localhost:8098/actuator/health hasta confirmar respuesta HTTP 200 OK.

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
Gemini / ChatGPT,"Apoyo en la estructuración de plantillas Markdown, generación del flujo en GitHub Actions y resolución de errores de entorno."

## Reflexiones Individuales

Reflexión — Valentina Cortez

Reflexión — Joaquín Orellana

### Reflexión — Joaquín Orellana

Las herramientas aplicadas en este proyecto despertaron un profundo interés en mí. La posibilidad de utilizar Docker y la contenerización me pareció una tecnología increíble, ya que hasta este punto no me había tocado trabajar con ella. Al estar en primer año, aún me encuentro aprendiendo las mejores prácticas y pipelines de trabajo; con frecuencia me ocurría que, al cambiar de computador, debía reconfigurar todo el entorno desde cero para continuar con un proyecto. En este contexto, comprendí cómo los contenedores facilitan enormemente la portabilidad y la flexibilidad al desarrollar software en distintos equipos.

Por otro lado, la implementación de pruebas unitarias me pareció fundamental. A pesar de que el código que escribo aún no es masivo, a veces resulta complejo realizar revisiones manuales y asegurar la calidad del sistema. Esta herramienta, combinada con la automatización de GitHub Actions, permite definir criterios mínimos de calidad que se gestionan de forma automática. En general, considero una gran oportunidad haber desarrollado un proyecto integrando estas herramientas DevOps.

Reflexión — Bastián Sandoval


