#!/bin/bash

###############################################################################
# Setup global variables
# This script loads an environment from $CONDA_PACK_ENV_PATH.
# Environments are copied to /run/user/$UID/conda-envs/ where they are unpacked
# with conda pack. /run/user/$UID is a tmpfs filesystem, so the environments
# are deleted when all processes belong to $UID are terminated.
###############################################################################
readonly CONDA_PACK_ENV_PATH
readonly DST_ENV_DIR=/run/user/$UID/conda-envs
mkdir -p $DST_ENV_DIR
###############################################################################


###############################################################################
# Parse command line args
###############################################################################
USE_RANDOM_DST_NAME='false'
while getopts 'r' flag; do
  case "${flag}" in
    r) USE_RANDOM_DST_NAME='true' ;;
    *) echo "Usage: ./setup-env.sh [-r (random dst)] <env_name> "
       exit 1 ;;
  esac
done
readonly USE_RANDOM_DST_NAME

readonly ENV_NAME=${@:$OPTIND:1}

# Find environment in CONDA_PACK_ENV_PATH
SRC_ENV_PATH=''
for dir in $(echo $CONDA_PACK_ENV_PATH | tr ':' ' '); do
    if [ -f "$dir/$ENV_NAME.tar" ]; then
        SRC_ENV_PATH="$dir/$ENV_NAME.tar"
        break
    fi
done
readonly SRC_ENV_PATH

# Check that we actually found an environment.
if [ ! -f "$SRC_ENV_PATH" ]; then
  echo "Error: Could not find $ENV_NAME in CONDA_PACK_ENV_PATH."
  exit 1
fi
###############################################################################

###############################################################################
# Unpack src env to dst env 
###############################################################################

# Get destination environment name
if [[ $USE_RANDOM_DST_NAME == 'true' ]]; then
  readonly DST_ENV_PATH=$(TMPDIR=$DST_ENV_DIR mktemp -d -t $ENV_NAME-XXXXXXXX)
else
  readonly DST_ENV_PATH=$DST_ENV_DIR/$ENV_NAME
fi

# Untar environment to destination
mkdir -p $DST_ENV_PATH
echo "Unpacking $SRC_ENV_PATH to $DST_ENV_PATH ..."
tar -xf $SRC_ENV_PATH -C $DST_ENV_PATH
echo "Done unpacking."

# Cleanup prefixes
echo "Cleaning up prefixes..."
source $DST_ENV_PATH/bin/activate
conda-unpack
source deactivate
echo "Done cleaning up prefixes."
###############################################################################

# Return destination environment name
export DST_ENV_PATH
