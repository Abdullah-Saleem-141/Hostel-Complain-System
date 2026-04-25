# Step 1: Build the application using Maven
FROM maven:3.8.4-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Run the application using Tomcat 7 (as configured in your pom.xml)
FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/target/complain-portal-1.0-SNAPSHOT.war ./app.war
COPY --from=build /app/pom.xml .

# We'll use Maven to run the war file just like you do locally
RUN apt-get update && apt-get install -y maven
EXPOSE 8080
CMD ["mvn", "tomcat7:run"]
