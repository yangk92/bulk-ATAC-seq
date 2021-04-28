#!/bin/bash
path=***/Cleandata
cat $path/*narrowpeak | cut -f1-3 | sort -k1,1 -k2,2n | bedtools merge -i - > path/merged.bed
awk 'BEGIN{OFS="\t"}{print $1"."$2"."$3,$1,$2,$3,"."}' merged.bed > merge_featurecounts.saf
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do featureCounts -T 30 -F SAF -a $path/merge_featurecounts.saf -o $path/peaks_count/${i}_ATAC.count $path/${i}_rmdup.bam;
done

