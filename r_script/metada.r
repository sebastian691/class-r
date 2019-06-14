#estadisticas de ensamblaje lea las estadisticas de ensamblaje
assembly_stats <- reads.csv ("assembly/allteststats", sep="\t") assembly_stats2 <- 
separate(assembly_stats,n,c("name","n"), sep=";")
#make sure your table shows the k value so you ca plot it plot N50 adn total length as a 
#function of k
library(dplyr) library(tidyr) assembly_stats <- read.csv 
("home/dcuser/shell_data/untrimmed_fastq/trimmed/assembly/allteststats", sep="\t")
assembly_stats2 <- separate (assembly_stats,n,c("name","n"), sep=";") 
