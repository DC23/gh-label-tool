#!/usr/bin/env bash
set -euo pipefail

DEST="$HOME/.local/bin"

usage() {
    echo "Usage: $0 [--dest <path>]"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dest)
            DEST="${2:?--dest requires a path}"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
done

# Check python3
if ! command -v python3 &>/dev/null; then
    echo "Error: python3 is not available. Install it with: sudo apt-get install python3"
    exit 1
fi

# Check / install dependencies
missing=()
for pkg in python3-requests python3-yaml; do
    if ! dpkg -s "$pkg" &>/dev/null 2>&1; then
        missing+=("$pkg")
    fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Installing missing dependencies: ${missing[*]}"
    sudo apt-get install -y "${missing[@]}"
fi

# Install the script
mkdir -p "$DEST"
cp "$(dirname "$0")/labels" "$DEST/labels"
chmod +x "$DEST/labels"

echo "Installed to $DEST/labels"

# Warn if dest is not on PATH
if [[ ":$PATH:" != *":$DEST:"* ]]; then
    echo "Warning: $DEST is not on your PATH."
    echo "Add this to your shell profile: export PATH=\"\$PATH:$DEST\""
fi
