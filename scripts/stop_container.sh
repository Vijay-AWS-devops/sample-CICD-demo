#!/bin/bash
set -e
# Stop the running container if any
container_id=$(docker ps -q)

if [ -n "$container_id" ]; then
  docker rm -f "$container_id"
  echo "Stopped and removed container: $container_id"
else
  echo "No running containers found."
fi
