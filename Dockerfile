            # Use a specific Ubuntu version (e.g., 22.04) for stability
            FROM ubuntu:22.04

            # Install Node.js 20 and pnpm with minimal dependencies
            RUN apt update && apt install -y curl \
                && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
                && apt install -y nodejs \
                && npm install -g corepack pnpm \
                && rm -rf /var/lib/apt/lists/*

            # Set working directory
            WORKDIR /app

            # Copy package files first for caching
            COPY package.json pnpm-lock.yaml ./

            # Install dependencies
            RUN pnpm install

            # Copy the rest of the project files
            COPY . .

            # Expose port 3000
            EXPOSE 3000

            # Build the frontend (Vue.js)
            RUN pnpm build

            # Start the application
            CMD ["pnpm", "dev"]
