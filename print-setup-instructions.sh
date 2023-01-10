#!/bin/bash

# Get location of this file
# Taken from https://stackoverflow.com/a/246128/1337463
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

echo "Add the following lines to your ~/.bash_aliases file:"
echo

echo "########################## supercloud-tools setup ###########################
export PATH=\"$SCRIPT_DIR/bin:\$PATH\"
export PATH=\"$SCRIPT_DIR/scripts:\$PATH\"

# You can optionally add multiple locations to CONDA_PACK_ENV_PATH
export CONDA_PACK_ENV_PATH=\"/home/gridsan/groups/ccg/env-tars/conda-pack:\$CONDA_PACK_ENV_PATH\"
# export CONDA_PACK_ENV_PATH=\"/home/gridsan/groups/ewsc/env-tars/conda-pack:\$CONDA_PACK_ENV_PATH\"
#############################################################################"
