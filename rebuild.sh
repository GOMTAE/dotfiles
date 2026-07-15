#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
DARWIN_REBUILD="$(command -v darwin-rebuild)"
exec sudo "$DARWIN_REBUILD" switch --flake ~/.dotfiles#mac
