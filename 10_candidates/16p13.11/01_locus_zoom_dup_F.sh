#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=locus-zoom			# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          				# Define number of nodes required
#SBATCH --time=0-00:10:00   			# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=2GB           			# Memory required per node
#SBATCH --output=/cauwerx/gwas/10_candidates/16p13.11/data/log/01_locus_zoom_dup_F-%j.out

##################
#   VARIABLES    #
##################

chr=16
start=14500000
end=19000000
pheno=$(echo menopause) 

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/10_candidates/16p13.11/01_locus_zoom_dup_F.R ${chr} ${start} ${end} ${pheno}

echo "Job Done!"
