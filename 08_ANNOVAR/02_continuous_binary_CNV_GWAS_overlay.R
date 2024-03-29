# Identify CNVRs that overlap a region found to be associated with a relevant continuous trait through CNV-GWAS.

#################################################
### Libraries ###################################
library(data.table)
library(dplyr)



#################################################
### STEP 1: Load data ###########################

# All merged associations ; File generated by "07_CNVR/combined/01_combine_models.R"
cnvrs <- as.data.frame(fread("/home/cauwerx/scratch/cauwerx/projects/cnv_gwas/gwas/09_CNVR/binary/white_british/combined/data/final/combined_CNVR/all_combined_CNVR.txt", header = F, select = c(1:11), col.names =  c("DISEASE", "TOP_SNP", "CHR", "POS", "OR", "SE", "P", "START_CNVR", "END_CNVR", "MAIN_MODEL", "ALL_MODELS")))
cnvrs <- cnvrs[!cnvrs$DISEASE %in% c("DiseaseBurden"), ]
print(paste0("Number of CNVRs to annotate: ", nrow(cnvrs)))

# Load coordinnates of CNVRs associated with continuous traits in Auwerx et al., 2022 (Table S2)
cont_GWAS <- as.data.frame(fread("/data/continuous_CNV_GWAS/131_continuous_CNV_GWAS_signals.txt", select = c(1, 5, 10, 11), col.names = c("PHENO", "CHR", "START_CNVR", "END_CNVR")))



#################################################
### STEP 2: Loop over associations ##############

# Loop over associations
for (i in 1:nrow(cnvrs)) {

	# Define the CNV region & synonyms
	chr <- cnvrs[i, "CHR"]
	start <- cnvrs[i, "START_CNVR"]
	end <- cnvrs[i, "END_CNVR"]
	disease <- cnvrs[i, "DISEASE"]
	synonyms <- unlist(strsplit(as.character(disease_synonym[which(disease_synonym$DISEASE == disease), "SYN"]), ", ", fixed = T, useBytes = T))
	print(paste0("Analyzing chr", chr, ":", start, "-", end, " (", end-start+1, " bp) - ", disease))
	print(paste0(synonyms))

	# 2.1 Detect overlapping signals (with data.table::foverlaps)
	df_temp <- data.table(DISEASE = disease, CHR = chr, START_CNVR = start, END_CNVR = end)
	setkey(df_temp, CHR, START_CNVR, END_CNVR)
	match <- na.omit(foverlaps(data.table(cont_GWAS), df_temp, type = "any", which = T))
	match  <- cont_GWAS[match$xid, ]
	print(paste0("Number of matches for ", disease, " & chr", chr, ":", start, "-", end, ": ", nrow(match)))
	cnvrs[i, "N_TOTAL"] <- nrow(match)

	if(nrow(match) == 0) {

		# Fill in the table 
		cnvrs[i, "N_SYN"] <- 0

		# Go to the next CNV
		print(paste0("Analyzing the next association!"))
		next

	} else { 

		# Save a file with detailed information on all synonym associations
		fwrite(match, paste0("/cauwerx/gwas/08_ANNOVAR/combined/data/continuous_CNV_GWAS/continuous_CNV_GWAS_overlap_chr", chr, ":", start, "-", end, "_", disease, ".txt"), col.names = T, row.names = F, sep  = "\t", quote = F)

	}
 
}


# Print some global statistics
cnvrs_exc <- cnvrs[!cnvrs$DISEASE %in% c("scoliosis"), ] 

print("###############################################")
print(paste0("Number of signals with at least one overlapping continuous trait CNV-GWAS signal: ", nrow(cnvrs[which(cnvrs$N_TOTAL != 0), ]), "/", nrow(cnvrs), " ( ", nrow(cnvrs_exc[which(cnvrs_exc$N_TOTAL != 0), ]), "/", nrow(cnvrs_exc),")" ))



#################################################
### Save ########################################

fwrite(cnvrs, "/cauwerx/gwas/08_ANNOVAR/combined/data/continuous_CNV_GWAS/00_continuous_CNV_GWAS_synonym_signals.txt", col.names = T, row.names = F, sep  = "\t", quote = F)
