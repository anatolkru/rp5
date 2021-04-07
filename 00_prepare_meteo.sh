#!/bin/bash
for ids in `ls 3[0-9][0-9][0-9][0-9]*\.gz`
do
gunzip $ids
done

rename 's/(3[0-9][0-9][0-9][0-9]).*.csv$/$1/' *

for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
echo $ids
sed -i '1,7d' $ids
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
done
