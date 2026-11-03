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
│   ├── workflows/ci-cd.yml         # Pipeline CI/CD (Tests, SonarCloud, GHCR, Trivy y Deploy)
│   └── dependabot.yml              # Escaneo y actualización semanal de dependencias
├── .sonar/                         # Archivos temporales y caché de análisis de SonarCloud
├── docs/fases/                     # Bitácora detallada de las 10 fases DevOps
├── src/
│   └── main/
│       ├── java/com/example/ordermanager/  # Código fuente de la aplicación Java / Spring Boot
│       └── resources/
│           ├── application.properties      # Configuración local (Base de datos H2)
│           └── application-docker.properties # Configuración Docker (Base de datos PostgreSQL)
├── .dockerignore                   # Exclusión de archivos pesados/sensibles en la compilación Docker
├── .gitignore                      # Exclusión de archivos rastreados por Git (target, IDEs, etc.)
├── Dockerfile                      # Empaquetado Multi-stage de la aplicación
├── README.md                       # Documentación principal del proyecto
├── docker-compose.yml              # Orquestación de servicios (App Spring Boot + PostgreSQL)
├── pom.xml                         # Gestión de dependencias Maven, plugins y coberturas (JaCoCo)
└── sonar-project.properties        # Configuración y parámetros del análisis de código en SonarCloud
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
* **Cobertura Global:** **86%** de cobertura total del proyecto.

### 🚀 Ejecución de Tests y Generación del Reporte

**Opción 1: Mediante Docker **

docker run --rm -v "${PWD}:/app" -w /app maven:3.9-eclipse-temurin-17 mvn clean verify

## Pipeline CI/CD y trazabilidad

El workflow [`.github/workflows/ci-cd.yml`](.github/workflows/ci-cd.yml) automatiza las validaciones del proyecto en GitHub Actions. Se ejecuta ante `push` y `pull_request` dirigidos a las ramas configuradas (`main`, `master` y ramas de desarrollo indicadas en el workflow).

### Jobs implementados

1. **`test-and-build` — pruebas y cobertura**
   - Configura Java 17 Temurin y la caché de Maven.
   - Ejecuta `mvn clean verify`.
   - Publica como artefactos los reportes de pruebas Surefire y cobertura JaCoCo, con retención de siete días.

2. **`security-analysis` — análisis SonarCloud**
   - Se ejecuta después de que finaliza correctamente `test-and-build`.
   - Configura Java 21 y ejecuta el análisis de SonarCloud con espera del Quality Gate.
   - Si `SONAR_TOKEN` no está configurado, el análisis se omite y el job termina correctamente. Para ejecutarlo se deben configurar también la clave del proyecto y la organización mediante variables o secretos del repositorio.

3. **`docker-integration-test` — integración con Docker Compose**
   - Se ejecuta después de que las pruebas pasan.
   - Construye y levanta los servicios con `docker compose up -d --build`.
   - Comprueba el endpoint `http://localhost:8098/actuator/health`.
   - Al finalizar, incluso si ocurre un error, limpia los contenedores y volúmenes con `docker compose down -v`.

4. **`deploy` — validación de despliegue y trazabilidad**
   - Se ejecuta únicamente en eventos `push` a `main` o `master`, después de los jobs de análisis e integración Docker.
   - Construye localmente la imagen con etiquetas correspondientes al SHA del commit y `latest`.
   - Levanta los servicios con Docker Compose, verifica `/actuator/health` y prueba `GET /api/orders`.
   - Registra en el log el SHA, actor, repositorio, rama, workflow, ID de ejecución y fecha.
   - Limpia los contenedores y volúmenes al terminar.

### Alcance actual del despliegue

El job `deploy` valida la imagen y la aplicación dentro del runner temporal de GitHub Actions. Aunque la imagen se etiqueta con el SHA del commit, **no se publica en GitHub Container Registry (GHCR)**: el job no inicia sesión en GHCR ni ejecuta una acción de publicación. Tampoco despliega en un servidor persistente; los contenedores se eliminan al final de la ejecución. Por lo tanto, la trazabilidad disponible actualmente corresponde al log del workflow y no verifica de forma independiente el SHA que ejecuta un entorno productivo.

El permiso `packages: write` habilita potencialmente la publicación de paquetes, pero no publica una imagen por sí solo. La publicación y el despliegue a un entorno persistente requieren pasos y configuración adicionales.

### Trivy permite analizar imágenes de contenedores en busca de vulnerabilidades en paquetes del sistema operativo y dependencias incluidas. El equipo informa que el análisis se ejecuta correctamente. Se utilizó para escanear la imagen Docker del proyecto en busca de vulnerabilidades en sus componentes. 

### SonarCloud analiza el código y puede incorporar el reporte de cobertura JaCoCo para evaluar su calidad. SonarCloud no ejecuta las pruebas ni garantiza por sí solo que la aplicación funcione correctamente en tiempo de ejecución. También analiza el código e incorpora el reporte JaCoCo para mostrar métricas de calidad y cobertura. El parámetro sonar.qualitygate.wait=true hace que el job espere el resultado del Quality Gate.





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




