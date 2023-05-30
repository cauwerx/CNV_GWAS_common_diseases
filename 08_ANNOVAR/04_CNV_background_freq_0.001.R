# Annotate genes with a CNV frequency of at least 0.001%.

#################################################
### Libraries ###################################
library(data.table)
library(dplyr)



#################################################
### STEP 1: Load data ###########################

# Load all genotype frequencies; Generation of this file is described in Auwerx et al., 2022 (script "GWAS/02_probes/frequency/03_genotype_frequency_All.R")
freq <- as.data.frame(fread("/data/UKBB/cnv_calls/genotype_frequency/genotype_freq_WB_All.txt.gz", header = T))
freq$Chr <- gsub("XY", "X", freq$Chr)

# Load all probes & merge it to frequency data; This file contains the rs ID and position of all probes on the genotype array, available from the UKBB portal
probes <- as.data.frame(fread("/data/general_data/UKBB/probes.txt.gz", header = T))
probes$Chr <- gsub("23", "X", probes$Chr)
freq <- right_join(probes, freq, by = c("SNP", "Chr"))



#################################################
### STEP 2: Define CNV regions ##################

# Create a dataframe to store the results & set counter to 1
cnvrs <- data.frame()
count <- 1

# Loop over the frequency file to detect CNV regions
for (chr in unique(freq$Chr)) {

	# Subset data for the analyzed chromosome and order it
	freq_chr <- freq[which(freq$Chr == chr), ]
	freq_chr <- freq_chr[order(freq_chr$Position), ]

	# Determine which probes have a frequency >= 0.01%
	freq_chr$FREQ <- 0
	freq_chr[which(freq_chr$FreqCNV >= 0.01), "FREQ"] <- 1

	# Calculate the run length encoding 
	rl <- rle(freq_chr$FREQ)

	# Loop over the rl file to determine stretches that reach the threshold CNV frequency
	for(i in 1:length(rl$values)) {

		# Skip if the frequency is not reached for a given stretch
		if(rl$values[i] == 0) {next}

		# If the frequency is reached, retain the region's coordinates
		if(rl$values[i] == 1) {

			cnvrs[count, "CHR"] <- chr
			if(i == 1) {cnvrs[count, "START"] <- freq_chr[1, "Position"]}
			if(i > 1) {cnvrs[count, "START"] <- freq_chr[sum(rl$lengths[1:(i-1)]) + 1, "Position"]}
			cnvrs[count, "END"] <- freq_chr[sum(rl$lengths[1:i]), "Position"]
			cnvrs[count, "REF"] <- 0
			cnvrs[count, "ALT"] <- "-"

		# Increase the counter
		count <- count + 1

		}		
	}
}

# Save temporary file for ANNOVAR annotation
annovar_input <- "/cauwerx/gwas/08_ANNOVAR/combined/data/temp/gene_annotation/ANNOVAR_input_Bckg_CNVR.txt"
fwrite(cnvrs, annovar_input, col.names = F, row.names = F, quote = F, sep = "\t")



#################################################
### STEP 2: Run ANNOVAR #########################

# Run ANNOVAR in terminal - HGNC
output_HGNC <- "/cauwerx/gwas/08_ANNOVAR/combined/data/background_CNVR/ANNOVAR_Bckg_CNVR_HGNC"
system(paste("/cauwerx/softwares/ANNOVAR-20191024/annotate_variation.pl",
			 "--geneanno -dbtype refGene",
			 "-out", output_HGNC, 
		     "-build hg19", 
			 annovar_input,
			 "/cauwerx/softwares/ANNOVAR-20191024/humandb/"))
unlink(paste0(output_HGNC, ".log"))
