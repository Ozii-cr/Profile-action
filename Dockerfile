# Stage 1: Use an official jdk image as the base image to build the artifact
FROM openjdk:11 AS BUILD_IMAGE

# Install dependencies
RUN apt update && apt install maven -y

# Copy the entire application to the working directory
COPY ./ profile-project

#Build the artifact
RUN cd profile-project &&  mvn install 

#Stage 2: Copy the artifact
FROM tomcat:9-jre11
LABEL "Project"="Profile"
RUN rm -rf /usr/local/tomcat/webapps/*

#copy the artifact from the build stage
COPY --from=BUILD_IMAGE profile-project/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Expose the port the app runs on
EXPOSE 8080

# Define the command to run the application
CMD ["catalina.sh", "run"]
