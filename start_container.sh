#!/bin/bash
set -e

#Pull the image from the docker
docker pull dockermvk18/sample-python-app

#Run the Docker image as a container
docker run -d -p 5000:5000 dockermvk18/sample-python-app
