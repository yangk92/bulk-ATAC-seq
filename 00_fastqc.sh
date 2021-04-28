#!/bin/bash
path=***/Cleandata
cd $path
mkdir fastqc
for i in `ls *.fq.gz`;
do fastqc -o $path/fastqc/ -t 20 $i;
done
