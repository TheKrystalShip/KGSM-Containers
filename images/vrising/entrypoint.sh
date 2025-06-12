#!/bin/bash -ex

# KGSM V Rising Dedicated Server entrypoint script

# Set default environment variables
setup_environment() {
  export SERVER_HOME="${SERVER_HOME:-/opt/vrising}"
  export BACKUPS_DIR="${SERVER_HOME}/backups"
  export INSTALL_DIR="${SERVER_HOME}/install"
  export LOGS_DIR="${SERVER_HOME}/logs"
  export SAVES_DIR="${SERVER_HOME}/saves"
  export TEMP_DIR="${SERVER_HOME}/temp"
}

# Setup virtual display for Wine
setup_virtual_display() {
  rm -f /tmp/.X1-lock 2>&1
  Xvfb :1 -screen 0 800x600x24 &
  export DISPLAY=:1
  export WINEDEBUG=-all
}

# Install/update the server using SteamCMD
install_or_update_server() {
  steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir "${INSTALL_DIR}" \
    +login anonymous \
    +app_update 1829350 validate \
    +quit
}

# Setup the server configuration files
setup_server_config() {
  # Create settings directory if it doesn't exist
  if [[ ! -d "${SAVES_DIR}/Settings" ]]; then
    echo "Creating saves directory at ${SAVES_DIR}"
    mkdir -p "${SAVES_DIR}/Settings"
  fi

  # Check for ServerGameSettings.json and copy default if needed
  if [ ! -f "${SAVES_DIR}/Settings/ServerGameSettings.json" ]; then
    echo "${SAVES_DIR}/Settings/ServerGameSettings.json not found. Copying default file."
    cp "${INSTALL_DIR}/VRisingServer_Data/StreamingAssets/Settings/ServerGameSettings.json" "${SAVES_DIR}/Settings/" 2>&1
  fi

  # Check for ServerHostSettings.json and copy default if needed
  if [ ! -f "${SAVES_DIR}/Settings/ServerHostSettings.json" ]; then
    echo "${SAVES_DIR}/Settings/ServerHostSettings.json not found. Copying default file."
    cp "${INSTALL_DIR}/VRisingServer_Data/StreamingAssets/Settings/ServerHostSettings.json" "${SAVES_DIR}/Settings/" 2>&1
  fi
}


# Launch the server with prepared arguments
launch_server() {
  # shellcheck disable=SC2046
  exec /usr/lib/wine/wine64 "${INSTALL_DIR}/VRisingServer.exe" -persistentDataPath ${SAVES_DIR}
}

# Main execution
main() {
  setup_environment
  setup_virtual_display
  install_or_update_server
  setup_server_config
  launch_server
}

# Execute main function
main
