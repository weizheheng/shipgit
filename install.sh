#!/bin/bash

REPO_DIR="$(dirname $0)"
INSTALL_INTO="/usr/local/bin"
EXEC_FILES="git-roll"
SCRIPT_FILES="git-roll-init git-roll-feature git-roll-hotfix git-roll-release"

for exec_file in $EXEC_FILES ; do
  echo "Installing $exec_file"
  install -v -m 0755 "$REPO_DIR/$exec_file" "$INSTALL_INTO"
done

for script_file in $SCRIPT_FILES ; do
  echo "Installing $script_file"
  install -v -m 0755 "$REPO_DIR/$script_file" "$INSTALL_INTO"
done
