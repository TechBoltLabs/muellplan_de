# Use an official Flutter SDK as builder
FROM ghcr.io/cirruslabs/flutter:3.10.1 AS builder

# set working directory
WORKDIR /app

# copy everything to the builder
COPY . .

# Build the web app
RUN flutter pub get
#RUN flutter test
RUN flutter build web

# Use an official Nginx runtime as parent image
FROM nginx:stable-alpine

# Set the working directory to nginx asses directory
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# copy static build directory
COPY --from=builder /app/build/web/ /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]