#!/bin/bash
docker-compose stop
docker-compose rm -v -f

# build images
docker-compose build

# start images
docker-compose up -d