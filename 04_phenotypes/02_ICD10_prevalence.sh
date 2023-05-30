#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=disease_prevalence   # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          				# Define number of nodes required
#SBATCH --time=0-00:30:00   			# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=2GB           			# Memory required per node
#SBATCH --output=/cauwerx/gwas/04_phenotypes/data/log/02_ICD10_prevalence-%j.out

#################
#   JOB INFO    #
#################

Rscript /cauwerx/gwas/04_phenotypes/02_ICD10_prevalence.R

echo "Job done"
