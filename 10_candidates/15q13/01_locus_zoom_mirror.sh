#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=locus-zoom			# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          				# Define number of nodes required
#SBATCH --time=0-00:10:00   			# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=2GB           			# Memory required per node
#SBATCH --output=/cauwerx/gwas/10_candidates/15q13/data/log/01_locus_zoom_mirror-%j.out

##################
#   VARIABLES    #
##################

chr=15
start=29000000
end=33000000
pheno=$(echo RBC_count) 

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/10_candidates/15q13/01_locus_zoom_mirror.R ${chr} ${start} ${end} ${pheno}

echo "Job Done!"
