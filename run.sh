#!/bin/bash
docker-compose stop

# build images
docker-compose build

# start images
docker-compose up -d
