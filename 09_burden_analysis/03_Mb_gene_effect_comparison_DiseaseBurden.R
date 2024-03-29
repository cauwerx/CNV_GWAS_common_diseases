# Compare the Mb vs. Gene burden effects through simulation analyses (disease burden).

#################################################
### Libraries & Paramteres ######################
library(data.table)
library(dplyr)

set.seed(8)
n <- 10000



#################################################
### STEP 1: Load data ###########################

# Genome-wide data
genome_size <- 3137161264 # UCSC GRCh37
hgnc_genes <- as.data.frame(fread("/cauwerx/softwares/ANNOVAR-20191024/humandb/hg19_refGene.txt"))

# Burden effects; Files generated by "09_burden_analysis/01_CNV_burden_DiseaseBurden.R"
burden_DEL <- as.data.frame(fread("/cauwerx/gwas/09_burden_analysis/data/no_CNVR_correction/DEL_burden_analysis_DiseaseBurden.txt", select = c(2,5,6)))
burden_DUP <- as.data.frame(fread("/cauwerx/gwas/09_burden_analysis/data/no_CNVR_correction/DUP_burden_analysis_DiseaseBurden.txt", select = c(2,5,6)))



#################################################
### STEP 2: Calculate GW gene density ###########

# Unique number of genes --> 28265 entities
u_genes <- unique(hgnc_genes$V13)

# Exclude MIRs --> 26289 entities
u_genes <- u_genes[grep("^MIR", u_genes, invert = T)]

# Calculate genome-wide gene density
gw_denisty <- length(u_genes)/(genome_size/1000000)
print(paste0("Estmiated GW gene density: ", round(gw_denisty, 2)))



#################################################
### STEP 3: Sig. gene density differences #######

# Simulations (from a Gaussian distribution)
sim_mb_DEL <- rnorm(n, mean = burden_DEL[which(burden_DEL$BURDEN == "Mb"), "BETA"], sd = burden_DEL[which(burden_DEL$BURDEN == "Mb"), "SE"])
sim_genes_DEL <- rnorm(n, mean = burden_DEL[which(burden_DEL$BURDEN == "GENES"), "BETA"], sd = burden_DEL[which(burden_DEL$BURDEN == "GENES"), "SE"])
sim_mb_DUP <- rnorm(n, mean = burden_DUP[which(burden_DUP$BURDEN == "Mb"), "BETA"], sd = burden_DUP[which(burden_DUP$BURDEN == "Mb"), "SE"])
sim_genes_DUP <- rnorm(n, mean = burden_DUP[which(burden_DUP$BURDEN == "GENES"), "BETA"], sd = burden_DUP[which(burden_DUP$BURDEN == "GENES"), "SE"])

# Calculate simulated ratios of Mb-to-gene effects
ratio_DEL <- sim_mb_DEL/sim_genes_DEL
ratio_DUP <- sim_mb_DUP/sim_genes_DUP

# Estimate the SD of the simulated ratios
SD_DEL <- sd(ratio_DEL)
print(paste0("SD for DEL analysis: ", SD_DEL))
SD_DUP <- sd(ratio_DUP)
print(paste0("SD for DUP analysis: ", SD_DUP))

# Calculate a t statistic (~1 sample t-test, SD of the true ratio can be ignored)
t_DEL <- (gw_denisty-(burden_DEL[which(burden_DEL$BURDEN == "Mb"), "BETA"]/burden_DEL[which(burden_DEL$BURDEN == "GENES"), "BETA"]))/SD_DEL
print(paste0("t for DEL analysis: ", t_DEL))
t_DUP <- (gw_denisty-(burden_DUP[which(burden_DUP$BURDEN == "Mb"), "BETA"]/burden_DUP[which(burden_DUP$BURDEN == "GENES"), "BETA"]))/SD_DUP
print(paste0("t for DUP analysis: ", t_DUP))

# Calculate an associated p-value (two-sided)
p_DEL <- 2*pnorm(-abs(t_DEL), mean = 0, sd = 1)
print(paste0("p-value for DEL analysis: ", p_DEL))
p_DUP <- 2*pnorm(-abs(t_DUP), mean = 0, sd = 1)
print(paste0("p-value for DUP analysis: ", p_DUP))
