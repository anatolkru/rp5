#!/bin/bash
echo "SET DATESTYLE TO GERMAN;" > wind.sql
for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
awk ' BEGIN { FS=";"}
gsub(/[0-9][0-9]:[0-9][0-9]/,"") {print $1 $8};
' $ids |sed 's/"//g'>2.csv

awk ' BEGIN { FS=" "; avr=0;id_stat='$ids';dat_prev="'$dat1'";}
{ 
dat=$1;

if ( dat == dat_prev)
 {  
 avr=avr+$2;
 num_avr++;
 dat_prev=dat;
 }

else 
 {
printf "select meteo_insert(\x27UPM000%s\x27, \x27%s\x27, \x27wind\x27, %.1f);\n ",id_stat,dat_prev,avr/num_avr;
    avr=$2; 
    num_avr=1; 
 dat_prev=dat;
 }

}
' 2.csv >> wind.sql
echo "insert wind into DB"
echo $ids
#export PGPASSWORD="der_parol" && psql -h localhost -U postgres -d pseed_db -f wind.sql >wind.log 
date
done
