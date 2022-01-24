#!/bin/bash
echo "SET DATESTYLE TO GERMAN;" > tmax.sql
for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
awk ' BEGIN { FS=";"}
gsub(/[0-9][0-9]:[0-9][0-9]/,"") {print $1 $2};
' $ids |sed 's/"//g'>2.csv
sed 's/\.\(.\)$/\1/g' 2.csv > 3.csv

awk ' BEGIN { FS=" ";max=$2;id_stat='$ids';dat_prev="'$dat1'";}
{ 
dat=$1
val=$2
if ( dat == dat_prev)
 {  
   if ( max<val )
    {
     max = val;
    }
 dat_prev=dat;
 }
else 
 {
  if ( dat_prev !="" ) {
    printf "select meteo_insert(\x27UPM000%s\x27, \x27%s\x27, \x27tmax\x27, %.0f);\n ",id_stat,dat_prev,max;
  }
 dat_prev=dat;
 max=val
 }
 #print ("dat=", $1," val=",val," max=", max, " -----",$2)
}
' 3.csv >> tmax.sql
echo "insert tmax into DB"
echo $ids
done
date
#psql -U $PGUSER -h $PGHOST -d $PGDATABASE -f tmax.sql > tmax.log
date
