# Here is the Eigengenie function with example arguments:

# Eigengenie(dir="C:/Users/grrompala/Desktop/name_of_dir",
#             correlation="spearman",
#             adjust="BH")

# The directory (dir) needs to have three csv files: 
# metadata.csv,gene_module_memberships.csv,normalized_gene_counts.csv
# See files in the example folder for formatting

#optional correlation argument can be "spearman" (default) or "pearson"

#optional adjust argument refers to multiple comparison correction tests
# Options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY","fdr","none"
# "BH" is default


Eigengenie(dir,correlation="spearman",adjust="BH")

# Running the function will output 4 files -- eigengene values, cor. coefficients, pvalues, 
# and adjusted p values to the designated directory (dir)