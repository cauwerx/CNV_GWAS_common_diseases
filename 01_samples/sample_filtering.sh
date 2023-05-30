#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=sample_filter   	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-00:15:00   		# Define how long the job will run
#SBATCH --mem=15GB           		# Memory required per node

#SBATCH --output=/cauwerx/gwas/01_samples/data/log/sample_filtering-%j.out

#################
#   JOB INFO    #
#################

Rscript /cauwerx/gwas/01_samples/sample_filtering.R

echo "Job done"
