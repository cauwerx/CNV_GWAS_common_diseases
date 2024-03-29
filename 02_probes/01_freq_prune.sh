#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=probe_prune   	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-00:10:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=2GB           		# Memory required per node

# Parallelize
#SBATCH --array=1-24 
#SBATCH --output=/cauwerx/gwas/02_probes/data/log/01_feq_prune-%A_%a.out

#################
#   VARIABLES   #
#################

echo "SLURM_JOB_ID: " $SLURM_JOB_ID
echo "SLURM_ARRAY_ID: " $SLURM_ARRAY_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

#################
#   JOB INFO    #
#################

chromosomes=$(echo 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 XY X)
chr=$(echo ${chromosomes} | cut -f ${SLURM_ARRAY_TASK_ID} -d ' ')

Rscript /cauwerx/gwas/02_probes/01_freq_prune.R ${chr}

echo "Job done"
