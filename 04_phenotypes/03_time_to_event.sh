#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=time_to_event	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		    # Define number of nodes required
#SBATCH --time=0-12:00:00           # Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=15GB          	    # Memory required per node

# Parallelize by disease
#SBATCH --array=1-60
#SBATCH --output=/cauwerx/gwas/04_phenotypes/data/log/03_time_to_event-%A_%a.out

#################
#   VARIABLES   #
#################

echo "SLURM_JOB_ID: " $SLURM_JOB_ID
echo "SLURM_ARRAY_ID: " $SLURM_ARRAY_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

#################
#   JOB INFO    #
#################

pheno=$(seq -s " " 1 60 | cut -f ${SLURM_ARRAY_TASK_ID} -d ' ')

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/04_phenotypes/03_time_to_event.R ${pheno}

echo "Job Done!"
