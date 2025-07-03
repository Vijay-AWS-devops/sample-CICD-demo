#!/bin/bash
set -e
# Stop and remove the first running container (if any)
container_id=$(docker ps -q | head -n 1)
docker rm -f "$container_id"
