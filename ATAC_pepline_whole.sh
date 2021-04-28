#!/bin/bash
path=***/Cleandata
BT2_HOME=~/reference/mouse/bowtie2index_base
picardPath=/data1/yangk/software/picard/build/libs
GenrichPath=~/software/Genrich
awk 'BEGIN{FS="\t";OFS="\t";print "sample","all_reads","percent_duplication"}' > $path/stat_dup.report
cd $path
mkdir fastqc
fastqc -o $path/fastqc/ -t 20 *.fq.gz
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do cutadapt -j 30 --pair-filter=any --minimum-length 20 --max-n 8 -q 20  -a CTGTCTCTTATACACATCTCCGAGCCCACGAGAC -A CTGTCTCTTATACACATCTGACGCTGCCGACGA -o $path/${i}_rmadp_R1.fq.gz -p $path/${i}_rmadp_R2.fq.gz $path/${i}_1.fq.gz $path/${i}_2.fq.gz > $path/${i}_cutadapt.report
# statistics
grep 'Total read' $path/${i}_cutadapt.report |awk 'BEGIN{OFS="\t"}{print "'${i}'""total",$5}'>> $path/stat_cutadapt.report
bowtie2 --end-to-end --very-sensitive --dovetail -X 1000 -p 28 -x ${BT2_HOME}/mm10_base -1 $path/${i}_rmadp_R1.fq.gz -2 $path/${i}_rmadp_R2.fq.gz -S ${i}.sam >${i}_bowtie2.report
samtools sort -@ 30 -o ${path}/${i}_sorted.bam ${path}/${i}.sam
rm ${path}/${i}.sam
samtools index -@ 30  ${path}/${i}_sorted.bam
samtools idxstats ${path}/${i}_sorted.bam > ${path}/${i}_isxstats.report
samtools idxstats $path/${i}_sorted.bam|cut -f 1 |grep -v chrM |xargs samtools view -@ 50 -bh -f 3 -q 30 $path/${i}_sorted.bam > $path/${i}_filtered.bam
java -jar $picardPath/picard.jar MarkDuplicates I=$path/${i}_filtered.bam O=$path/${i}_rmdup.bam M=$path/${i}_dup.report REMOVE_DUPLICATES=true
# statistics
head -8 $path/${i}_dup.report|tail -1|awk 'BEGIN{FS="\t";OFS="\t"}{print "'${i}'",$3,$9}' >> $path/stat_dup.report
samtools sort -@ 30 -n -o ${i}_rmdup.sam -O SAM ${i}_rmdup.bam
$GenrichPath/Genrich -t ${i}_rmdup.sam -o $path/${i}.narrowpeak -j -f $path/${i}_peak.log -v
bamCoverage -b $path/${i}_rmdup.bam -o $path/${i}.bw -bs 1 --normalizeUsing RPKM -p 30
done
cat $path/*narrowpeak | cut -f1-3 | sort -k1,1 -k2,2n | bedtools merge -i - > path/merged.bed
awk 'BEGIN{OFS="\t"}{print $1"."$2"."$3,$1,$2,$3,"."}' merged.bed > merge_featurecounts.saf
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do featureCounts -T 30 -F SAF -a $path/merge_featurecounts.saf -o $path/peaks_count/${i}_ATAC.count $path/${i}_rmdup.bam;
done

