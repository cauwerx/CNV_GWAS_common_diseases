# Extract the CNV profile of pruned probes. Configuration: Mirror model, All + Males + Females.

#################################################
### Libraries ###################################
library(data.table)
library(dplyr)



#################################################
### STEP 1: List & load files ###################

# List files of qc-ed probes (All, males, females); Files generated by "05_gwas/05_pruning/mirror/01_pruning_mirror.R"
list_files <- list.files(path = "/cauwerx/gwas/05_gwas/05_pruning/mirror/data/", pattern = "00_qc_probes_gwas_mirror", full.names = T, recursive = T)
print(paste0("Number of files to analyze: ", length(list_files)))

# Create an empty dataframe to store probes
probes <- data.frame()

# Loop over files, load them, and store their content
for (f in list_files){
	df <- as.data.frame(fread(f, header = T, select = c(1:3), col.names = c("CHR", "POS", "ID")))
	probes <- rbind(probes, df)
} 
print(paste0("Total number of probes: ", nrow(probes)))



#################################################
### STEP 2: Extract CNV profiles ################

# Remove duplicated probes
probes <- probes[!duplicated(probes$ID), ]
print(paste0("Total number of unique probes: ", nrow(probes)))

# Loop over unique probes and extract them from the PLINK files
for(i in 1:nrow(probes)) {

	# Define the probe's characteristics
	rs <- as.character(probes[i, "ID"])
	chr <- as.character(probes[i, "CHR"])
	print(paste0("Starting probe: ", rs, " (chr", chr, ")"))

	# Write file
	fwrite(data.frame(rs), paste0("/cauwerx/gwas/05_gwas/05_pruning/mirror/data/probe_profiles/", rs), col.names = F, row.names = F, quote = F, sep = "\t")

	# Extract profile with PLINK
	input <- paste0("/data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chr", chr) # PLINK file set with mirror encoding; Generation of this file is described in Auwerx et al., 2022
	output <- paste0("/cauwerx/gwas/05_gwas/05_pruning/mirror/data/probe_profiles/", rs)
	system(paste("/cauwerx/softwares/plink/plink",
				 "--fam /data/UKBB/cnv_calls/PLINK/mirror/ukb_cnv_bed/ukb_cnv_chrX_onlyF.fam", # Fake .fam file (all individuals = females) to deal with PLINK's male hemizygozity assumption (see Supplemental Note 1) 
				 "--threads 20",
				 "--bfile", input, 
				 "--keep /cauwerx/gwas/01_samples/data/samples_white_british_plink1.9_All.txt", # File generated by "01_samples/sample_filtering.R"
				 "--extract", output,
				 "--recode tab --out", output))

	# Correct the .ped in R
 	ped <- as.data.frame(fread(paste0(output, ".ped"), header = F, select = c(2,7), col.names = c("IID", "CNV")))
	ped[which(ped$CNV == "A A"), "CNV"] <- -1
	ped[which(ped$CNV == "A T" | ped$CNV == "T A"), "CNV"] <- 0
	ped[which(ped$CNV == "T T"), "CNV"] <- 1
	colnames(ped)[2] <- rs
	fwrite(ped, paste0(output, "_profile"), col.names = T, row.names = F, quote = F, sep = "\t")

	# Delete the rs file and the .ped/.map
	unlink(output); unlink(paste0(output, ".log")); unlink(paste0(output, ".map")); unlink(paste0(output, ".ped"))

}
