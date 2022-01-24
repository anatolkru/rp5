#!/bin/bash
echo "SET DATESTYLE TO GERMAN;" > pres.sql
for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
awk ' BEGIN { FS=";"}
gsub(/[0-9][0-9]:[0-9][0-9]/,"") {print $1 $3};
' $ids |sed 's/"//g'|grep -v '^..\...\..... *$'>2.csv

awk ' BEGIN { FS=" "; avr=0;id_stat='$ids';dat_prev="'$dat1'";}
{ 
dat=$1;

if ( dat == dat_prev)
 {  
   if ( $2 != "" ) {
      avr=avr+$2;
      num_avr++;
   }
 dat_prev=dat;
 }
else 
 {
    if ( avr/num_avr > 0  ) {
     printf "select meteo_insert(\x27UPM000%s\x27, \x27%s\x27, \x27pres\x27, %.0f);\n ",id_stat,dat_prev,avr/num_avr;
    }
 avr=$2; 
 num_avr=1; 
 dat_prev=dat;
 }

}
' 2.csv >> pres.sql
echo "insert pres into DB"
echo $ids
done
date
#psql -U $PGUSER -h $PGHOST -d $PGDATABASE -f pres.sql > pres.log
date
