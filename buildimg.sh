#!/bin/sh
docker build -t tf_playground:latest ./
docker rmi   -f $(docker images -f "dangling=true" -q)
