FROM node:20.18.0

# Set working directory
WORKDIR /app/medusa

# Copy package.json file
COPY package.json .

# Update package lists and install Python 3
RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean

# Install latest npm and Medusa CLI globally
RUN npm install -g npm@latest
RUN npm install -g @medusajs/medusa-cli@latest

# Install dependencies from package.json
RUN npm install --loglevel=error

# Copy the rest of the application files
COPY . .

# Set entrypoint to start the Medusa development server
ENTRYPOINT ["./develop.sh", "develop"]
