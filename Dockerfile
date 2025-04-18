# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# 1. Copy critical files first (better caching)
COPY package.json .
COPY package-lock.json* .
COPY vite.config.ts .
COPY tailwind.config.js .
COPY postcss.config.js .
COPY tsconfig.json .
COPY index.html .

# 2. Install dependencies
RUN npm install --legacy-peer-deps
RUN npm install -D typescript  # Explicitly install TS

# 3. Copy remaining files
COPY public ./public
COPY src ./src

# 4. Build (Vite handles TS compilation)
RUN npm run build

# Stage 2: Production
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "run", "--host=0.0.0.0", "--port=80", "daemon off;"]