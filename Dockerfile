FROM maven:3.6.3-jdk-11-openj9 AS build-env
WORKDIR /app

COPY . ./
RUN mvn clean install
RUN ls /app && ls /app/

# Build runtime image
FROM adoptopenjdk/openjdk11:alpine-slim

WORKDIR /app
COPY --from=build-env /app/out .

EXPOSE 80

ENTRYPOINT ["java", "-jar", "-XX:+UseZGC", "heritrix3.jar"]