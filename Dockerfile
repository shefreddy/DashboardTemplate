# Stage 1: Build the React app
FROM node:20-alpine AS builder

WORKDIR /app

# Copy ONLY package.json first (no lockfile required)
COPY package.json ./

# Install dependencies (npm install will generate its own lockfile)
RUN npm install --silent

# Add your extra dependencies
RUN npm install tailwind-variants clsx tailwind-merge @remixicon/react

# Copy the rest of the app
COPY . .

# Build the app
RUN npm run build

# Stage 2: Production server
FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "run", "--host=0.0.0.0", "--port=80", "daemon off;"]