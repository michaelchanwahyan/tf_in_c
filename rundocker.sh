#!/bin/sh
clear
docker rm -f tf_playground
docker run -v /app:/app \
           -dt \
           --name=tf_playground \
           --memory=4g \
           tf_playground:latest \
           /usr/bin/bash
