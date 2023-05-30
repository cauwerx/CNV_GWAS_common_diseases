#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=prune_sum    	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-00:10:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=1GB           		# Memory required per node
#SBATCH --output=/cauwerx/gwas/02_probes/data/log/02_summarize_pruning-%j.out

#################
#   JOB INFO    #
#################

Rscript /cauwerx/gwas/02_probes/02_summarize_pruning.R 

echo "Job done"
