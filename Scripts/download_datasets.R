# This script will download the required datasets to the DATA_DIR directory

# Load required packages
source('shun.R')
use.package(httr, from="github", author="hadley")


# Breast cancer URL
URL <- "https://tcga.xenahubs.net/download/TCGA.BRCA.sampleMap"

# URL for data sets
MUTATIONS_FILE <- "mutation_curated_wustl_gene"
COPY_NUMS_FILE <- "Gistic2_CopyNumber_Gistic2_all_thresholded.by_genes"
PHENOTYPE_FILE <- "BRCA_clinicalMatrix"


## Download data
files <- c(PHENOTYPE_FILE, MUTATIONS_FILE, COPY_NUMS_FILE)

for (file in files) {
  file.url <- file.path(URL, file)
  file.out <- file.path(DATA_DIR, file)
  GET(file.url, write_disk(file.out, overwrite=TRUE))
}