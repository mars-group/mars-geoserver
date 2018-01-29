#!/bin/bash

# Builds the Geoserver docker image, pushes the image to Nexus and restarts the pod.

DOCKER_REGISTRY="nexus.informatik.haw-hamburg.de"
SERVIE_NAME="geoserver"

docker build -t $DOCKER_REGISTRY/$SERVIE_NAME:dev --no-cache .
docker push $DOCKER_REGISTRY/$SERVIE_NAME:dev

kubectl -n mars-mars-beta delete pod $(kubectl -n mars-mars-beta get pod |grep geoserver |awk '{print $1;}') --force
