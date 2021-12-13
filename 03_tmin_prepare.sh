#!/bin/bash
echo "SET DATESTYLE TO GERMAN;" > tmin.sql
for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
awk ' BEGIN { FS=";"}
gsub(/[0-9][0-9]:[0-9][0-9]/,"") {print $1 $2};
' $ids |sed 's/"//g'>2.csv
sed 's/\.\(.\)$/\1/g' 2.csv > 3.csv

awk ' BEGIN {FS=" ";min=1000;id_stat='$ids';dat_prev="'$dat1'";}
{ 
dat=$1
val=$2
if ( dat == dat_prev)
 {  
  if ( min >= val )
    {
     min=val;
    }
  dat_prev=dat;
 }
else 
 {
  printf "select meteo_insert(\x27UPM000%s\x27, \x27%s\x27, \x27tmin\x27, %s);\n ",id_stat,dat_prev,min;
  dat_prev=dat;
  min=$2
 }
 #print ("dat=", dat_prev," val=",val," min=", min, " -------- ",$2)
}
' 3.csv >> tmin.sql
echo $ids
done
date
echo "insert tmin into DB"
#psql -U $PGUSER -h $PGHOST -d $PGDATABASE -f tmin.sql > tmin.log
date
