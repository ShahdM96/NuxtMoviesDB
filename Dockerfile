# Use Ubuntu as base image and install Node.js 20
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y curl ca-certificates gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt install -y nodejs \
    && npm install -g corepack \
    && corepack enable \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files first for caching
COPY package.json pnpm-lock.yaml ./

# Install dependencies (pnpm will create node_modules in container)
RUN pnpm install

# Copy the rest of the project files (app code, etc.)
COPY . .

# Expose port 3000
EXPOSE 3000

# Build the frontend (Vue.js build step, ensures everything is compiled)
RUN pnpm build

# Start the application
CMD ["pnpm", "dev"]
