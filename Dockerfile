FROM node:20.18.0

# Set working directory
WORKDIR /app/medusa

# Copy package.json and install dependencies
COPY package.json .
RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean
#RUN npm install -g npm@latest
RUN npm install -g @medusajs/medusa-cli
RUN npm install

# Copy the rest of the application files
COPY . .

# Run database migration
RUN npx medusa db:migrate

# Start the Medusa server in development mode
CMD ["npx", "medusa", "develop"]
