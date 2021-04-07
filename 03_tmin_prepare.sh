#!/bin/bash
echo "SET DATESTYLE TO GERMAN;" > tmin.sql
for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
awk ' BEGIN { FS=";"}
gsub(/[0-9][0-9]:[0-9][0-9]/,"") {print $1 $2};
' $ids |sed 's/"//g'>2.csv

awk ' BEGIN { FS=" ";min=1000;id_stat='$ids';dat_prev="'$dat1'";}
{ 
dat=$1;
if ( dat == dat_prev)
 {  
   if (min>$2)
    {
     min = $2;
     #printf "# %.1f\n", min;
    }
 dat_prev=dat;
 }

else 
 {
printf "select meteo_insert(\x27UPM000%s\x27, \x27%s\x27, \x27tmin\x27, %.0f);\n ",id_stat,dat_prev,min*10;
 dat_prev=dat;
 min=1000
 }

}
' 2.csv >> tmin.sql
echo "insert tmin into DB"
echo $ids
#export PGPASSWORD="der_parol" && psql -h localhost -U postgres -d pseed_db -f tavg.sql >tavg.log 
date
done
