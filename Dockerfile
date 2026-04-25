# Step 1: Build the application using Maven
FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Run the application
FROM maven:3.8.4-openjdk-17-slim
WORKDIR /app
# We need both the compiled target AND the source (for JSPs) to run tomcat7:run
COPY --from=build /app/target ./target
COPY --from=build /app/pom.xml .
COPY --from=build /app/src ./src

EXPOSE 8080

# Run using the Maven Tomcat plugin
CMD ["mvn", "tomcat7:run"]
