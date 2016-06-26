#!/usr/bin/env bash
# https://forums.docker.com/t/consistently-out-of-disk-space-in-docker-beta/9438/4
# remove untagged images
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images --filter dangling=true -q) # remove unused volumes
# remove stopped + exited containers, I skip Exit 0 as I have old scripts using data containers.
docker rm -v $(docker ps -a | grep "Exit [1-255]" | awk '{ print $1 }')