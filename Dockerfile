ARG IMAGE=python:3.10-slim

# Initial build stage for installing pip depencies into /venv
FROM $(IMAGE) as build

USER root
WORKDIR /app

# Copy Files
COPY src src
COPY resources resources
COPY Makefile Makefile
COPY pyproject.toml pyproject.toml
COPY requirements.txt requirements.txt
COPY bin bin

# OpenShift permissions fix
RUN mkdir -p /app/metrics \
    && chgrp -R 0 /app \
    && chmod -R g=u /app \
    && chmod +x bin/*

USER 1001

RUN make deps-prod
RUN make version.txt
RUN cat version.txt
RUN make build-app
ENTRYPOINT ["/app/bin/start.sh"]