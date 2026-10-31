# Etapa 1: Build (compilación y empaquetado)
FROM maven:3.9-eclipse-temurin-17-alpine AS build
WORKDIR /app

# Copiar solo el pom.xml para aprovechar la caché de dependencias
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copiar el código fuente y empaquetar el JAR (los tests ya corren en el pipeline)
COPY src ./src
RUN mvn package -DskipTests -B

# Etapa 2: Runtime (imagen final ligera)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Metadata OCI
LABEL org.opencontainers.image.title="order-manager" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.description="API de ordenes con Spring Boot" \
      org.opencontainers.image.licenses="MIT"

# Crear usuario no root con UID/GID numérico fijo
RUN addgroup -S -g 1000 spring && adduser -S -u 1000 -G spring spring

# Copiar el JAR asignando la propiedad al usuario no root
COPY --from=build --chown=1000:1000 /app/target/*.jar app.jar

# Opciones de JVM: límite de heap al 75% de la memoria del contenedor
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0"

EXPOSE 8098

# Healthcheck contra Actuator
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8098/actuator/health || exit 1

# Usuario numérico y exec para recibir señales correctamente
USER 1000:1000
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.jar"]