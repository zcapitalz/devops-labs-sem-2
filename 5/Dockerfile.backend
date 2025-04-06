FROM eclipse-temurin:11-jdk-alpine AS builder

RUN apk add --no-cache maven

WORKDIR /app

COPY pom.xml .
COPY src src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:11-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

RUN mkdir -p /config
COPY --from=builder /app/src/main/resources/application.properties /config/

ENTRYPOINT ["java", "-jar", "app.jar", "--spring.config.location=classpath:/,file:/config/"]
