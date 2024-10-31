# Use the official Node.js image as a base
FROM node:20

# Set environment variables for Medusa and databases
ENV MEDUSA_BACKEND_URL=https://medusa1-medusa-project.knjmqz.easypanel.host:9000
ENV DATABASE_URL=postgres://postgres:medusadb@postgres:5432/medusa1?sslmode=require&rejectUnauthorized=false
ENV REDIS_URL=redis://redis:6379

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

# Run migrations and create user if necessary
CMD ["sh", "-c", "
    # Run migrations if not already applied
    npx medusa db:migrate || echo 'Migrations already applied';
    
    # Create admin user if it doesn't already exist
    if ! npx medusa user -l | grep -q 'admin@medusa-test.com'; then
        npx medusa user -e admin@medusa-test.com -p supersecret;
    else
        echo 'Admin user already exists';
    fi;
    
    # Start the Medusa server
    npx medusa develop
"]
