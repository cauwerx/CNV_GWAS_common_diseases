#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=probe_extraction   # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			   # Define number of nodes required
#SBATCH --time=0-00:30:00   		   # Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=5GB           		   # Memory required per node
#SBATCH --cpus-per-task=20
#SBATCH --output=/cauwerx/gwas/05_gwas/05_pruning/mirror/data/log/02_probe_profile_extraction_mirror-%j.out

#################
#   JOB INFO    #
#################

Rscript /cauwerx/gwas/05_gwas/05_pruning/mirror/02_probe_profile_extraction.R

echo "Job done"
