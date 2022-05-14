
#!/bin/bash

REPO_DIR="$(dirname $0)"
INSTALL_INTO="/usr/local/bin"
EXEC_FILES="git-roll"
SCRIPT_FILES="git-roll-init git-roll-feature git-roll-hotfix git-roll-release"

echo "Uninstalling git-roll from $INSTALL_INTO"

if [ -d "$INSTALL_INTO" ] ; then
    for script_file in $SCRIPT_FILES $EXEC_FILES ; do
        echo "rm -vf $INSTALL_INTO/$script_file"
        rm -vf "$INSTALL_INTO/$script_file"
    done
else
    echo "The '$INSTALL_INTO' directory was not found."
fi
