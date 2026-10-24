# 📦 Order Manager - Microservicio de Gestión de Pedidos

![Java](https://img.shields.io/badge/Java-17-orange)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.3.4-brightgreen)
![Docker](https://img.shields.io/badge/Docker-Multi--stage-blue)
![CI/CD](https://img.shields.io/badge/GitHub_Actions-Automated-success)

Microservicio RESTful para la gestión del ciclo de vida de pedidos, ítems y estados de entrega. Desarrollado con **Spring Boot**, **Java 17**, **H2 / PostgreSQL**, **Docker**, **Docker Compose** y un pipeline de **CI/CD con GitHub Actions**.

---

## 🛠️ Arquitectura y Tecnologías

- **Lenguaje & Framework**: Java 17, Spring Boot 3.3.4 (Spring Data JPA, Spring Web, Validation, Actuator).
- **Bases de Datos**:
  - *Desarrollo/Pruebas*: H2 Database (en memoria).
  - *Contenedor/Producción*: PostgreSQL 15 Alpine.
- **Pruebas Automatizadas**: JUnit 5, Mockito, MockMvc.
- **Contenerización**: Docker (Multi-stage build con `eclipse-temurin:17-jre-alpine`).
- **Orquestación**: Docker Compose (App + PostgreSQL con Healthchecks y volumen nombrado).
- **CI/CD**: GitHub Actions (Jobs de compilación, ejecución de tests y verificación de despliegue) + Dependabot.

---

## 📁 Estructura del Proyecto

```text
order-manager/
├── .github/
│   ├── workflows/
│   │   └── ci-cd.yml
│   └── dependabot.yml
├── docs/
│   └── fases/            # Bitácora detallada de las 10 fases del proyecto
│       ├── fase1.md
│       ├── ...
│       └── fase10.md
├── src/
│   ├── main/
│   │   ├── java/com/example/ordermanager/
│   │   │   ├── controller/
│   │   │   ├── dto/
│   │   │   ├── exception/
│   │   │   ├── model/
│   │   │   ├── repository/
│   │   │   └── service/
│   │   └── resources/
│   │       ├── application.properties
│   │       └── application-docker.properties
│   └── test/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
└── pom.xml