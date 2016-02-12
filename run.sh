#!/bin/bash
docker-compose stop
docker-compose rm -v -f

# build images
docker-compose build

# start images
docker-compose up -d

#enable imageMosaic
#psql -h 192.168.99.100 -U docker -d gis -f createmeta.sql
#psql -h 192.168.99.100 -U docker -d gis -f add_osm.sql
