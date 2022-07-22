#!/bin/bash
#$ -M dbruzzes@nd.edu
#$ -m abe
#$ -r y
#$ -pe smp 12
#$ -q long
#$ -N kraken

DIR="/afs/crc.nd.edu/group/Leishlab/vol01/brazil/trimmed_fastq"
THREAD="12"
database="/afs/crc.nd.edu/group/Leishlab/vol01/kraken2_db"

cd $DIR
mamba activate kraken 

# kraken loop
for FILE in $(find trim1*_1.fq.gz | sed 's/_1.fq.gz//' | sed 's/trim1.//');
do kraken2 --use-names --threads ${THREAD} --db ${database} --confidence 0.1 --report ../kraken/kraken.${FILE} --paired trim1.${FILE}_1.fq.gz trim1.${FILE}_2.fq.gz; done

echo "wooo done with kraken"

cd $DIR 
cd ../kraken/
mkdir bracken

# bracken loop for species level
for FILE in $(find kraken.*); do bracken -d ${database} -i ${FILE} -l S -o ./bracken_species/bracken.${FILE} -t 10 -r 75; done

echo "wooo done with bracken"

cd ./bracken_species/

# concatinate # fix names... 
mamba activate bit
paste <( find bracken*) > sample-name-map
bit-combine-bracken-and-add-lineage -i sample-name-map -o species_bracken.txt

head species_bracken.txt | column -ts $'\t'
