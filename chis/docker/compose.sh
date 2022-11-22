#!/bin/bash

composeFilePath=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

if [ "$1" == "init" ]; then
    docker-compose -p instant -f "$composeFilePath"/docker-compose.config.yml up -d

elif [ "$1" == "up" ]; then
    docker-compose -p instant -f "$composeFilePath"/docker-compose.yml up -d

elif [ "$1" == "down" ]; then
    docker-compose -p instant -f "$composeFilePath"/docker-compose.yml \
        -f "$composeFilePath"/docker-compose.config.yml stop

elif [ "$1" == "destroy" ]; then
    docker-compose -p instant -f "$composeFilePath"/docker-compose.yml \
        -f "$composeFilePath"/docker-compose.config.yml down
    docker volume rm instant_cchq-shared_files \
        instant_cchq-postgres-vol \
        instant_cchq-couch-vol \
        instant_cchq-redis-vol \
        instant_cchq-elasticsearch2-vol \
        instant_cchq-kafka-vol \
        instant_cchq-zookeeper-vol \
        instant_cchq-minio-conf \
        instant_cchq-minio-data

else
    echo "Valid options are: init, up, down, or destroy"
fi
