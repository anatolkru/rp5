#!/bin/bash
echo "SET DATESTYLE TO GERMAN;" > tmax.sql
for ids in `ls 3[0-9][0-9][0-9][0-9]`
do
dat1=`sed -n '1 s/"\([0-9][0-9]\.[0-9][0-9]\.[0-9][0-9][0-9][0-9]\) .*/\1/p' ./$ids`
echo $dat1
awk ' BEGIN { FS=";"}
gsub(/[0-9][0-9]:[0-9][0-9]/,"") {print $1 $2};
' $ids |sed 's/"//g'>2.csv

awk ' BEGIN { FS=" ";max=-1000;id_stat='$ids';dat_prev="'$dat1'";}
{ 
dat=$1;
if ( dat == dat_prev)
 {  
   if (max<$2)
    {
     max = $2;
     #printf "# %.1f\n", max;
    }
 dat_prev=dat;
 }

else 
 {
printf "select meteo_insert(\x27UPM000%s\x27, \x27%s\x27, \x27tmax\x27, %.0f);\n ",id_stat,dat_prev,max*10;
 dat_prev=dat;
 max=-1000
 }

}
' 2.csv >> tmax.sql
echo "insert tmax into DB"
echo $ids
#export PGPASSWORD="der_parol" && psql -h localhost -U postgres -d pseed_db -f tavg.sql >tavg.log 
date
done
