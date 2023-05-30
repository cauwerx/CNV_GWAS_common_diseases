#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=gwas_M_M      	# Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          			# Define number of nodes required
#SBATCH --time=0-08:00:00   		# Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=5GB           		# Memory required per node
#SBATCH --cpus-per-task=20			# Number of CPUs (multi-thread processes)

# Parallelize by chromosome
#SBATCH --array=1-24 
#SBATCH --output=/cauwerx/gwas/05_gwas/04_gwas/mirror/data/log/01_gwas_mirror_M-%A_%a.out

#################
#   VARIABLES   #
#################

echo "SLURM_JOB_ID: " $SLURM_JOB_ID
echo "SLURM_ARRAY_ID: " $SLURM_ARRAY_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

#################
#   JOB INFO    #
#################

chromosomes=$(echo 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 XY X)
chr=$(echo ${chromosomes} | cut -f ${SLURM_ARRAY_TASK_ID} -d ' ')

##################
#    RUN JOB     #
##################

#################################################
# STEP 1: DEFINE FIXED VARIABLES ################

# PLINK file set with mirror encoding; Generation of this file is described in Auwerx et al., 2022
input=$(echo "/data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chr${chr}")

# Disease diagnosis; File generated by "04_phenotypes/01_ICD10_extraction.R"
pheno_M=$(echo "/cauwerx/gwas/04_phenotypes/data/pheno_ICD10_M.txt")

# Samples: white-british individuals; Generated by "01_samples/sample_filtering.R"
samples_M=$(echo "/cauwerx/gwas/01_samples/data/samples_white_british_M.txt")

# Covariates; File generated bby "03_covariates/01_covariate_extraction.R"
covariates=$(echo "/cauwerx/gwas/03_covariates/data/covariates.txt")

# Output
output_M=$(echo "/cauwerx/gwas/05_gwas/04_gwas/mirror/data/temp/M/gwas_mirror_M_chr${chr}")


#################################################
# STEP 2: LIST PHENOTYPES #######################

pheno_list=$(head -n 1 ${pheno_M})
pheno_list=$(echo $pheno_list | sed 's/[^ ]* //')


#################################################
# STEP 3: LOOP OVER DISEASES ####################

for p in $pheno_list; do

	# Define analyzed disease
	echo "Starting to analyze: ${p}"

	# Define selected covariates; File generated by "05_gwas/02_covariate_selection/01_covariate_selection.R"
	selected_covariates=$(cat "/cauwerx/gwas/05_gwas/02_covariate_selection/data/M/covariates_M.${p}.txt")

	# Define selected probes; File generated by "05_gwas/03_probe_selection/02_probe_selection.R"
	selected_probes=$(echo "/cauwerx/gwas/05_gwas/03_probe_selection/data/M/mirror/probes_mirror_M_chr${chr}.${p}.txt")

	# Check if covariates are empty
	if [ -z "$selected_covariates" ]
	then
		# Run PLINK v2.0 without covariates
		/cauwerx/softwares/plink2/plink2 	--threads 20 \
											--bfile ${input} \
											--fam /data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chrX_onlyF.fam \ # Fake .fam file (all individuals = females) to deal with PLINK's male hemizygozity assumption (see Supplemental Note 1)
											--keep ${samples_M} \
											--extract ${selected_probes} \
											--pheno iid-only ${pheno_M} --no-psam-pheno --pheno-name ${p} \
											--glm firth-fallback omit-ref no-x-sex hide-covar allow-no-covars --ci 0.95 \
											--out ${output_M}
	else
		# Run PLINK v2.0 with covariates
		/cauwerx/softwares/plink2/plink2	--threads 20 \
											--bfile ${input} \
											--fam /data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chrX_onlyF.fam \ # Fake .fam file (all individuals = females) to deal with PLINK's male hemizygozity assumption (see Supplemental Note 1)
											--keep ${samples_M} \
											--extract ${selected_probes} \
											--pheno iid-only ${pheno_M} --no-psam-pheno --pheno-name ${p} \
											--covar iid-only ${covariates} --covar-name ${selected_covariates} --covar-variance-standardize \
			 							    --glm firth-fallback omit-ref no-x-sex hide-covar --ci 0.95 \
											--out ${output_M}
	fi
	wait
	
done

echo "Job done"
