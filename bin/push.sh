#!/usr/bin/env bash

set -e

if [[ -n "${DOCKER_USER}" && -n "${DOCKER_PASS}" ]]
then
    echo "${DOCKER_PASS}" | docker login -u "${DOCKER_USER}" --password-stdin
else
    docker login
fi
docker push ${IMAGE_REPO}
