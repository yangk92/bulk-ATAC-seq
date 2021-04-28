#!/bin/bash
path=***/Cleandata
picardPath=/data1/yangk/software/picard/build/libs
cd $path
for i in `ls *_1.fq.gz |cut -d _ -f1`;
awk 'BEGIN{FS="\t";OFS="\t";print "sample","all_reads","percent_duplication"}' > $path/stat_dup.report
do samtools idxstats $path/${i}_sorted.bam|cut -f 1 |grep -v chrM |xargs samtools view -@ 50 -bh -f 3 -q 30 $path/${i}_sorted.bam > $path/${i}_filtered.bam
java -jar $picardPath/picard.jar MarkDuplicates I=$path/${i}_filtered.bam O=$path/${i}_rmdup.bam M=$path/${i}_dup.report REMOVE_DUPLICATES=true
# statistics
head -8 $path/${i}_dup.report|tail -1|awk 'BEGIN{FS="\t";OFS="\t"}{print "'${i}'",$3,$9}' >> $path/stat_dup.report;
done
