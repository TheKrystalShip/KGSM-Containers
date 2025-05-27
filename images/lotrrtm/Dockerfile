# KGSM Dockerfile for Lord of the Rings - Return to Moria Dedicated Server
# This file is based on AndrewSav/moria-docker (https://github.com/AndrewSav/moria-docker)
# with modifications done to allow integration with KGSM.

# Go builder
FROM golang:1.24.1-bookworm AS tools-builder

COPY patcher patcher
RUN go build -C patcher
COPY healthcheck healthcheck
RUN go build -C healthcheck

# Starter image based on SteamCMD
FROM steamcmd/steamcmd:debian

# Port mapping
EXPOSE 7777/udp 27015/udp

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive \
  USER=kgsm \
  HOME=/home/kgsm \
  SERVER_HOME=/opt/lotrrtm \
  ENTRYPOINT=${SERVER_HOME}/entrypoint.sh

# Create user and necessary directories
RUN useradd -m -d ${HOME} ${USER} \
  && mkdir -p ${SERVER_HOME}/{backups,install,logs,saves,temp} \
  && chown -R ${USER}:${USER} ${SERVER_HOME}

# Declare volumes
VOLUME ["${SERVER_HOME}/backups", "${SERVER_HOME}/install", "${SERVER_HOME}/logs", "${SERVER_HOME}/saves", "${SERVER_HOME}/temp"]

# Install dependencies and clean up
RUN dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install \
  -y \
  --no-install-recommends \
  --no-install-suggests \
  vim \
  locales \
  xvfb \
  wine64 \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Copy tools
COPY --from=tools-builder --chmod=0755 /go/patcher/patcher /usr/local/bin/patcher
COPY --from=tools-builder --chmod=0755 /go/healthcheck/healthcheck /usr/local/bin/healthcheck

# Copy entrypoint with ownership and permissions
COPY --chown=${USER}:${USER} --chmod=0755 ./entrypoint.sh ${ENTRYPOINT}

# Set working directory and switch to non-root user
WORKDIR ${SERVER_HOME}
USER ${USER}

HEALTHCHECK --interval=1m --timeout=10s --start-period=5m --start-interval=15s --retries=2 CMD healthcheck localhost:7777

ENTRYPOINT $ENTRYPOINT
