FROM maven:3.9.12-eclipse-temurin-25-alpine AS build

WORKDIR /workspace
COPY pom.xml .
RUN mvn --batch-mode --no-transfer-progress dependency:go-offline

COPY src ./src
RUN mvn --batch-mode --no-transfer-progress package -DskipTests

FROM eclipse-temurin:25-jre-alpine

WORKDIR /app
RUN addgroup -S app && adduser -S -G app -u 10001 app
COPY --from=build /workspace/target/order-manager-1.0.0.jar app.jar

USER 10001:app
EXPOSE 8098
HEALTHCHECK --interval=30s --timeout=5s --start-period=45s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1:8098/actuator/health || exit 1
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-jar", "/app/app.jar"]