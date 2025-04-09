# api-base-image

The docker image to be used as the base/parent image for the various SenNet APIs. The current version is based on Alpine Linux 3.21 and has Python 3.11 preinstalled.

## Building
To build the image:
````sh
# Replace {VERSION} with the current version
docker build --platform=linux/amd64 --provenance=true --sbom=true --tag sennet/api-base-image:{VERSION} .
````

Then publish it to the DockerHub:
````sh
# Replace {VERSION} with the current version
docker login
docker push sennet/api-base-image:{VERSION}
````
