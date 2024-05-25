#!/bin/bash 

## ENA-deposited reads are already trimmed
R1=ERR037572_1.fastq.gz ## download: ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR037/ERR037572/ERR037572_1.fastq.gz
R2=ERR037572_2.fastq.gz ## download: ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR037/ERR037572/ERR037572_2.fastq.gz

## change the number of CPUS to what you have available 
## inflate the fasta from /data of this repo
CPUS=32

unicycler -t $CPUS --verbosity 2 --mode normal -1 $R1 -2 $R2 -o D24359.uni.out &> unicycler.log
cp D24359.uni.out/assembly.fasta D24359.unicycler.fa

ragout.py -t $CPUS ent_4st.rcp --outdir D24359.rag.out --refine &> ragout.log 
cp D24359.rag.out/D24359_scaffolds.fasta D24359.ragout.fa 

prokka --rawproduct --cpus $CPUS --outdir D24359.prokka.out --prefix D24359 --locustag D24359 --proteins WP_combo_v2.tlda.fa D24359.ragout.fa
