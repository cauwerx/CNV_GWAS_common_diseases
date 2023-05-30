#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=female_cancer    # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-01:00:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=10GB           		# Memory required per node
#SBATCH --output=/cauwerx/gwas/10_candidates/17q21.31/data/log/01_ICD10_extraction-%j.out

#################
#   JOB INFO    #
#################

Rscript /cauwerx/gwas/10_candidates/17q21.31/01_ICD10_extraction.R

echo "Job done"
