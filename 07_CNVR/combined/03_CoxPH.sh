#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=CoxPH		    # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		    # Define number of nodes required
#SBATCH --time=0-02:00:00           # Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=5GB           	    # Memory required per node
#SBATCH --cpus-per-task=20
#SBATCH --output=/cauwerx/gwas/07_CNVR/combined/data/log/03_CoxPH-%j.out

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/07_CNVR/combined/03_CoxPH.R

echo "Job Done!"
