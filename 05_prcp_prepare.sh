#!/bin/bash
echo "SET DATESTYLE TO GERMAN;" > prcp.sql
for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
awk ' BEGIN { FS=";"}
gsub(/[0-9][0-9]:[0-9][0-9]/,"") {print $1 $24};
' $ids |sed 's/"//g'>2.csv

awk ' BEGIN { FS=" "; avr=0;id_stat='$ids';dat_prev="'$dat1'";}
{ 
dat=$1;

if ( dat == dat_prev)
 {  
 avr=avr+$2;
 dat_prev=dat;
 }

else 
 {
printf "select meteo_insert(\x27UPM000%s\x27, \x27%s\x27, \x27prcp\x27, %.1f);\n ",id_stat,dat_prev,avr;
    avr=$2; 
 dat_prev=dat;
 }

}
' 2.csv >> tavg.sql
echo "insert tavg into DB"
echo $ids
#export PGPASSWORD="der_parol" && psql -h localhost -U postgres -d pseed_db -f tavg.sql >tavg.log 
date
done
