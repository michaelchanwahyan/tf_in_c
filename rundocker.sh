#!/bin/sh
clear
docker rm -f tf_playground
docker run -p 9999:9999 \
           -p 9090:9090 \
           -v /app:/app \
           -dt \
           --name=tf_playground \
           --memory=4g \
           tf_playground:latest \
           /usr/bin/bash
