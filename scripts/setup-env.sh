#!/bin/bash

###############################################################################
# Setup global variables
# Environments are copied to /run/user/$UID/conda-envs/ where they are unpacked
# with conda pack. /run/user/$UID is a tmpfs filesystem, so the environments
# are deleted when all processes belong to $UID are terminated.
###############################################################################
readonly SRC_ENV_DIR=/home/gridsan/groups/ccg/env-tars/conda-pack
readonly DST_ENV_DIR=/run/user/$UID/conda-envs
mkdir -p $DST_ENV_DIR
###############################################################################


###############################################################################
# Parse command line args
###############################################################################
RANDOM_NAME='false'
while getopts 'r' flag; do
  case "${flag}" in
    r) RANDOM_NAME='true' ;;
    *) echo "Usage: ./setup-env.sh [-r (random dst)] <env_name> "
       exit 1 ;;
  esac
done
readonly RANDOM_NAME

readonly ENV_NAME=${@:$OPTIND:1}
readonly SRC_ENV_PATH=$SRC_ENV_DIR/$ENV_NAME.tar.gz
# Check that the environment name is valid
if [ ! -f "$SRC_ENV_PATH" ]; then
  echo "Error: $SRC_ENV_PATH does not exist"
  exit 1
fi
###############################################################################

###############################################################################
# Unpack src env to dst env 
###############################################################################

# Get destination environment name
if [[ $RANDOM_NAME == 'true' ]]; then
  readonly DST_ENV_PATH=$(TMPDIR=$DST_ENV_DIR mktemp -d -t $ENV_NAME-XXXXXXXX)
else
  readonly DST_ENV_PATH=$DST_ENV_DIR/$ENV_NAME
fi

# Untar environment to destination
mkdir -p $DST_ENV_PATH
echo "Unpacking $SRC_ENV_PATH to $DST_ENV_PATH ..."
tar -xzf $SRC_ENV_PATH -C $DST_ENV_PATH
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
