# Calculate the chromosome-wide number of effective tests to explain 99.5% of the variance

#################################################
### Libraries & External arguments ##############
library(data.table)
library(dplyr)
library(tidyr)
library(stringr)

# Arguments
args <- commandArgs(trailingOnly = TRUE)
chr <- args[1]
print(paste0("Analyzing chromosome ", chr))



#################################################
### STEP 1: Extract CNV matrix from .bed ########
print("Starting STEP 1: Extact data from PLINK files")

# Define the PLINK input file; Generation of this file is described in Auwerx et al., 2022 
input <- paste0("/data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chr", chr)

# Define file with samples to keep; File generated by "01_samples/sample_filtering.R"
samples <- "/cauwerx/gwas/01_samples/data/samples_white_british_plink1.9_All.txt"

# Define probes to keep (frequency filtered & pruned); Files generated by "02_probes/01_freq_prune.R"
probes <- paste0("/cauwerx/gwas/02_probes/data/pruning/probes_WB_All_prune_0.9999_CNV_chr", chr, ".prune.in")

# Define the temporary output file
output <- paste0("/cauwerx/gwas/02_probes/data/temp/Neff_peds/WB_probes_chr", chr)

# Extract profile with PLINK
system(paste("/cauwerx/softwares/plink/plink",
			 "--fam /data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chrX_onlyF.fam", # Fake .fam file (all individuals = females) to deal with PLINK's male hemizygozity assumption (see Supplemental Note 1)
			 "--threads 20",
			 "--bfile", input, 
			 "--keep", samples,
			 "--extract", probes,
			 "--recode tab --out", output))



#################################################
### STEP 2: Recode the data #####################
print("Starting STEP 2: Recode the .ped files for correlation analysis")

# Load .ped files generated in STEP 1 and recode them in numerical values
map <- as.data.frame(fread(paste0(output, ".map"), header = F, select = 2, col.names = "SNP"))
ped <- as.data.frame(fread(paste0(output, ".ped"), header = F, select = c(2,7:(6+nrow(map))), col.names = c("IID", map$SNP)))
ped[ped == "A A"] <- -1
ped[ped == "A T"] <- 0
ped[ped == "T A"] <- 0
ped[ped == "T T"] <- 1

# Delete the temporary .ped/.map files
unlink(paste0(output, ".log")); unlink(paste0(output, ".map")); unlink(paste0(output, ".ped"))

# Make the fist column rownames
rownames(ped) <- ped[,1]
ped <- ped[,-1]

# Transform in numerical matrix
ped <- mutate_all(ped, function(x) as.numeric(as.character(x)))
ped <- as.matrix(ped)



#################################################
### STEP 3: Correlation matrix ##################
print("Starting STEP 3: Compute the correlation matrix")

# Compute the correlation matrix
cor <- cor(ped, use = 'pairwise.complete.obs')
rm(ped)

# Set missing values to 0 to allow svd()
cor[which(is.na(cor))] <- 0


#################################################
### STEP 4: Calculate the eigenvalues ###########
print("Starting STEP 4: Calculate the eigenvalues")

# svd() computes the singular-value decomposition of a recatngular matrix, with $d being a vector containing the singular values of the decomposition
cnv_EV <- svd(cor)$d 


#################################################
### STEP 5: Calculate Neff ######################
print("Starting STEP 5: Calculate the chromosome-wise number of effective tests (Neff)")

# Neff is defined as the number of eigenvalues required to explain 99.5% of the variation from the CNV data 
sum_EV <- 0
count <- 0

while(sum_EV/sum(cnv_EV) < 0.995) {
	count <- count + 1
	sum_EV <- sum_EV + cnv_EV[count]
}
print(paste0("Neff on chromosome ", chr, ": ", count))

# Save 
fwrite(data.frame(count), paste0("/cauwerx/gwas/02_probes/data/Neff/Neff_chr", chr, ".txt"), col.names = F, row.names = F, quote = F, sep = "\t")
