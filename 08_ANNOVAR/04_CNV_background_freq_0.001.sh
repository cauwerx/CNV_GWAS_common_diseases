#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=cnv_bckg		    # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-02:00:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=1GB           		# Memory required per node
#SBATCH --output=/cauwerx/gwas/08_ANNOVAR/combined/data/log/04_CNV_background_freq_0.001-%j.out

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/08_ANNOVAR/combined/04_CNV_background_freq_0.001.R

echo "Job Done!"
