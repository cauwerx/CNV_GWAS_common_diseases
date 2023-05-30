#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=GW_Neff   	    # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-00:02:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=1GB           		# Memory required per node
#SBATCH --output=/cauwerx/gwas/02_probes/data/log/04_GW_Neff-%j.out

#################
#   JOB INFO    #
#################

# Calculate the genome-wide number of effective tests as the sum of the number of effective tests per chromosome
cd /cauwerx/gwas/02_probes/data/Neff
paste Neff_chr* | awk '{sum=0; for(i=1; i<=NF; i++) sum += $i; print sum}' > /cauwerx/gwas/02_probes/data/Neff/Neff_GW.txt

echo "Job done"
