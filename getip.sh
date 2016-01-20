#!/bin/bash
#############################
####### Iran IP List
####### 2016-01-08
####### Amirhossein Saberi
####### GNU V3 License
#############################


## Define folders and files
SCRIPTFOLDER=`pwd`
FOLDER="$SCRIPTFOLDER/files"
NOW=`date +'%s'`
ASFILE_I="$FOLDER/iran-as-i-$NOW" # This is for IGP routes
ASFILE_E="$FOLDER/iran-as-e-$NOW" # This is for EGP routes
ASFILE_U="$FOLDER/iran-as-u-$NOW" # This is for Incomplete routes
IPFILE="$FOLDER/final-iran-ip-$NOW"
SUMIPFILE="$FOLDER/final-summarized-iran-ip-$NOW"


## Delete old IP sources and Iran AS numbers if exist
rm -Rf $ASFILE_I
rm -Rf $ASFILE_E
rm -Rf $ASFILE_U
rm -Rf $FOLDER/oix-full-snapshot-latest.dat
rm -Rf $FOLDER/oix-full-snapshot-latest.dat.bz2

## Download latest Iran AS numbers based on bgp.he
curl  --user-agent "Mozilla/4.0" http://bgp.he.net/country/IR 2>&1 | grep AS[1-9] | cut -d/ -f2 | awk -F\" '{print $1}'  | tr -d 'AS' | 
while read line; 
do 
	echo " $line i" >> $ASFILE_I
	echo " $line i" >> $ASFILE_E
	echo " $line i" >> $ASFILE_U
done

## Download latest BGP routes
wget http://archive.routeviews.org/oix-route-views/oix-full-snapshot-latest.dat.bz2 -O $FOLDER/oix-full-snapshot-latest.dat.bz2 -q 
bzip2 -d $FOLDER/oix-full-snapshot-latest.dat.bz2

## Find routes with Iran AS number and grep with Iran TIC & IPM company 
egrep -f $ASFILE_I -f $ASFILE_E -f $ASFILE_U $FOLDER/oix-full-snapshot-latest.dat | egrep " (48159|12880|6736)" |sed "s/ \([0-9]\+\) \1/ \1/g" | awk '{print $2}' | uniq |  sort > $IPFILE 


## Summarize IPs with python
/usr/bin/python $SCRIPTFOLDER/summarize.py $IPFILE > $SUMIPFILE 

echo "Your Iran IP file is ready! Complete IPs: $IPFILE , Summarized IPs: $SUMIPFILE" 
