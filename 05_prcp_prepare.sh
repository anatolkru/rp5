#!/bin/bash
echo "SET DATESTYLE TO GERMAN;" > prcp.sql
for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
awk ' BEGIN { FS=";"}
gsub(/[0-9][0-9]:[0-9][0-9]/,"") {print $1 $24};
' $ids |sed 's/"//g'|egrep '^..\...\..... [0-9]+\.[0-9]+'>2.csv
sed 's/\.\(.\)$/\1/g' 2.csv > 3.csv

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
   if ( dat_prev !="" ) {
     printf "select meteo_insert(\x27UPM000%s\x27, \x27%s\x27, \x27prcp\x27, %.0f);\n ",id_stat,dat_prev,avr;
    }
 avr=$2; 
 dat_prev=dat;
 }

}
' 3.csv >> prcp.sql
echo "insert prcp into DB"
echo $ids
done
date
#psql -U $PGUSER -h $PGHOST -d $PGDATABASE -f prcp.sql > prcp.log
date
