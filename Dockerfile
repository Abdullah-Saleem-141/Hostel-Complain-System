# Step 1: Build the application using Maven
FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Run the application using the same compatible Java image
FROM maven:3.8.4-openjdk-17-slim
WORKDIR /app
COPY --from=build /app/target/complain-portal-1.0-SNAPSHOT.war ./app.war
COPY --from=build /app/pom.xml .

# Expose the port
EXPOSE 8080

# Run using the Maven Tomcat plugin (easier for your project structure)
CMD ["mvn", "tomcat7:run"]
