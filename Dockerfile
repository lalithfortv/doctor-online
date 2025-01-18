# Use the official Nginx image as the base
FROM nginx:latest

# Copy your website's files to the Nginx HTML directory
COPY . /usr/share/nginx/html/

# Expose port 80 (default port for Nginx) to access the website
EXPOSE 80