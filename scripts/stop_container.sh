#!/bin/bash

# Stop and delete the running container
container=$(docker ps -q | head -n 1)
docker rm -f "$container"

