#!/bin/bash

docker-compose build
cd ../marscloudinanutshell
docker-compose stop geoserver
docker-compose rm -f geoserver
docker-compose up -d geoserver
