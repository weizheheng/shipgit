
#!/bin/bash

REPO_DIR="$(dirname $0)"
INSTALL_INTO="/usr/local/bin"
EXEC_FILES="shipgit"
SCRIPT_FILES="shipgit-init shipgit-feature shipgit-hotfix shipgit-release shipgit-update"

echo "Uninstalling shipgit from $INSTALL_INTO"

if [ -d "$INSTALL_INTO" ] ; then
    for script_file in $SCRIPT_FILES $EXEC_FILES ; do
        echo "rm -vf $INSTALL_INTO/$script_file"
        rm -vf "$INSTALL_INTO/$script_file"
    done
else
    echo "The '$INSTALL_INTO' directory was not found."
fi
