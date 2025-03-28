#!/bin/bash -ex

# KGSM V Rising Dedicated Server entrypoint script

export SERVER_HOME="${SERVER_HOME:-/opt/vrising}"

export BACKUPS_DIR="$SERVER_HOME/backups"
export INSTALL_DIR="$SERVER_HOME/install"
export LOGS_DIR="$SERVER_HOME/logs"
export SAVES_DIR="${SERVER_HOME}/saves"
export TEMP_DIR="$SERVER_HOME/temp"

# Virtual display
rm -f /tmp/.X1-lock 2>&1
Xvfb :1 -screen 0 800x600x24 &

export DISPLAY=:1
export WINEDEBUG=-all

if [ -z "$SERVERNAME" ]; then
  SERVERNAME="TheKrystalShip"
fi

override_savename=""
if [[ -n "$WORLDNAME" ]]; then
  override_savename="-saveName $WORLDNAME"
fi

game_port=""
if [[ -n $GAMEPORT ]]; then
  game_port=" -gamePort $GAMEPORT"
fi

query_port=""
if [[ -n $QUERYPORT ]]; then
  query_port=" -queryPort $QUERYPORT"
fi

# Download with SteamCMD
steamcmd \
  +@sSteamCmdForcePlatformType windows \
  +force_install_dir "${INSTALL_DIR}" \
  +login anonymous \
  +app_update 1829350 validate \
  +quit

#if [ ! -f "${INSTALL_DIR}/Settings/ServerGameSettings.json" ]; then
#  echo "${INSTALL_DIR}/Settings/ServerGameSettings.json not found. Copying default file."
#  cp "${INSTALL_DIR}/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json" "${INSTALL_DIR}/Settings/" 2>&1
#fi

#if [ ! -f "${INSTALL_DIR}/Settings/ServerHostSettings.json" ]; then
#  echo "${INSTALL_DIR}/Settings/ServerHostSettings.json not found. Copying default file."
#  cp "${INSTALL_DIR}/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json" "${INSTALL_DIR}/Settings/" 2>&1
#fi

exec /usr/lib/wine/wine64 \
  "${INSTALL_DIR}/VRisingServer.exe" \
  -persistentDataPath "${SAVES_DIR}" \
  -serverName "$SERVERNAME" \
  $override_savename \
  $game_port \
  $query_port #  -logFile "${LOGS_DIR}/current.log" \
