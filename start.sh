#!/bin/bash

echo "Starting Salamander Tracker..."

# Start the Node.js backend server
echo "Starting backend server..."
cd /app/server
node server.js &

# Start the Next.js frontend
echo "Starting frontend..."
cd /app/frontend
echo "Current directory: $(pwd)"
echo "Files in current directory:"
ls -la
echo "Package.json contents:"
cat package.json
npm start &

# Wait for both processes
wait 