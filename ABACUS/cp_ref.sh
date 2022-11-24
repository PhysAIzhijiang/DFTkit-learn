#!/bin/bash

# 该脚本是用来维护例子的, 请不要执行

rsync -a --exclude=*.cube --exclude=*/tmp_* --exclude=*/SPIN*_CHG* --exclude=*/slurm* -zvP  run_example/* ./example_ref/