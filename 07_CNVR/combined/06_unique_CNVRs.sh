#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=unique_CNVRs		# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		    # Define number of nodes required
#SBATCH --time=0-00:20:00           # Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=1GB           	    # Memory required per node
#SBATCH --output=/cauwerx/gwas/07_CNVR/combined/data/log/06_unique_CNVRs-%j.out

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/07_CNVR/combined/06_unique_CNVRs.R

echo "Job Done!"
