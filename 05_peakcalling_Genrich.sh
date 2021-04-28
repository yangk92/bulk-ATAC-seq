#!/bin/bash
path=***/Cleandata
GenrichPath=~/software/Genrich
cd $path
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do samtools sort -@ 30 -n -o ${i}_rmdup.sam -O SAM ${i}_rmdup.bam
 $GenrichPath/Genrich -t ${i}_rmdup.sam -o $path/${i}.narrowpeak -j -f $path/${i}_peak.log -v;
done
