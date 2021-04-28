#!/bin/bash
path=***/Cleandata
cd $path
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do bamCoverage -b $path/${i}_rmdup.bam -o $path/${i}.bw -bs 1 --normalizeUsing RPKM -p 30;
done
