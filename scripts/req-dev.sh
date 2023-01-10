#!/bin/bash
# Requests a devbox with a V100 gpu and 20 cpu cores
# (these numbers can be customized below)

# Get location of this file
# Taken from https://stackoverflow.com/a/246128/1337463
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# Make log directory
mkdir -p $HOME/slurm-logs/dev

# Launch job with sbatch
# The name of the job is Dev_{first argument passed to this script}
sbatch -J Dev_$1 \
    --qos high \
    --partition=xeon-g6-volta \
    --constraint=xeon-g6 \
    --gres=gpu:volta:1 \
    --cpus-per-task=20 \
    --time='24:00:00' \
    -o $HOME/slurm-logs/dev/slurm-%j.out \
    --wrap "srun $SCRIPT_DIR/../bin/mallory" \
    2>&1
