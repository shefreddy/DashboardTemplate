# Stage 1: Build the React app
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install dependencies (including devDependencies for build)
RUN npm ci

# Install additional Tailwind-related dependencies
RUN npm install tailwind-variants clsx tailwind-merge @remixicon/react

# Copy the rest of the app
COPY . .

# Build the React app (Tailwind CSS will be processed)
RUN npm run build

# Stage 2: Serve the app with Nginx (lightweight production server)
FROM nginx:alpine

# Copy built files from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Copy custom Nginx config (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 (default for Nginx)
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]