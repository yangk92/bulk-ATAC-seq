#!/bin/bash
path=***/Cleandata
cd $path
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do samtools sort -@ 30 -o ${path}/${i}_sorted.bam ${path}/${i}.sam
rm ${path}/${i}.sam
samtools index -@ 30  ${path}/${i}_sorted.bam
samtools idxstats ${path}/${i}_sorted.bam > ${path}/${i}_isxstats.report;
done
