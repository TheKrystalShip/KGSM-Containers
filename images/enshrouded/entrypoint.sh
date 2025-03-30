#!/bin/bash -ex

# KGSM Enshrouded Dedicated Server entrypoint script

export SERVER_HOME="${SERVER_HOME:-/opt/enshrouded}"

export BACKUPS_DIR="$SERVER_HOME/backups"
export INSTALL_DIR="$SERVER_HOME/install"
export LOGS_DIR="$SERVER_HOME/logs"
export SAVES_DIR="${SERVER_HOME}/saves"
export TEMP_DIR="$SERVER_HOME/temp"

# Virtual display
rm -f /tmp/.X1-lock 2>&1
Xvfb :1 -screen 0 800x600x24 &

export DISPLAY=:1
export WINEDLLOVERRIDES="mscoree=d"

wineboot --init /nogui
winetricks corefonts
winetricks sound=disabled
winetricks -q --force vcrun2022
wine winecfg -v win10
rm -rf /home/steam/.cache

# Download/update game server
steamcmd \
  +@sSteamCmdForcePlatformType windows \
  +force_install_dir "$INSTALL_DIR" \
  +login anonymous \
  +app_update 2278520 validate \
  +quit

# Launch the game server
exec /usr/lib/wine/wine64 \
  "${INSTALL_DIR}/enshrouded_server.exe"
