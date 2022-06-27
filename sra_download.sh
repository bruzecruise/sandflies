#!/bin/bash
#$ -M mhuang6@nd.edu
#$ -m abe
#$ -r y
#$ -pe smp 24
#$ -q long
#$ -N sre

conda activate SRAtools

DIR="/afs/crc.nd.edu/group/Leishlab/UpdatedPopGen"
THREAD="24"

# this loop cats file then for each line in the file 
# prefetch, download fastq, gzip read1 and read2, and remove SRR file

cat SRA_download.txt | while read line;
do
   prefetch ${line};
   fasterq-dump --threads ${THREAD} ${line};
   gzip ${line}_*;
   rm ${line};
done

echo "woo done!"
