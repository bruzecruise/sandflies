#!/bin/bash
#$ -M dbruzzes@nd.edu
#$ -m abe
#$ -r y
#$ -pe smp 24
#$ -q long
#$ -N pipetest

mamba activate fastp 

# variables to change
DIR="/afs/crc.nd.edu/user/d/dbruzzes/Public/220517_Feder_RAD_700-1kbp_cut/federOG"
THREAD="24"
REF_GENOME="/afs/crc.nd.edu/user/d/dbruzzes/Public/GCA_001412515.3_Dall2.0_genomic.fasta"
READ1="/afs/crc.nd.edu/user/d/dbruzzes/Public/220517_Feder_RAD_700-1kbp_cut/TS-index-1_S1_L001_R1_001.fastq.gz"
READ2="/afs/crc.nd.edu/user/d/dbruzzes/Public/220517_Feder_RAD_700-1kbp_cut/TS-index-1_S1_L001_R2_001.fastq.gz"
NAME="FOGTest"

########################********* 3 - map reads to ref **************************
mamba activate mapping

bwa-mem2 index ${REF_GENOME}
# loop to map all demux fastq files to ref genome and drop unmapped reads and dedup reads 
mkdir mapped_reads
cd mapped_reads
mkdir dedup
for FILE in $(find ../*_1.fastq.gz | sed 's/_1.fastq.gz//'| sed 's/\.\.\///' | sed 's/demux_barcode_//');
do bwa-mem2 mem -t ${THREAD} ${REF_GENOME} ../demux_barcode_${FILE}_1.fastq.gz ../demux_barcode_${FILE}_2.fastq.gz | samtools view -Sbh -q 20 -F 0x4 - --threads ${THREAD} | \
samtools fixmate --threads ${THREAD} -m - - | samtools sort --threads ${THREAD} - -o ${FILE}.mapped.sort.bam;
samtools markdup --threads ${THREAD} ${FILE}.mapped.sort.bam ${FILE}.mapped.sort.dedup.bam;
mv ${FILE}.mapped.sort.dedup.bam ./dedup;
done

echo "************************mapped reads to ref and deduplicated them****************************"

#############################************** 4- sticks on RG info ***********
cd ./dedup
mkdir RG
for FILE in $(find *.mapped.sort.dedup.bam | sed 's/.mapped.sort.dedup.bam//'| sed 's/demux_//'); 
do echo $FILE; 
RG="@RG\tID:${FILE}_${NAME}\tSM:${FILE}\tPL:ILLUMINA"; 
echo ${RG}; 
samtools addreplacerg ${FILE}.mapped.sort.dedup.bam -r ${RG} --threads ${THREAD} -o ${FILE}.rg.dd.map.bam; #works
samtools view -H ${FILE}.rg.dd.map.bam | grep "@RG";
mv ${FILE}.rg.dd.map.bam ./RG; done 

echo "*****************************added read group info to each bam file*************************************"
echo "DONE YEEES!!!!!!"
