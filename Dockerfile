# Use the official Node.js image as a base
FROM node:20

# Set environment variables for Medusa and databases
ENV MEDUSA_BACKEND_URL=http://localhost:9000
ENV DATABASE_URL=postgres://postgres:medusadb@postgres:5432/medusa1?sslmode=require&rejectUnauthorized=false
ENV REDIS_URL=redis://redis:6379
#ENV NODE_TLS_REJECT_UNAUTHORIZED=0  # Allows self-signed certificates

# Create a working directory
WORKDIR /app

# Copy only package.json and package-lock.json for efficient caching
COPY package*.json ./

# Install Medusa CLI for v2 globally and project dependencies
RUN npm install -g @medusajs/medusa-cli@latest && npm install

# Copy the rest of the project files
COPY . .

# Expose the Medusa port
EXPOSE 9000

# Run database migrations and start the Medusa server for v2
CMD ["sh", "-c", "npx medusa db:migrate && npx medusa user -e admin@medusa-test.com -p supersecret && npx medusa develop"]
