#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=CNVR_U           # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		    # Define number of nodes required
#SBATCH --time=0-12:00:00           # Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=50GB           	    # Memory required per node
#SBATCH --cpus-per-task=20			# Number of CPUs (multi-thread processes)

# Parallelize by population
#SBATCH --array=1-3
#SBATCH --output=/cauwerx/gwas/07_CNVR/u_shape/data/log/01_GWAS_CNVR_U-%A_%a.out

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

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/07_CNVR/u_shape/01_CNVR_U.R ${sex}

echo "Job Done!"