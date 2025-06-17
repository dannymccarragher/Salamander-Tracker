# Salamander Tracker - Containerized Setup

This setup containerizes both the Java backend (centroid-finder) and Next.js frontend (salamander-next) into a single Docker container.

## Architecture

The containerized application includes:
- **Java Backend**: Maven-based image processing application
- **Node.js API Server**: Express server running on port 3000
- **Next.js Frontend**: React application running on port 3001
- **FFmpeg**: For video processing capabilities

## Prerequisites

- Docker
- Docker Compose

## Quick Start

### Using Docker Compose (Recommended)

1. **Build and run the application:**
   ```bash
   docker-compose up --build
   ```

2. **Access the application:**
   - Frontend: http://localhost:3001
   - Backend API: http://localhost:3000

3. **Stop the application:**
   ```bash
   docker-compose down
   ```

### Using Docker directly

1. **Build the image:**
   ```bash
   docker build -t salamander-tracker .
   ```

2. **Run the container:**
   ```bash
   docker run -p 3000:3000 -p 3001:3001 \
     -v $(pwd)/videos:/videos \
     -v $(pwd)/results:/results \
     salamander-tracker
   ```

## Volume Mounts

The container uses the following volume mounts:
- `./videos:/videos` - Input videos directory
- `./results:/results` - Output results directory

## Environment Variables

- `VIDEO_PATH=/videos` - Path to input videos
- `RESULT_PATH=/results` - Path to output results
- `NODE_ENV=production` - Node.js environment

## Ports

- **3000**: Node.js backend API
- **3001**: Next.js frontend

## Development

### Rebuilding after changes

If you make changes to the code, rebuild the image:

```bash
docker-compose build --no-cache
docker-compose up
```

### Viewing logs

```bash
docker-compose logs -f
```

### Accessing the container shell

```bash
docker-compose exec salamander-tracker bash
```

## Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure ports 3000 and 3001 are not in use
2. **Permission issues**: Make sure the videos and results directories exist and are writable
3. **Memory issues**: The Java application may require significant memory for video processing

### Checking container status

```bash
docker-compose ps
```

### Viewing resource usage

```bash
docker stats
```

## File Structure in Container

```
/app/
├── Processor/          # Java backend
│   ├── target/        # Compiled Java classes
│   └── src/           # Java source code
├── server/            # Node.js API server
├── frontend/          # Next.js application
│   ├── .next/         # Built Next.js app
│   └── public/        # Static assets
├── videos/            # Input videos (mounted)
├── results/           # Output results (mounted)
└── start.sh           # Startup script
```

## Performance Considerations

- The container includes both Java and Node.js runtimes, making it larger than single-service containers
- Consider using separate containers for each service if you need to scale them independently
- The multi-stage build optimizes the final image size by excluding build dependencies 