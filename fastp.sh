#!/bin/bash
#$ -M dbruzzes@nd.edu
#$ -m abe
#$ -r y
#$ -pe smp 12
#$ -q long
#$ -N fastp

mamba activate fastp 

# variables to change
DIR="/afs/crc.nd.edu/group/Leishlab/vol01/brazil/trimmed_fastq"
THREAD="12"

cd $DIR 

# fastp_adapter.fasta
printf ">Illumina_R1_adapterReadthru\nAGATCGGAAGAGCACACGTCTGAACTCC\n" > fastp_adapter.fasta
printf ">truueseq_read2_adapterReadthru\nAGATCGGAAGAGCGTCGTGTAGGGAA\n" >> fastp_adapter.fasta 
printf ">polyA\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n" >> fastp_adapter.fasta


# trim to q20 and length 25. Use adapter file created above 
# this loop runs through all files in the RAW_fastq folder
for FILE in $(find ../RAW_fastq/*_1.fastq.gz | sed 's/_1.fastq.gz//' | sed 's/\.\.\/RAW_fastq\///');
do 
    fastp --thread ${THREAD} -q 20 -l 25 --in1 ../RAW_fastq/${FILE}_1.fastq.gz --in2 ../RAW_fastq/${FILE}_2.fastq.gz --out1 trim1.${FILE}_1.fastq.gz --out2 trim1.${FILE}_2.fq.gz --adapter_fasta fastp_adapter.fasta -h ${FILE}.html; 
done

echo "woo done"
