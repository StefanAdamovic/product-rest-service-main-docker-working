# Use an official Maven image to build the project in a container
FROM maven:3.8.7-openjdk-18 as builder

# Set the working directory in the Docker container
WORKDIR /app

# Copy the pom.xml file and download dependencies to leverage Docker cache
COPY pom.xml .
# Copy the rest of the application
COPY src ./src

# Build the application
RUN mvn package

# For the final image, use an official Java runtime as a smaller image
FROM openjdk:18

# Set the working directory in the Docker container
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Command to run the application
#CMD dockerize -wait tcp://mysqldb:3306 -timeout 30s java -jar app.jar
CMD ["java", "-jar", "app.jar"]

