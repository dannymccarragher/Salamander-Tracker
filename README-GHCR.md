# Salamander Tracker - GitHub Container Registry

This document explains how to use the Salamander Tracker Docker image from GitHub Container Registry (GHCR).

## Using the GHCR Image

### Prerequisites

- Docker installed on your system
- Docker Compose (optional, for easier deployment)

### Quick Start

1. **Pull the image:**
   ```bash
   docker pull ghcr.io/YOUR_USERNAME/salamander-tracker:latest
   ```

2. **Run the container:**
   ```bash
   docker run -p 3000:3000 -p 3001:3001 \
     -v $(pwd)/videos:/videos \
     -v $(pwd)/results:/results \
     ghcr.io/YOUR_USERNAME/salamander-tracker:latest
   ```

### Using Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  salamander-tracker:
    image: ghcr.io/YOUR_USERNAME/salamander-tracker:latest
    ports:
      - "3000:3000"  # Node.js backend API
      - "3001:3001"  # Next.js frontend
    volumes:
      - ./videos:/videos
      - ./results:/results
    environment:
      - VIDEO_PATH=/videos
      - RESULT_PATH=/results
      - NODE_ENV=production
    restart: unless-stopped
```

Then run:
```bash
docker-compose up
```

## Available Tags

- `latest` - Latest build from main branch
- `main` - Latest build from main branch
- `v1.0.0` - Specific version tags
- `sha-abc123` - Build from specific commit

## Accessing the Application

- **Frontend**: http://localhost:3001
- **Backend API**: http://localhost:3000

## Volume Mounts

- `./videos:/videos` - Input videos directory
- `./results:/results` - Output results directory

## Environment Variables

- `VIDEO_PATH=/videos` - Path to input videos
- `RESULT_PATH=/results` - Path to output results
- `NODE_ENV=production` - Node.js environment

## Manual Build and Push

If you want to manually build and push to GHCR:

1. **Login to GHCR:**
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin
   ```

2. **Build the image:**
   ```bash
   docker build -t ghcr.io/YOUR_USERNAME/salamander-tracker:latest .
   ```

3. **Push to GHCR:**
   ```bash
   docker push ghcr.io/YOUR_USERNAME/salamander-tracker:latest
   ```

## GitHub Actions

The repository includes a GitHub Actions workflow (`.github/workflows/docker-publish.yml`) that automatically:

- Builds the Docker image on push to main/master branch
- Pushes to GHCR with appropriate tags
- Handles version tags and commit SHAs
- Uses GitHub's built-in cache for faster builds

## Troubleshooting

### Permission Issues

If you get permission errors when pulling from GHCR:

1. Make sure the repository is public, or
2. Use a Personal Access Token with `read:packages` scope

### Image Not Found

- Check that the image name matches your GitHub username and repository name
- Ensure the image has been built and pushed successfully
- Verify the tag you're trying to pull exists

### Port Conflicts

- Make sure ports 3000 and 3001 are not in use on your host machine
- Change the port mappings in docker-compose.yml if needed

## Security

- The GHCR image is built from the source code in this repository
- No sensitive data is included in the image
- Environment variables should be set at runtime, not build time
- The image runs as a non-root user for security 