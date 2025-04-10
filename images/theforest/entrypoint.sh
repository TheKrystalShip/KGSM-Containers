#!/bin/bash -ex

# KGSM The Forest Dedicated Server entrypoint script

export SERVER_HOME="${SERVER_HOME:-/opt/theforest}"

export BACKUPS_DIR="$SERVER_HOME/backups"
export INSTALL_DIR="$SERVER_HOME/install"
export LOGS_DIR="$SERVER_HOME/logs"
export SAVES_DIR="${SERVER_HOME}/saves"
export TEMP_DIR="$SERVER_HOME/temp"

# Virtual display
rm -f /tmp/.X1-lock 2>&1
Xvfb :1 -screen 0 800x600x24 &

export WINEDEBUG=-all
export WINEDLLOVERRIDES="mscoree,mshtml="
export DISPLAY=:1

# Download the application via steamcmd
steamcmd \
  +@sSteamCmdForcePlatformType windows \
  +force_install_dir "$INSTALL_DIR" \
  +login anonymous \
  +app_update 556450 \
  validate \
  +quit

# Launch the game server
exec /usr/lib/wine/wine64 \
  "${INSTALL_DIR}/TheForestDedicatedServer.exe" \
  -batchmode \
  -dedicated \
  -savefolderpath "${SAVES_DIR}" \
  -configfilepath "${SERVER_HOME}/server.cfg" \
