#!/bin/bash
path=***/Cleandata
mkdir motif
for i in `ls *_1.fq.gz |cut -d _ -f1`;
do findMotifsGenome.pl $path/${i}.narrowpeak mm10 $path/motif/${i}/ -size given -mask;
done
