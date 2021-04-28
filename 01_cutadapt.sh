#!/bin/bash
path=***/Cleandata
cd $path
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do cutadapt -j 30 --pair-filter=any --minimum-length 20 --max-n 8 -q 20  -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -A CTGTCTCTTATACACATCTGACGCTGCCGACGA -o $path/${i}_rmadp_R1.fq.gz -p $path/${i}_rmadp_R2.fq.gz $path/${i}_1.fq.gz $path/${i}_2.fq.gz > $path/${i}_cutadapt.report
# statistics
grep 'Total read' $path/${i}_cutadapt.report |awk 'BEGIN{OFS="\t"}{print "'${i}'""total",$5}'>> $path/stat_cutadapt.report;
done
