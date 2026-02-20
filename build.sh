#!/usr/bin/env bash

set -e

# get the version passed in as an argument
VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

docker build --platform=linux/amd64 --provenance=true --sbom=true --tag sennet/api-base-image:${VERSION} .
