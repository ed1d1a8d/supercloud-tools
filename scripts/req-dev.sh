#!/bin/bash
# Requests a devbox with a V100 gpu and 20 cpu cores
mkdir -p $HOME/slurm-logs/dev
sbatch -J Dev_$1 \
    --qos high \
    --partition=xeon-g6-volta \
    --constraint=xeon-g6 \
    --gres=gpu:volta:1 \
    --cpus-per-task=20 \
    --time='24:00:00' \
    -o $HOME/slurm-logs/dev/slurm-%j.out \
    --wrap 'srun mallory' \
    2>&1
