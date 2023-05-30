#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=covariates   	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-00:15:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=3GB           		# Memory required per node

#SBATCH --output=/cauwerx/gwas/03_covariates/data/log/01_covariate_extraction-%j.out

#################
#   JOB INFO    #
#################

Rscript /cauwerx/gwas/03_covariates/01_covariate_extraction.R

echo "Job done"
