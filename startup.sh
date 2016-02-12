#!/bin/sh
service rpcbind start
mount 141.22.29.7:/volume5/GISData /opt/geoserver/data_dir

/opt/geoserver/bin/startup.sh
