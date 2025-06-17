# Multi-stage build for Salamander Tracker
# Stage 1: Build Java backend
FROM maven:3.8.4-openjdk-17 AS java-builder

WORKDIR /app
COPY centroid-finder/Processor/ ./Processor/
WORKDIR /app/Processor
RUN mvn clean package -DskipTests

# Stage 2: Build Next.js frontend
FROM node:20-slim AS frontend-builder

WORKDIR /app
COPY salamander-next/package*.json ./
RUN npm install

COPY salamander-next/ ./
RUN npm run build

# Stage 3: Final runtime image
FROM node:20-slim

# Install Java, ffmpeg, and other dependencies
RUN apt-get update && \
    apt-get install -y \
    openjdk-17-jdk \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Java backend
COPY --from=java-builder /app/Processor/target/ ./Processor/target/
COPY centroid-finder/Processor/src/ ./Processor/src/
COPY centroid-finder/Processor/pom.xml ./Processor/

# Copy Node.js backend (copy all files first, then install)
COPY centroid-finder/server/ ./server/
WORKDIR /app/server
RUN npm install --omit=dev

# Create frontend directory and copy files
WORKDIR /app
RUN mkdir -p frontend
COPY salamander-next/package*.json ./frontend/
COPY --from=frontend-builder /app/.next ./frontend/.next
COPY --from=frontend-builder /app/public ./frontend/public

# Install frontend dependencies
WORKDIR /app/frontend
RUN npm install --omit=dev

# Create necessary directories
WORKDIR /app
RUN mkdir -p /videos /results

# Environment variables
ENV VIDEO_PATH=/videos
ENV RESULT_PATH=/results
ENV NODE_ENV=production

# Expose ports
EXPOSE 3000 3001

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Set the startup command
CMD ["/app/start.sh"] 