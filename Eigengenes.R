# Run this whole script before using the Run_eigengenie.R script

# Checks for necessary libraries and installs if missing
if (!require("BiocManager")){
  install.packages("BiocManager")
}
if(!require("WGCNA")){
  BiocManager::install("WGCNA")
}
if(!require("dplyr")){
  install.packages("dplyr")
}

# Useful cbind function
cbind.fill <- function(...){
  nm <- list(...) 
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  do.call(cbind, lapply(nm, function (x) 
    rbind(x, matrix(, n-nrow(x), ncol(x))))) 
}

# Loads required R packages
library(WGCNA)
library(dplyr)


# Initializes the Eigengenie function

Eigengenie <- function(dir,correlation="spearman",adjust="BH"){
# Sets directory to where your files are
setwd(dir)

# Loads in each file
counts <- t(read.csv(list.files(pattern="count"),header=T,row.names=1))
meta <- read.csv(list.files(pattern="meta"),header=T,row.names=1,stringsAsFactors = T)
meta <- meta %>% mutate_if(is.factor,as.numeric) # converts strings to numeric
modules <- read.csv(list.files(pattern="module"),header=T)
nSamples <- length(rownames(meta))

#initialize eigengene values DF
MEs <- data.frame()

for(mod in unique(modules$Module)){
temp.count <- counts[rownames(meta),colnames(counts) %in% modules[modules$Module==mod,1]]
temp.mod <- modules[modules$Module==mod,2][1:length(colnames(temp.count))]
# Calculates and orders module eigengenes and sorts
calc = orderMEs(moduleEigengenes(temp.count, temp.mod)$eigengenes)
MEs <- cbind.fill(MEs,calc)}

results <- list(
MEs,
moduleTraitCor = cor(MEs, meta, use = "p",method=correlation), 
moduleTraitPvalue = corPvalueStudent(moduleTraitCor, nSamples),
adjustedPvalue <- apply(moduleTraitPvalue,2,function(x){p.adjust(x,method=adjust)})
)

filenames <- c("Eigengenes","Correlations","Pvalues","Adj.Pvalues")

for(i in 1:4){
  write.csv(results[i],file=sprintf("Results_%s.csv",filenames[i]))
}


}
