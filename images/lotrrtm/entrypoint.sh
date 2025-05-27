#!/bin/bash -ex

# KGSM Lord of the Rings - Return to Moria Dedicated Server entrypoint script

export SERVER_HOME="${SERVER_HOME:-/opt/lotrrtm}"

export BACKUPS_DIR="$SERVER_HOME/backups"
export INSTALL_DIR="$SERVER_HOME/install"
export LOGS_DIR="$SERVER_HOME/logs"
export SAVES_DIR="${SERVER_HOME}/saves"
export TEMP_DIR="$SERVER_HOME/temp"

# Virtual display
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix

rm -f /tmp/.X1-lock 2>&1
Xvfb :1 -screen 0 800x600x24 &

export DISPLAY=:1

if [ -f "${INSTALL_DIR}/Binaries/Win64/MoriaServer-Win64-Shipping.bak" ]; then
  echo "[entrypoint] Restoring patched MoriaServer-Win64-Shipping.exe for steam validation"
  rm -f "${INSTALL_DIR}/Binaries/Win64/MoriaServer-Win64-Shipping.exe"
  mv "${INSTALL_DIR}/Binaries/Win64/MoriaServer-Win64-Shipping.bak" "${INSTALL_DIR}/Binaries/Win64/MoriaServer-Win64-Shipping.exe"
fi

steamcmd \
  +@sSteamCmdForcePlatformType windows \
  +force_install_dir "${INSTALL_DIR}" \
  +login anonymous \
  +app_update 3349480 validate \
  +quit

patcher \
  "${INSTALL_DIR}/Binaries/Win64/MoriaServer-Win64-Shipping.exe"

exec /usr/lib/wine/wine64 \
  "${INSTALL_DIR}/Binaries/Win64/MoriaServer-Win64-Shipping.exe" \
  Moria \
  &>"${LOGS_DIR}/wine.log"
