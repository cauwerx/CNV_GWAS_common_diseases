#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=locus-zoom			# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          				# Define number of nodes required
#SBATCH --time=0-00:30:00   			# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=2GB           			# Memory required per node
#SBATCH --cpus-per-task=20
#SBATCH --output=/cauwerx/gwas/10_candidates/22q11.2/data/log/02_locus_zoom_U_binary-%j.out

##################
#   VARIABLES    #
##################

chr=22
start=18000000
end=27000000
pheno=$(echo IHD-glaucoma)  

##################
#    RUN JOB     #
##################

Rscript /cauwerx/gwas/10_candidates/22q11.2/02_locus_zoom_U_binary.R ${chr} ${start} ${end} ${pheno}

echo "Job Done!"
