# Stage 1: Build Hugo site
FROM floryn90/hugo:0.138.0-ext-alpine AS builder

WORKDIR /src

# Copy Hugo project files
COPY config.toml .
COPY content ./content
COPY themes ./themes

# Build the site
RUN hugo --minify

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Copy the built site from builder stage
COPY --from=builder /src/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80
