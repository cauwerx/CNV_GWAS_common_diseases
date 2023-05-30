#!/bin/bash

#################
#   RUN INFO    #
#################

#SBATCH --job-name=probe_effect	   # Give your job a name to recognize it in queue overview
#SBATCH --nodes=1          		   # Define number of nodes required
#SBATCH --time=0-02:00:00   	   # Define how long the job will run (max. is 7 days, default is 1h)
#SBATCH --mem=5GB           	   # Memory required per node
#SBATCH --cpus-per-task=20		   # Multi-thread processing

# Parallelize by chromosome
#SBATCH --array=1-24
#SBATCH --output=/cauwerx/gwas/05_gwas/03_probe_selection/data/log/01_get_probe_effect_DiseaseBurden-%A_%a.out

#################
#   JOB INFO    #
#################

chromosomes=$(echo 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 XY X)
chr=$(echo ${chromosomes} | cut -f ${SLURM_ARRAY_TASK_ID} -d ' ')

##################
#    RUN JOB     #
##################

## DEFINE VARIABLES #######################

# PLINK file set with mirror encoding; Generation of this file is described in Auwerx et al., 2022 
input=$(echo "/data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chr${chr}")

# Disease burden; File generated by "04_phenotypes/01_ICD10_extraction.R"
pheno_all=$(echo "/cauwerx/gwas/04_phenotypes/data/pheno_ICD10_All.txt")
pheno_M=$(echo "/cauwerx/gwas/04_phenotypes/data/pheno_ICD10_M.txt")
pheno_F=$(echo "/cauwerx/gwas/04_phenotypes/data/pheno_ICD10_F.txt")

# Samples: white-british individuals; Generated by "01_samples/sample_filtering.R"
samples_all=$(echo "/cauwerx/gwas/01_samples/data/samples_white_british_All.txt")
samples_M=$(echo "/cauwerx/gwas/01_samples/data/samples_white_british_M.txt")
samples_F=$(echo "/cauwerx/gwas/01_samples/data/samples_white_british_F.txt")

# Probes (pruned); Generated by "02_probes/01_freq_prune.R" 
probes=$(echo "/cauwerx/gwas/02_probes/data/pruning/probes_WB_All_prune_0.9999_CNV_chr${chr}.prune.in")

# Output
output_all=$(echo "/cauwerx/gwas/05_gwas/03_probe_selection/data/temp/All/probe_effect_continuous_All_chr${chr}")
output_M=$(echo "/cauwerx/gwas/05_gwas/03_probe_selection/data/temp/M/probe_effect_continuous_M_chr${chr}")
output_F=$(echo "/cauwerx/gwas/05_gwas/03_probe_selection/data/temp/F/probe_effect_continuous_F_chr${chr}")


## RUN PLINK - All #######################

/cauwerx/softwares/plink2/plink2    --threads 20 \
									--bfile ${input} \
									--fam /data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chrX_onlyF.fam \ # Fake .fam file (all individuals = females) to deal with PLINK's male hemizygozity assumption (see Supplemental Note 1)
						        	--keep ${samples_all} \
						        	--extract ${probes} \
                                    --pheno ${pheno_all} --pheno-name DiseaseBurden --no-psam-pheno \
									--glm omit-ref no-x-sex hide-covar allow-no-covars \
									--out ${output_all}

## RUN PLINK - M #########################

/cauwerx/softwares/plink2/plink2    --threads 20 \
									--bfile ${input} \
									--fam /data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chrX_onlyF.fam \ # Fake .fam file (all individuals = females) to deal with PLINK's male hemizygozity assumption (see Supplemental Note 1)
						        	--keep ${samples_M} \
						        	--extract ${probes} \
                                    --pheno ${pheno_M} --pheno-name DiseaseBurden --no-psam-pheno \
									--glm omit-ref no-x-sex hide-covar allow-no-covars \
									--out ${output_M}

## RUN PLINK - F #########################

/cauwerx/softwares/plink2/plink2    --threads 20 \
									--bfile ${input} \
									--fam /data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chrX_onlyF.fam \ # Fake .fam file (all individuals = females) to deal with PLINK's male hemizygozity assumption (see Supplemental Note 1)
						        	--keep ${samples_F} \
						        	--extract ${probes} \
                                    --pheno ${pheno_F} --pheno-name DiseaseBurden --no-psam-pheno \
									--glm omit-ref no-x-sex hide-covar allow-no-covars \
									--out ${output_F}

wait

echo "Done"
