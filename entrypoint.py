#!/usr/bin/python

from microservice.microservice import microservice

import requests

NAME = "geoserver"

def check_status():
    status = "OUT_OF_SERVICE"
    try:
        response = requests.get("http://" + NAME + ":8080/geoserver")
        if 200 <= response.status_code < 300:
            status = "UP"
    except requests.exceptions.ConnectionError:
        pass #Status will be OUT_OF_SERVICE
    return status

microservice(
    name=NAME,
    entrypoint = ["/startup.sh"],
    status_checker = check_status
)