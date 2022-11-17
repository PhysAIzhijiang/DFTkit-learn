# ABACUS使用指南

**作者: 毕升**

---

*安装请参看ABACUS安装指南*

## 系统环境
本指南以qlab服务器环境进行编译为例子.

### 服务器加载环境
使用`module load`指令.

``` bash 
module load abacus/intel-3.0.1
```

## 执行ABACUS
ABACUS支持openmp+MPI混合并行.

### 直接运行 (个人电脑)
如果直接运行 
- `OMP_NUM_THREADS`控制openmp使用的线程数; 
- `mpirun -np xx`, `xx`代表`mpi`使用的并行核数.

最后使用的核数=`xx` x `OMP_NUM_THREADS`

比如执行 
    ``` bash
    $ OMP_NUM_THREADS=4; 
    $ mpirun -np 2 ABACUS.mpi 
    ```
将会使用2x4=8个核.

### 使用队列管理系统 (集群)
*这里使用Slurm作为例子*

下面为`Slurm`提交ABACUS的脚本`run.slurm`. 

``` bash
#!/bin/bash -l

#|=======================================
#| set output and error file name
#| if not set, slurm will generate files 
#| with name stdout and stderr.
#|---------------------------------------
## #SBATCH -o Slurm-o.%j
## #SBATCH -e Slurm-e.%j

#|=======================================
#| name of the job
#|---------------------------------------
#SBATCH -J abacus

#|=======================================
#| execute job from the current working directory
#| this is default slurm behavior
#|---------------------------------------
#SBATCH -D ./

#|=======================================
#| send mail
#| send when job done
#|---------------------------------------
#+ #SBATCH --mail-type=end
#+ #SBATCH --mail-user=YOUR_NAME@YOUR_MAIL_SERVER

#|=======================================
#| specify your job requires
#|---------------------------------------
#|- set nodes, task, cpus for a hybrid MPI/OpenMP job
#|-
#|- nodes you required
#SBATCH --nodes=1
#|- tasks on each node, it depends on the cluster
#|- use 'sinfo --Node --long' to know how many cores per node
#SBATCH --ntasks-per-node=2
#|- Number of cores per task (for openmp)
#SBATCH --cpus-per-task=4
#|---------------------------------------
#|- set memory limit 4000Mb
#|- #SBATCH --mem 4000
#|---------------------------------------
#|- PARTITION & time limit
#|- use `sinfo` to list PARTITION & TIMELIMIT
#SBATCH -p debug
#|- Quality
#SBATCH -q short
## time format day-hour:minute:second
#SBATCH --time=00-00:30:00

#|=======================================
#| start to set your environment for your job
#|---------------------------------------

#|-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
#- load intel abacus
#|---------------------------------------
module load abacus/intel-3.0.1

export MKLPATH=$MKL_HOME/lib/intel64/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MKLPATH
export INTELPATH=$INTEL_HOME/lib/intel64/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$INTELPATH
#+

#|-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
#- set parallel environment
#|---------------------------------------
#- use mpi/openmp
if [ -n "$SLURM_CPUS_PER_TASK" ]; then
    omp_threads=$SLURM_CPUS_PER_TASK
else
    omp_threads=1
fi
export OMP_NUM_THREADS=$omp_threads
export MKL_NUM_THREADS=$omp_threads

#- If you prefer using mpiexec/mpirun with SLURM, please add the following code to the batch script before running any MPI executable
# unset I_MPI_PMI_LIBRARY 
# export I_MPI_JOB_RESPECT_PROCESS_PLACEMENT=0   # the option -ppn only works if you set this before

#|-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
#| load your own lib path(if needed)
#|---------------------------------------
#+ export PATH=$PATH:your path

#|=======================================
#| start to run your job
#|---------------------------------------
rm Slurm-*

ABACUS_PATH=$ABACUSROOT/bin/ABACUS.mpi

#|vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# run ABAUCUS HERE
# replace the following line with the command given by the example.
# .....
#|^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#|=======================================
#| done
#|---------------------------------------
# exit 0
```
其中`#SBATCH --nodes=1`用来设置要使用几个`node`(节点), 节点和节点之间是MPI并行. 这里用了1个`node`.
`#SBATCH --ntasks-per-node=2`是用来设置每个节点要用几个`task`, `task`之间也是MPI并行. 这里用了2个`task`.
`#SBATCH --cpus-per-task=4`是每个`task`使用多少`CPU`进行OpenMP进行并行. 这里用了4个`cpu`.
*注意*, `ntasks-per-node`x`cpus-per-task`要小于机器上单个节点最大核数. 

在这个例子里, 一共用了`1x2x4=8`个`cpu`. 

通过下面指令, 提交脚本, 运行程序.
``` bash
$ sbatch run.slurm
```
*注意*, 脚本里出现的`#SBATCH -p debug`和`#SBATCH -q short`的`debug`和`short`要和集群管理原确认节点名称后自行修改.

## 例子
