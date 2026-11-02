# Modified for SHAI. Original work by Tecnativa and contributors.
FROM haproxy:3.4.2-alpine@sha256:0878b11eb64c433be1b0f578a584b8aca12f6caaa64c8f239b8b556c0dd5eeeb

LABEL org.opencontainers.image.title="SHAI engine observer" \
      org.opencontainers.image.description="Read-only Docker Engine API policy boundary for SHAI monitoring" \
      org.opencontainers.image.source="https://github.com/RyanHamze/docker-socket-proxy" \
      org.opencontainers.image.licenses="Apache-2.0" \
      com.shai.managed="true" \
      com.shai.service="engine-observer"

EXPOSE 2375
ENV ALLOW_RESTARTS=0 \
    ALLOW_STOP=0 \
    ALLOW_START=0 \
    AUTH=0 \
    BUILD=0 \
    COMMIT=0 \
    CONFIGS=0 \
    CONTAINERS=1 \
    DISABLE_IPV6=0 \
    DISTRIBUTION=0 \
    EVENTS=1 \
    EXEC=0 \
    GRPC=0 \
    IMAGES=0 \
    INFO=1 \
    LOG_LEVEL=info \
    NETWORKS=0 \
    NODES=0 \
    PING=1 \
    PLUGINS=0 \
    POST=0 \
    SECRETS=0 \
    SERVICES=0 \
    SESSION=0 \
    SOCKET_PATH=/var/run/docker.sock \
    SWARM=0 \
    SYSTEM=0 \
    TASKS=0 \
    VERSION=1 \
    VOLUMES=0
COPY docker-entrypoint.sh /usr/local/bin/
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg.template
RUN touch /var/lib/haproxy/server-state
USER root
CMD ["haproxy", "-f", "/tmp/haproxy.cfg"]
