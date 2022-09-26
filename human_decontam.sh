#!/bin/bash
#$ -M dbruzzes@nd.edu
#$ -m abe
#$ -r y
#$ -pe smp 24
#$ -q long
#$ -N h_decon

DIR="/afs/crc.nd.edu/group/Leishlab/vol01/brazil/trimmed_fastq/decontam_human"
THREAD="24"
REF_GENOME="/afs/crc.nd.edu/user/d/dbruzzes/sandfly/human_ref/GCA_009914755.4_T2T-CHM13v2.0_genomic.fna.gz"

mamba activate mapping
cd $DIR

# map reads to human ref genome and drop all mapped reads - make sure f flag in samtools view is lowercase
printf "status\n" > log.txt
for FILE in $(find ../*_1.fq.gz | sed 's/_1.fq.gz//'| sed 's/\.\.\///' | sed 's/trim1.//');
do bwa-mem2 mem -t ${THREAD} ${REF_GENOME} ../trim1.${FILE}_1.fq.gz ../trim1.${FILE}_2.fq.gz | samtools view -Sbh -f 0x4 - --threads ${THREAD} | \
samtools sort --threads ${THREAD} - -o ${FILE}.mapped.sort.bam;
printf "$FILE is aligned \n" >> log.txt;
samtools bam2fq ${FILE}.mapped.sort.bam -1 h_decon.trim.${FILE}_1.fq.gz -2 h_decon.trim.${FILE}_2.fq.gz -@ ${THREAD};
printf "$FILE is fastq \n" >> log.txt ;
rm ${FILE}.mapped.sort.bam;
done
