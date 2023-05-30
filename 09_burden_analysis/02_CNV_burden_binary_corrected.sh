#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=CNV_burden_binary 	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		  		# Define number of nodes required
#SBATCH --time=0-01:00:00   	  		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=3GB           	  		# Memory required per node

# Parallelize by burden type
#SBATCH --array=1-3
#SBATCH --output=/cauwerx/gwas/09_burden_analysis/data/log/02_CNV_burden_binary_corrected-%A_%a.out

#################
#   VARIABLES   #
#################

# Parallelization
echo "SLURM_JOB_ID: " $SLURM_JOB_ID
echo "SLURM_ARRAY_ID: " $SLURM_ARRAY_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

# Variable by condition
burdens=$(echo CNV DUP DEL)
b=$(echo ${burdens} | cut -f ${SLURM_ARRAY_TASK_ID} -d ' ')

##################
#    RUN JOB     #
##################

# Binary traits
Rscript /cauwerx/gwas/09_burden_analysis/02_CNV_burden_binary_corrected.R ${b}

# Disease burden (= continuous)
Rscript /cauwerx/gwas/09_burden_analysis/02_CNV_burden_corrected_DiseaseBurden.R ${b}

echo "Job Done!"
