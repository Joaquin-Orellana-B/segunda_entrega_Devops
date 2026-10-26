# Fase 1: Fundación del Proyecto

## Descripción
En esta fase se verificó y validó la configuración base del microservicio `order-manager`, asegurando el correcto funcionamiento de las dependencias de Maven, las exclusiones de Git, las propiedades de la aplicación y el estado de salud mediante Spring Boot Actuator.

## Archivos Verificados y Validados

1. **`pom.xml`**:
   - Versión de Java: **17**.
   - Dependencias principales: Spring Boot Web, Data JPA, Validation, H2 Database (`runtime`), PostgreSQL (`runtime`) y Spring Boot Actuator[cite: 6].
   - Plugins DevOps configurados: `jacoco-maven-plugin` (cobertura) y `sonar-maven-plugin` (calidad de código)[cite: 6].

2. **`.gitignore`**:
   - Reglas activas para excluir binarios de compilación (`target/`), entornos de IDEs (`.vscode/`, `.idea/`), archivos de log (`*.log`), variables de entorno secretas (`.env`) y sobrescrituras locales de Docker (`docker-compose.override.yml`)[cite: 6].
   - Excepción configurada para conservar `!.mvn/wrapper/maven-wrapper.jar`[cite: 6].

3. **`OrderManagerApplication.java`**:
   - Clase principal localizada en el paquete raíz `com.example.ordermanager` anotada con `@SpringBootApplication`[cite: 6].

4. **`application.properties`**:
   - Nombre del microservicio: `order-manager`[cite: 6].
   - Base de datos H2 en memoria: `jdbc:h2:mem:orderdb`[cite: 6].
   - Puerto de ejecución: **8098**[cite: 6].
   - Monitoreo Actuator: Endpoints `/actuator/health` e `/actuator/info` expuestos[cite: 6].
   - Consola H2 habilitada en `/h2-console`[cite: 6].

## Evidencia de Pruebas de Funcionamiento

- **Inicio del Servicio**: Aplicación levantada y escuchando peticiones en el puerto `8098`[cite: 6].
- **Prueba de Salud (Health Check)**:
  - Comando ejecutado:
    ```powershell
    curl http://localhost:8098/actuator/health
    ```
  - **Resultado obtenido**: Código HTTP **200 OK** con respuesta JSON conteniendo `{"status":"UP"}`[cite: 5, 6].