#!/bin/bash
path=***/Cleandata
cd $path
BT2_HOME=~/reference/mouse/bowtie2index_base
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do bowtie2 --end-to-end --very-sensitive --dovetail -X 1000 -p 28 -x ${BT2_HOME}/mm10_base -1 $path/${i}_rmadp_R1.fq.gz -2 $path/${i}_rmadp_R2.fq.gz -S ${i}.sam >${i}_bowtie2.report;
done
