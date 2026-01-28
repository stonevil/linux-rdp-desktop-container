#!/usr/bin/env bash

if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi

echo "Stop and delete container"
podman stop rdek
podman rm -f rdek

echo "Delete container image"
podman image rm rdek

echo "Build container"
# add this option to build command to make container even smaller: --squash-all
podman build --rm --tag rdek -f Dockerfile.openbox -t rdek .
