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
#SBATCH -p small
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
rm Slurm-* ;
rm slurm-* ;

#|=======================================
# run ABAUCUS HERE
#|---------------------------------------
ABACUS_PATH=$ABACUSROOT/bin/ABACUS.mpi
#|vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# srun .....
#|^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#|=======================================
#| done
#|---------------------------------------