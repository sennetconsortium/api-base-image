ARG PYTHON_VERSION=3.11.11

# builder stage
FROM redhat/ubi9-minimal:9.5 AS builder

ARG PYTHON_VERSION

RUN microdnf -y upgrade && \
    microdnf install -y make gcc tar findutils openssl-devel bzip2-devel libffi-devel zlib-devel && \
    microdnf clean all

RUN curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xvzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure \
        --prefix=/opt/python/${PYTHON_VERSION} \
        --enable-shared \
        --enable-optimizations \
        LDFLAGS=-Wl,-rpath=/opt/python/${PYTHON_VERSION}/lib,--disable-new-dtags && \
    make && \
    make install && \
    microdnf clean all

# final stage
FROM redhat/ubi9-minimal:9.5
LABEL description="SenNet API Docker Base Image"

ARG PYTHON_VERSION
ARG HOST_GID=100006
ARG HOST_UID=100008

COPY --from=builder /opt/python/${PYTHON_VERSION} /opt/python/${PYTHON_VERSION}

ENV PATH="/opt/python/${PYTHON_VERSION}/bin:$PATH"

RUN microdnf -y upgrade && \
    python3 -m ensurepip && \
    python3 -V && \
    python3 -m pip install --no-cache --upgrade setuptools pip && \
    microdnf clean all

# create non-root codcc user
RUN groupadd -r -g ${HOST_GID} codcc && \
    useradd -r -u ${HOST_UID} -g ${HOST_GID} -m codcc

USER codcc
