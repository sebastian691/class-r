#fastqc data
fastq {1}/*.fastq
#hacer trimmed
mkdir ${1}/trimmed for f in ${1}/*.fastq do srr=$(basename ${f}_1.fastq.gz) trimmomatic PE \ 
$f ${1}/${srr}_2.fastq ${1}/${srr}_1_trimmed.fastq ${1}/${srr}_1_untrimmed.fastq 
${1}/${srr}_2_trimmed.fastq ${1}/${srr}_2_untrimeed.fastq" done mv ${1}/trimmed $(dirname 
${1})
#index with bwa !/usr/bi/env bash
bwa mem GCA_000017985.1_ASM1798v1_genomic.fna sub/SRR2584863_1.trim.sub.fastq 
sub/SRR2584863_2.trim.sub.fastq > alin.sam samtools view -S -b alin.sam > alin2.bam samtools 
sort -o alin2_sort.bam alin2.bam bcftools mpileup -O b -oSRR2584863.bcf -f 
GCA_000017985.1_ASM1798v1_genomic.fna alin2_sort.bam bcftools call --ploidy 1 -m -v -o 
SRR2584863_variants.bcf SRR2584863.bcf bcftools view SRR2584863_variants.bcf
vcfutils.pl varFilter SRR2584863_variants.bcf > SRR2584863_final_variants.vcf

#assembler
for k in 'seq 15 3 45'; do
 abyss-pe k=$k name=ensamblajek$k in='test-data/reads1.fastq test-data/reads2.fastq' head -1 
ensamblajek15.stats > allteststats grep scaffolds.fa ensamblaje*stats >> allteststats
#combinar variantes y metadatos
variants <- read.csv("/home/dcuser/r_data/combined_tidy_vcf.csv") ecoli_met_data <- 
read.csv("/home/dcuser/Ecoli_metadata_composite.csv") variants_w_metadata <- 
left_join(variants,ecoli_met_data, by = c("sample_id"="run")) variants_w_metadata %>% 
group_by(sample_id,cit) %>% tally
#estadisticas de ensamblaje lea las estadisticas de ensamblaje
assembly_stats <- reads.csv ("assembly/allteststats", sep="\t") assembly_stats2 <- 
separate(assembly_stats,n,c("name","n"), sep=";")
#make sure your table shows the k value so you ca plot it plot N50 adn total length as a 
#function of k
library(dplyr) library(tidyr) assembly_stats <- read.csv 
("home/dcuser/shell_data/untrimmed_fastq/trimmed/assembly/allteststats", sep="\t")
assembly_stats2 <- separate (assembly_stats,n,c("name","n"), sep=";") 
