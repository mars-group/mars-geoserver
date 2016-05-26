#!/bin/bash

# This builds the GeoServer and restarts the GeoServer docker container inside the websuite.
# It requires the websuite to be running and that both git repos are cloned to the same folder.

docker-compose build
cd ../marscloudinanutshell
docker-compose -f develop.yml stop geoserver
docker-compose -f develop.yml rm -f geoserver
docker-compose -f develop.yml up -d geoserver
