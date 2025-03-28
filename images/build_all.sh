#!/usr/bin/env bash

echo "Building all images..."

push=
if [[ "$1" == "--push" ]]; then
  push="--push"
fi

for dir in */; do
  if [[ -f "${dir}/build.sh" ]]; then
    cd "$dir" || continue
    ./build.sh $push
    cd ..
  fi
done

echo "Removing dangling images..."

docker image prune
