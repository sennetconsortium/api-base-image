# Parent image
FROM python:3.11-alpine3.21

LABEL description="SenNet API Docker Base Image"

# Output right away
ENV PYTHONUNBUFFERED=1

# Update Python packages. We need temporary build dependencies to install uwsgi
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache --virtual .tmp-build-deps build-base linux-headers && \
    pip install --upgrade pip setuptools wheel && \
    pip install uwsgi && \
    apk del .tmp-build-deps

# Create the non-root codcc user
RUN addgroup codcc && \
    adduser -G codcc -D -H codcc

USER codcc
