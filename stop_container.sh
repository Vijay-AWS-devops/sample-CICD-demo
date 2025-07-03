#!/bin/bash
set -e

#stop the running container if any
Container_id=$(docker ps | awk -F " " '{print $1}')

docker rm -f $Container_id
