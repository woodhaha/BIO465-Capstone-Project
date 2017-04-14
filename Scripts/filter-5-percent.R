# Filter features that are in more than 5% of samples

# setwd("/Users/meganmcghie/Documents/School/Winter2017/BIO465/project/BIO465-Capstone-Project/Scripts")

# Load required libraries
source('shun.R')
use.package(magrittr)
use.package(dplyr)
use.package(tidyr)

mutations <- import.data("../Data/mutations_filtered.tsv")
copy.nums <- import.data("../Data/copy_nums_filtered.tsv")

sum.mutations <- mutations %>% mutate(sum=rowSums(floor(.[2:length(.)]), na.rm=T)) %>% select(sample, sum) %>% arrange(desc(sum))

sum.copy.nums <- copy.nums %>% mutate(sum=rowSums(floor(.[2:length(.)]), na.rm=T)) %>% select(`Gene Symbol`, sum) %>% arrange(desc(sum))

cutoff.low <- ceiling((0.05)*length(mutations))
cutoff.high <- length(mutations) - cutoff.low

mutations.keep <- sum.mutations %>% filter(sum >= cutoff.low & sum <= cutoff.high)#
# copy.nums.keep <- 

chr.regions <- import.data("../Data/chrom_regions")

chr.regions %>% mutate(region=paste0(chromosome_name, sub("^([pq]).*", "\\1", band))) %>% select(hgnc_symbol, region)

copy.nums %>% rename(gene=`Gene Symbol`) %>% gather(id, value, -gene)
