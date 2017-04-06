# Settings -------------------------------------------------

# Helper function to create directory if it doesn't exist
create.dir <- function(dirname) {
  if (!dir.exists(dirname))
    dir.create(dirname)
}

# Directory that will hold the data
DATA_DIR <- "../Data"
create.dir(DATA_DIR)

# Directory that will hold the figures
FIG_DIR <- "../Figures"
create.dir(FIG_DIR)




# Working with packages -------------------------------------------------

# Helper function to load R packages and install if not installed
use.package <- function(pkg, from="cran", author=NA) {
  pkg <- gsub("\"", "", deparse(substitute(pkg)))
  from <- gsub("\"", "", deparse(substitute(from)))
  if (!(pkg %in% installed.packages()[,"Package"])) {
    if (from == "bioc") {
      if (!exists("biocLite"))
        source("https://bioconductor.org/biocLite.R")
      biocLite(pkg)
    } else if (from == "github") {
      if (!exists("install_github"))
        use.package("devtools")
      author <- gsub("\"", "", deparse(substitute(author)))
      if (author == "NA")
        stop("Please specify an author")
      install_github(paste(repo, pkg, sep="/"))
    } else {
      install.packages(pkg)
    }
  }
  require(pkg, character.only=TRUE)
}

# Helper function to detach R packages
detach.package <- function(pkg, character.only = FALSE) {
  pkg <- gsub("\"", "", deparse(substitute(pkg)))
  search_item <- paste("package", pkg, sep = ":")
  while(search_item %in% search())
  {
    detach(search_item, unload = TRUE, character.only = TRUE)
  }
}




# Load required packages ----------------------------------------

use.package(ggplot2)
use.package(fst)
use.package(readr)
use.package(tools)

# Saving Figures ------------------------------------------

# Saves the last ggplot figure that was created to dir
save.figure <- function(filename, dir=FIG_DIR) {
  ggsave(file.path(dir, filename))
}



# Importing and Saving Data Frames ----------------------------------------

# Will read in a  tsv file from dir as a data.frame
# If there is a .fst file, it will load that for faster loading
import.data <- function(filename, dir=DATA_DIR) {
  path <- file.path(dir, filename)
  fstfile <- paste0(path, ".fst")
  if (file.exists(fstfile))
    read.fst(fstfile)
  else {
    x <- read_tsv(file.path(directory, filename)) 
    write.fst(x, fstfile, compress=100)
    x
  }
}



# Will save the data.frame x to dir as fst or tsv specified by ext
save.data <- function(x, filename, dir=DATA_DIR, compress=100, ext="fst") {
  filename.ext <- file_ext(filename)
  if (filename.ext == "fst")
    ext <- "fst"
  else if (filename.ext == "tsv")
    ext <- "tsv"
  else
    filename <- paste0(filename, ext)
  path <- file.path(dir, filename)
  if (ext == "fst") {
    write.fst(x, path, compress)  
  } else if (ext == "tsv") {
    write.table(x, file=path, quote=FALSE, sep="\t", row.names=FALSE)
  } else {
    stop("Argument 'ext' must be one of: 'fst', 'tsv'")
  }
}


# Misc --------------------------------------------------------

# Takes a vector of strings and\or expressions and returns vector of strings
cs <- function(...) {
  sapply(substitute(c(...)), function(x) gsub("\"", "", deparse(x)))[-1]
}