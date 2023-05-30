#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=Mb_gene_effects  	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		  		# Define number of nodes required
#SBATCH --time=0-00:30:00   	  		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=1GB           	  		# Memory required per node
#SBATCH --output=/cauwerx/gwas/09_burden_analysis/data/log/03_Mb_gene_effect_comparison-%j.out

##################
#    RUN JOB     #
##################

# Disease burden
Rscript /cauwerx/gwas/09_burden_analysis/03_Mb_gene_effect_comparison_DiseaseBurden.R

# Other ICD10s
Rscript /cauwerx/gwas/09_burden_analysis/03_Mb_gene_effect_comparison_ICD10.R

echo "Job Done!"
