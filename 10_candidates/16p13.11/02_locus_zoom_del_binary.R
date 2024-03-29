# Locus zoom plot for the association between the 16p13.11 locus and KS/epilepsy according to a deletion-only association model.

#################################################
### Libraries & External arguments ##############
library(data.table)
library(dplyr)
library(tidyr)
library(stringr)

# Arguments
args <- commandArgs(trailingOnly = TRUE)
chr <- args[1]
start <- args[2]
end <- args[3]
pheno <- gsub("-", " ", args[4])
print(paste0("Locus zoom plot for: chr", chr, ":", start, "-", end, " - ", pheno))



#################################################
### STEP 1: High missingness file ###############

# Probes with > 95% missingness; File generated as described in Auwerx et al., 2022 ("GWAS/02_probes/frequency/02_high_missingness_0.95.R")
hm <- as.data.frame(fread("/data/UKBB/general_data/high_missingness/genotype_missingness_0.95.txt"))
fwrite(data.frame(hm$SNP), "/cauwerx/gwas/10_candidates/16p13.11/data/temp/locus_zoom/high_missingness.txt", col.names = F, row.names = F, quote = F, sep = "\t")



#################################################
### STEP 2: PLINK input #########################

# PLINK file set with deletion encoding; Generation of this file is described in Auwerx et al., 2022
plink_file <- paste0("/data/UKBB/cnv_calls/PLINK/deletion_only/ukb_cnv_bed/ukb_cnv_chr", chr)

# Disease diagnosis; File generated by "04_phenotypes/01_ICD10_extraction.R"
pheno_file <- "/cauwerx/gwas/04_phenotypes/data/pheno_ICD10_All.txt"

# Samples: white-british individuals; Generated by "01_samples/sample_filtering.R"
samples_file <- "/cauwerx/gwas/01_samples/data/samples_white_british_All.txt"

# Probes to exclude due to high missingness (step 1)
HM_file <- "/cauwerx/gwas/10_candidates/16p13.11/data/temp/locus_zoom/high_missingness.txt"

# Output file
output_file <- paste0("/cauwerx/gwas/10_candidates/16p13.11/data/temp/locus_zoom/del_All_chr", chr, ":", start, ":", end)



#################################################
### STEP 3: Run PLINK ###########################

# Loop over diseases
for(p in unlist(strsplit(pheno, " "))) {

	# Covariate file selection
	selected_cov <- as.data.frame(fread(paste0("/cauwerx/gwas/05_gwas/02_covariate_selection/data/All/covariates_All.", p, ".txt"), header = F, sep = "\t")) # File generated by "05_gwas/02_covariate_selection/01_covariate_selection.R"
	selected_cov <- unlist(strsplit(selected_cov[1,1],","))
	cov <- as.data.frame(fread("/cauwerx/gwas/03_covariates/data/covariates.txt")) # File generated by "03_covariates/01_covariate_extraction.R"
	cov <- cov[, names(cov) %in% c("IID", selected_cov)]
	cov_file <- paste0("/cauwerx/gwas/10_candidates/16p13.11/data/temp/covariates/selected_covariates_All_", p, ".txt") 
	fwrite(cov, cov_file, col.names = T, row.names = F, quote = F, sep = "\t")

	# Run  PLINK	
	system(paste("/cauwerx/softwares/plink2/plink2",
				 "--threads 20",
	 			 "--bfile", plink_file,
				 "--pheno iid-only", pheno_file, "--no-psam-pheno", "--pheno-name", p,
				 "--covar iid-only", cov_file, "--covar-variance-standardize",
				 "--glm firth-fallback omit-ref no-x-sex hide-covar --ci 0.95", 
				 "--keep", samples_file,
				 "--exclude",  HM_file, "--chr", chr, "--from-bp", start, "--to-bp", end,
				 "--out", output_file))
	unlink(cov_file)
	unlink(paste0(output_file, ".log"))

	# Correct association direction
	df <- as.data.frame(fread(paste0(output_file, ".", p, ".glm.logistic.hybrid"), header = T))
	df[10:15] <- lapply(df[10:15], as.numeric)

	# Correct associations where A1 = "A"; Correct: OR, CI, Z, alleles; Not correct: SE(ln(OR)), P
	df[df$A1 == "A", "OR"] <- exp(-log(df[df$A1 == "A", "OR"]))
	df[df$A1 == "A", "L95"] <- exp(log(df[df$A1 == "A", "OR"]) - 1.96*df[df$A1 == "A", "LOG(OR)_SE"]) 
	df[df$A1 == "A", "U95"] <- exp(log(df[df$A1 == "A", "OR"]) + 1.96*df[df$A1 == "A", "LOG(OR)_SE"]) 
	df[df$A1 == "A", "Z_STAT"] <- log(df[df$A1 == "A", "OR"])/df[df$A1 == "A", "LOG(OR)_SE"]
	df[df$A1 == "A", "REF"] <- "A"
	df[df$A1 == "A", "ALT"] <- "T"
	df[df$A1 == "A", "A1"] <- "T"
	
	# Save
	fwrite(df, paste0("/cauwerx/gwas/10_candidates/16p13.11/data/locus_zoom/del_All_chr", chr, ":", start, ":", end, ".", p, ".glm.logistic.hybrid"), col.names = T, row.names = F, quote = F, sep = "\t", na = NA)

}

unlink(HM_file)
