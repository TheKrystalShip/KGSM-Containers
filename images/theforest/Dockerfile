# KGSM Dockerfile for The Forest Dedicated Server
# This file is based on jonakoudijs/docker-forest (https://github.com/jonakoudijs/docker-forest)
# with modifications done to allow integration with KGSM.

# Starter image based on SteamCMD
FROM steamcmd/steamcmd:debian

LABEL org.opencontainers.image.source=https://github.com/TheKrystalShip/KGSM-Containers
LABEL org.opencontainers.image.authors="cristian.moraru@live.com"

# Port mapping
EXPOSE 8766/udp 8766/tcp 27015/udp 27015/tcp 27016/udp 27016/tcp

# Build vars (non-persistent)
ARG DEBIAN_FRONTEND=noninteractive

# Environment variables (persistent)
ENV USER=kgsm \
  HOME=/home/kgsm \
  SERVER_HOME=/opt/theforest \
  ENTRYPOINT=/opt/theforest/entrypoint.sh

# Create user and necessary directories
RUN useradd -m -d ${HOME} ${USER} \
  && mkdir -p ${SERVER_HOME}/{backups,install,logs,saves,temp} \
  && chown -R ${USER}:${USER} ${SERVER_HOME} \
  && mkdir -p /tmp/.X11-unix \
  && chown -R root:root /tmp/.X11-unix \
  && chmod 1777 /tmp/.X11-unix

# Declare volumes
VOLUME [${SERVER_HOME}]

# Install dependencies and clean up
RUN apt-get update \
  && apt-get install \
  -y \
  --no-install-recommends \
  --no-install-suggests \
  locales \
  xvfb \
  wine64 \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Copy server config
COPY --chown=${USER}:${USER} --chmod=0655 ./server.cfg ${SERVER_HOME}

# Copy entrypoint with ownership and permissions
COPY --chown=${USER}:${USER} --chmod=0755 ./entrypoint.sh ${ENTRYPOINT}

# Set working directory and switch to non-root user
WORKDIR ${SERVER_HOME}
USER ${USER}

ENTRYPOINT ${ENTRYPOINT}
