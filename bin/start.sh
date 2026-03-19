#!/usr/bin/env bash
set -e

echo "Starting app..."

# Optional script
if [ -f "$HOME/create_keytab.sh" ]; then
  bash $HOME/create_keytab.sh
fi

make run-prod