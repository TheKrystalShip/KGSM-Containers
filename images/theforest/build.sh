#!/usr/bin/env bash

local_image="theforest"
remote_image="ghcr.io/thekrystalship/${local_image}"

echo "Building ${local_image}..."
docker build -t "${local_image}" .

echo "Tagging ${local_image} image..."
docker image tag "${local_image}" "${remote_image}"

if [[ "$1" == "--push" ]]; then
  echo "Pushing ${remote_image}..."
  docker push "${remote_image}"
fi
