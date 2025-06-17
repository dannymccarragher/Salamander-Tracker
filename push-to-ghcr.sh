#!/bin/bash

# Script to build and push Salamander Tracker to GitHub Container Registry

# Configuration
GITHUB_USERNAME=${GITHUB_USERNAME:-"YOUR_USERNAME"}
REPO_NAME=${REPO_NAME:-"salamander-tracker"}
TAG=${TAG:-"latest"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Building and pushing Salamander Tracker to GHCR${NC}"
echo "Username: $GITHUB_USERNAME"
echo "Repository: $REPO_NAME"
echo "Tag: $TAG"
echo ""

# Check if GITHUB_TOKEN is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}Error: GITHUB_TOKEN environment variable is not set${NC}"
    echo "Please set it with: export GITHUB_TOKEN=your_token_here"
    echo "You can create a token at: https://github.com/settings/tokens"
    exit 1
fi

# Login to GHCR
echo -e "${YELLOW}Logging in to GitHub Container Registry...${NC}"
echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to login to GHCR${NC}"
    exit 1
fi

# Build the image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build -t "ghcr.io/$GITHUB_USERNAME/$REPO_NAME:$TAG" .

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to build Docker image${NC}"
    exit 1
fi

# Push the image
echo -e "${YELLOW}Pushing image to GHCR...${NC}"
docker push "ghcr.io/$GITHUB_USERNAME/$REPO_NAME:$TAG"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully pushed to GHCR!${NC}"
    echo "Image: ghcr.io/$GITHUB_USERNAME/$REPO_NAME:$TAG"
    echo ""
    echo "To use this image:"
    echo "docker pull ghcr.io/$GITHUB_USERNAME/$REPO_NAME:$TAG"
    echo "docker run -p 3000:3000 -p 3001:3001 ghcr.io/$GITHUB_USERNAME/$REPO_NAME:$TAG"
else
    echo -e "${RED}Failed to push to GHCR${NC}"
    exit 1
fi 