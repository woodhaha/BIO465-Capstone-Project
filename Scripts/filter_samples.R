# Get overlapping sample IDs across the three data sets

# Load required libraries
source('shun.R')
use.package(magrittr)
use.package(dplyr)

# Read in raw data
phenotype.raw <- import.data("../Data/BRCA_clinicalMatrix")
mutations.raw <- import.data("../Data/mutation_curated_wustl_gene")
copy_nums.raw <- import.data("../Data/Gistic2_CopyNumber_Gistic2_all_thresholded.by_genes")


# Get sample ids
phenotype.ids <- phenotype.raw %>% filter(age_at_initial_pathologic_diagnosis < 80) %>% `$`(sampleID)
mutations.ids <- colnames(mutations.raw)[-1]
copy_nums.ids <- colnames(copy_nums.raw)[-1]


# Find common sample IDs across the three datasets
common.ids <- Reduce(intersect, list(phenotype.ids, mutations.ids, copy_nums.ids))


# Filter the datasets
phenotype.filtered <- phenotype.raw %>% filter(sampleID %in% common.ids)
mutations.filtered <- mutations.raw %>% select(sample, one_of(common.ids))
copy_nums.filtered <- copy_nums.raw %>% select(`Gene Symbol`, one_of(common.ids))


# Save filtered datasets
save.data(phenotype.filtered, filename="phenotype_filtered.tsv")
save.data(mutations.filtered, filename="mutations_filtered.tsv")
save.data(copy_nums.filtered, filename="copy_nums_filtered.tsv")
