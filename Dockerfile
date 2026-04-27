# Parent image
FROM python:3.13-slim-bookworm

LABEL description="SenNet API Docker Base Image"

# Output right away
ENV PYTHONUNBUFFERED=1

# Update dependencies and install build dependencies
RUN apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y curl gcc

# Install uWSGI using pip
RUN pip install --upgrade pip setuptools wheel && \
    pip install uwsgi && \
    rm -rf /root/.cache/pip

# Remove build dependencies
RUN apt-get purge -y gcc && \
    apt-get auto-remove -y

# Create the non-root codcc user
RUN groupadd codcc && \
    useradd -m -g codcc -s /bin/bash codcc

USER codcc
