#!/bin/bash
# Sets up shared environments in /var/tmp/scratch.

mkdir -p /var/tmp/scratch
chgrp -R ccg /var/tmp/scratch  # Run immediately in case we abort early

# cp --verbose ~/ccg_shared/env-tars/robustbench-tmp.tar /var/tmp/scratch
# tar -xvf /var/tmp/scratch/robustbench-tmp.tar -C /var/tmp/scratch

cp --verbose ~/ccg_shared/env-tars/miax-tmp.tar /var/tmp/scratch
tar -xvf /var/tmp/scratch/miax-tmp.tar -C /var/tmp/scratch

cp --verbose ~/ccg_shared/env-tars/scaling-v2-tmp.tar /var/tmp/scratch
tar -xvf /var/tmp/scratch/scaling-v2-tmp.tar -C /var/tmp/scratch

cp --verbose ~/ccg_shared/env-tars/ax-tmp.tar /var/tmp/scratch
tar -xvf /var/tmp/scratch/ax-tmp.tar -C /var/tmp/scratch

chgrp -R ccg /var/tmp/scratch  # Run at end to own everything 
