#!/usr/bin/env bash

local_image="<game-name>"
remote_image="ghcr.io/thekrystalship/${local_image}"

echo "Building ${local_image}..."
docker build -t "${local_image}" .

echo "Tagging ${local_image} image..."
docker image tag "${local_image}" "${remote_image}"
