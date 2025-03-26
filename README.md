# api-base-image

The docker image to be used as the base/parent image for the various SenNet APIs. The current version is based on the Red Hat Universal Base Image 9.4 and has Python 3.11 installed. Use the 
specific Python version when issuing Python commands (i.e. python3.11 -m pip install ...)
````
docker build -t sennet/api-base-image:1.2.0 .
````

Then publish it to the DockerHub:
````
docker login
docker push sennet/api-base-image:1.2.0
````

## Python version
The Python version in the image can be overridden using:
```bash
# docker CLI
--build-arg PYTHON_VERSION=3.12

# docker-compose
build:
    args:
    - PYTHON_VERSION=3.12
```
