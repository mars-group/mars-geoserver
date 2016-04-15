#!/bin/bash

docker-compose build
cd ../marscloudinanutshell
docker-compose -f develop.yml stop geoserver
docker-compose -f develop.yml rm -f geoserver
docker-compose -f develop.yml up -d geoserver
