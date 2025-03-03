#!/usr/bin/env bash
set -e

TYPE="switch"

if [ $1 = "boot" ]; then
  TYPE="boot"
fi

if [ $TYPE != "boot" ]; then
  nvim .
fi
git add .
sudo nixos-rebuild $TYPE --flake /home/robin/nixos-config/#wsl
COMMIT_MESSAGE="WSL: $(nixos-rebuild list-generations --json | jq --raw-output 'map(select(.current)) | .[0] | "Generation \(.generation)\ncreated at: \(.date)\nnixos: \(.nixosVersion)\nkernel: \(.kernelVersion)"')"
git commit -m "$COMMIT_MESSAGE"
git push
