#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=pruning_U    # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		# Define number of nodes required
#SBATCH --time=0-00:30:00   	# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=5GB           	# Memory required per node
#SBATCH --cpus-per-task=20 

# Parallelize by population
#SBATCH --array=1-3
#SBATCH --output=/cauwerx/gwas/05_gwas/05_pruning/u_shape/data/log/01_pruning_U-%A_%a.out

#################
#   VARIABLES   #
#################

echo "SLURM_JOB_ID: " $SLURM_JOB_ID
echo "SLURM_ARRAY_ID: " $SLURM_ARRAY_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

#################
#   JOB INFO    #
#################

populations=$(echo All M F)
sex=$(echo ${populations} | cut -f ${SLURM_ARRAY_TASK_ID} -d ' ')

#################
#   JOB INFO    #
#################

Rscript /cauwerx/gwas/05_gwas/05_pruning/u_shape/01_pruning_U.R ${sex}

echo "Job done"
