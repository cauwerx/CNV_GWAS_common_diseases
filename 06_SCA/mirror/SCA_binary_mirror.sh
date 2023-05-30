#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=SCA_mirror   # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		# Define number of nodes required
#SBATCH --time=2-00:00:00   	# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=10GB           	# Memory required per node
#SBATCH --cpus-per-task=20		# Multi-thead processing

# Parallelize by population
#SBATCH --array=1-3
#SBATCH --output=/cauwerx/gwas/06_SCA/mirror/data/log/SCA_binary_mirror-%A_%a.out

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

Rscript /cauwerx/gwas/06_SCA/mirror/SCA_binary_mirror.R ${sex}

echo "Job done"
