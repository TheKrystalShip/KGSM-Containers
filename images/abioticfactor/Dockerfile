# KGSM Dockerfile for Abiotic Factor Dedicated Server
# This file is based on Pleut/abiotic-factor-linux-docker (https://github.com/Pleut/abiotic-factor-linux-docker)
# with modifications done to allow integration with KGSM.

# Starter image based on SteamCMD
FROM steamcmd/steamcmd:debian

LABEL org.opencontainers.image.source=https://github.com/TheKrystalShip/KGSM-Containers
LABEL org.opencontainers.image.authors="cristian.moraru@live.com"

# Port mapping
EXPOSE 7777/udp 27015/udp

# Build vars (non-persistent)
ARG DEBIAN_FRONTEND=noninteractive

# Environment variables (persistent)
ENV USER=kgsm \
  HOME=/home/kgsm \
  SERVER_HOME=/opt/abioticfactor

# Create user and necessary directories
RUN useradd -m -d ${HOME} ${USER} \
  && mkdir -p ${SERVER_HOME}/{backups,install,logs,saves,temp} \
  && chown -R ${USER}:${USER} ${SERVER_HOME} \
  && mkdir -p /tmp/.X11-unix \
  && chown -R root:root /tmp/.X11-unix \
  && chmod 1777 /tmp/.X11-unix

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

# Copy entrypoint with ownership and permissions
COPY --chown=${USER}:${USER} --chmod=0755 ./abioticfactor.manage.sh /opt/abioticfactor/abioticfactor.manage.sh

# Set working directory and switch to non-root user
WORKDIR ${SERVER_HOME}
USER ${USER}

ENTRYPOINT ["/opt/abioticfactor/abioticfactor.manage.sh"]
CMD ["--start"]