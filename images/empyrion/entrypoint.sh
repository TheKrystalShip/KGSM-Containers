#!/bin/bash -ex

# KGSM Empyrion - Galactic Survival Dedicated Server entrypoint script

export SERVER_HOME="${SERVER_HOME:-/opt/empyrion}"

export BACKUPS_DIR="$SERVER_HOME/backups"
export INSTALL_DIR="$SERVER_HOME/install"
export LOGS_DIR="$SERVER_HOME/logs"
export SAVES_DIR="${SERVER_HOME}/saves"
export TEMP_DIR="$SERVER_HOME/temp"

export server_logfile="${LOGS_DIR}/dedicated_server.log"

# Virtual display
rm -f /tmp/.X1-lock 2>&1
Xvfb :1 -screen 0 800x600x24 &

export DISPLAY=:1
export WINEDLLOVERRIDES="mscoree,mshtml="

# Download/update game server
steamcmd \
  +@sSteamCmdForcePlatformType windows \
  +force_install_dir "$INSTALL_DIR" \
  +login anonymous \
  +app_update 530870 \
  validate \
  +quit

# CRITICAL: Empirion has permission issue with log files unless
# context is moved into game directory
cd "${INSTALL_DIR}/DedicatedServer" || {
  echo "Failed to move into ${INSTALL_DIR}/DedicatedServer, exiting"
  exit 1
}

# Ensure log file exists
touch "${server_logfile}"

# Tail the server's log file
tail -f "${server_logfile}" &

# Launch the game server
exec /usr/lib/wine/wine64 \
  ./EmpyrionDedicated.exe \
  -batchmode \
  -nographics \
  -logFile "${server_logfile}"
