#!/bin/bash
set -e

# Stop and remove the running container
container_id=$(docker ps -q)
if [ -n "$container_id" ]; then
  docker rm -f "$container_id"
fi
