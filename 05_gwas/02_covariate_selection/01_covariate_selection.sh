#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=covar_selection      # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		 		# Define number of nodes required
#SBATCH --time=0-00:40:00        		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=5GB           	 		# Memory required per node

# Parallelize by population
#SBATCH --array=1-3
#SBATCH --output=/cauwerx/gwas/05_gwas/02_covariate_selection/data/log/01_covariate_selection-%A_%a.out

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

Rscript /cauwerx/gwas/05_gwas/02_covariate_selection/01_covariate_selection.R ${sex}

echo "Job Done!"
