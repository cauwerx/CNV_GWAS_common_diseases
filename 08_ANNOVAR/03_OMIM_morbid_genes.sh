#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=OMIM				# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-00:30:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=2GB           		# Memory required per node
#SBATCH --output=/cauwerx/gwas/08_ANNOVAR/combined/data/log/03_OMIM_morbid_genes-%j.out

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/08_ANNOVAR/combined/03_OMIM_morbid_genes.R

echo "Job Done!"
