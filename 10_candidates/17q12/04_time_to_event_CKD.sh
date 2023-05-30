#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=time_to_event	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		    # Define number of nodes required
#SBATCH --partition=normal  	    # Define the partition on which the job shall run. May be omitted
#SBATCH --mem=15GB          	    # Memory required per node

# Parallelize by phenotype
#SBATCH --array=1-2
#SBATCH --output=/cauwerx/gwas/10_candidates/17q12/data/log/04_time_to_event_CKD-%A_%a.out

#################
#   VARIABLES   #
#################

echo "SLURM_JOB_ID: " $SLURM_JOB_ID
echo "SLURM_ARRAY_ID: " $SLURM_ARRAY_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

#################
#   JOB INFO    #
#################

pheno=$(seq -s " " 1 2 | cut -f ${SLURM_ARRAY_TASK_ID} -d ' ')

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/10_candidates/17q12/04_time_to_event_CKD.R ${pheno}

echo "Job Done!"
