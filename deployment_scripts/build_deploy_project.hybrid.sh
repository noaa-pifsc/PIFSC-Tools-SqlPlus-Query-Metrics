#! /bin/sh

root_directory="/c"

# change directory to the working directory for the hybrid scenario
cd $root_directory/docker/sqlplus-query-metrics-hybrid/docker

# build and execute the docker container for the hybrid scenario
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d  --build

# notify the user that the container has finished executing
echo "The docker container for the hybrid scenario has finished executing"

# do not close the shell script window so the user can see the execution has completed
read
