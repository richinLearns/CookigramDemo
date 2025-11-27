# stage 1: build
FROM mcr.microsoft.com/openjdk/jdk:25-ubuntu AS build
WORKDIR /workspace

# No need to apt-get install maven, we will use ./mvnw

COPY pom.xml mvnw ./
COPY .mvn .mvn
COPY src ./src

# Ensure the wrapper is executable
RUN chmod +x mvnw
# Use the wrapper instead of 'mvn'
RUN ./mvnw -B -e -q -DskipTests package

# stage 2: runtime
FROM mcr.microsoft.com/openjdk/jdk:25-ubuntu
WORKDIR /app
COPY --from=build /workspace/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]