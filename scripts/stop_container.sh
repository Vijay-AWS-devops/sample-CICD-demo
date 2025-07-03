#!/bin/bash

# Get the container ID of the latest running container
LATEST_CONTAINER=$(docker ps -q --latest)

# Check if a container was found
if [ -n "$LATEST_CONTAINER" ]; then
    echo "Removing latest running container: $LATEST_CONTAINER"
    sudo docker rm -f "$LATEST_CONTAINER"
else
    echo "No running containers found."
fi
