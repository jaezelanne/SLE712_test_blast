#!/bin/bash

#download the genome sequence
URL="ftp://ftp.ensemblgenomes.org/pub/bacteria/release-42/fasta/bacteria_0_collection/escherichia_coli_str_k_12_substr_mg1655/cds/Escherichia_coli_str_k_12_substr_mg1655.ASM584v2.cds.all.fa.gz"
wget -N "$URL"

#unzip the genome sequence
gunzip -kf Escherichia_coli_str_k_12_substr_mg1655.ASM584v2.cds.all.fa.gz

#create a blast index
formatdb -p F -o T -i Escherichia_coli_str_k_12_substr_mg1655.ASM584v2.cds.all.fa

#Make mutations
msbar -sequence mysample.fa -count 500 -point 4 -block 0 -codon 0 -outseq mysample_mutated.fa

#Pairwise Alignment of original and mutated sequences
water -asequence mysample.fa -bsequence mysample_mutated.fa

#Run BLAST while printing only the e-value and Bit-scores, automatically saves the results in Blast_Result.txt
blast2 -p blastn -e 0.001 -m 8 -d Escherichia_coli_str_k_12_substr_mg1655.ASM584v2.cds.all.fa -i mysample_mutated.fa -o /dev/stdout | awk '{print $11, $12}' >> Blast_Result.txt

#View Results
cat Blast_Result.txt

