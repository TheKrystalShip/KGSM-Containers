#!/bin/bash -ex

# KGSM Abiotic Factor Dedicated Server entrypoint script

export SERVER_HOME="${SERVER_HOME:-/opt/abioticfactor}"

export BACKUPS_DIR="$SERVER_HOME/backups"
export INSTALL_DIR="$SERVER_HOME/install"
export LOGS_DIR="$SERVER_HOME/logs"
export SAVES_DIR="${SERVER_HOME}/saves"
export TEMP_DIR="$SERVER_HOME/temp"

export LAUNCH_BIN="${INSTALL_DIR}/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe"

# Virtual display
rm -f /tmp/.X1-lock 2>&1
Xvfb :1 -screen 0 800x600x24 &

export DISPLAY=:1
export WINEDEBUG=-all

# Server specific config
SetUsePerfThreads="-useperfthreads "
if [[ $UsePerfThreads == "false" ]]; then
  SetUsePerfThreads=""
fi

SetNoAsyncLoadingThread="-NoAsyncLoadingThread "
if [[ $NoAsyncLoadingThread == "false" ]]; then
  SetNoAsyncLoadingThread=""
fi

MaxServerPlayers="${MaxServerPlayers:-8}"
Port="${Port:-7777}"
QueryPort="${QueryPort:-27015}"
ServerPassword="${ServerPassword:-password}"
SteamServerName="${SteamServerName:-KGSM}"
WorldSaveName="${WorldSaveName:-Cascade}"
AdditionalArgs="${AdditionalArgs:-}"

# Download/update game server
steamcmd \
  +@sSteamCmdForcePlatformType windows \
  +force_install_dir "$INSTALL_DIR" \
  +login anonymous \
  +app_update 2857200 validate \
  +quit

# Launch the game server
exec /usr/lib/wine/wine64 \
  "${LAUNCH_BIN}" \
  $SetUsePerfThreads \
  $SetNoAsyncLoadingThread \
  -MaxServerPlayers=$MaxServerPlayers \
  -PORT=$Port \
  -QueryPort=$QueryPort \
  -ServerPassword=$ServerPassword \
  -SteamServerName="$SteamServerName" \
  -WorldSaveName="$WorldSaveName" \
  -tcp \
  $AdditionalArgs
