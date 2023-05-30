#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=pheno_binary     # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-00:30:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=5GB           		# Memory required per node
#SBATCH --output=/cauwerx/gwas/04_phenotypes/data/log/04_summary-%j.out

#################
#   JOB INFO    #
#################

Rscript /cauwerx/gwas/04_phenotypes/04_summary.R

echo "Job done"
