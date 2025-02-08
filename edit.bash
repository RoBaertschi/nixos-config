#!/usr/bin/env bash
set -e

nvim .
sudo nixos-rebuild switch --flake /home/robin/nixos-config/#default
COMMIT_MESSAGE="$(nixos-rebuild list-generations --json | jq --raw-output 'map(select(.current)) | .[0] | "Generation \(.generation)\ncreated at: \(.date)\nnixos: \(.nixosVersion)\nkernel: \(.kernelVersion)"')"
git add .
git commit -m "$COMMIT_MESSAGE"
