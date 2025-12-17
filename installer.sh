#!/bin/bash

if [[ "$1" == "@" ]]; then
    shift
fi

SCRIPT_URL="https://raw.githubusercontent.com/xxphantom/jitsi-installer/refs/heads/main/install_jitsi.sh"
TEMP_SCRIPT=$(mktemp /tmp/jitsi_installer_XXXXXX.sh)

cleanup() {
    rm -f "$TEMP_SCRIPT" 2>/dev/null
}
trap cleanup EXIT

echo "Downloading Jitsi Meet installer..."
if ! curl -sL "$SCRIPT_URL" -o "$TEMP_SCRIPT"; then
    echo "Error: Failed to download installer script from $SCRIPT_URL"
    exit 1
fi

if [[ ! -s "$TEMP_SCRIPT" ]]; then
    echo "Error: Downloaded script is empty"
    exit 1
fi

chmod +x "$TEMP_SCRIPT"
exec bash "$TEMP_SCRIPT" "$@"
