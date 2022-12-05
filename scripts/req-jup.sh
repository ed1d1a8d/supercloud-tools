#!/bin/bash
sbatch --open-mode=append --qos high -J Jup_$1 --partition=xeon-g6-volta --constraint=xeon-g6 --gres=gpu:volta:1 --cpus-per-task=20 --time='24:00:00' --wrap 'srun --resv-ports=1 /usr/local/bin/LL_start_jupyter_notebook.sh --notebook -- anaconda/2022a' 2>&1
