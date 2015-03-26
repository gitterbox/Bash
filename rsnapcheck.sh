#!/bin/bash
#set -x
conffolder=/etc/rsnapshot.d
logfolder=/var/log/rsnapshot
cronfile=/etc/cron.d/rsnapshot
monthlyfile="/usr/local/sbin/rsnapshot-monthly.sh"
weeklyfile="/usr/local/sbin/rsnapshot-weekly.sh"
dailyfile="/usr/local/sbin/rsnapshot-daily.sh"
hourlyfile="/usr/local/sbin/rsnapshot-hourly.sh"
mwdh_list="$monthlyfile $weeklyfile $dailyfile $hourlyfile"

cd $conffolder
for file in *.conf 
do 
        echo 
        echo 
        echo "----------------------------"
        echo "processing $file"
        echo "----------------------------"
        echo 

        cat $file |grep -Ev '^(#|$)' 

        echo 
        echo showing CRONJOBS for $file ...
        cat $cronfile|grep $file
        echo  
        for mwdh in $mwdh_list ; do
                echo searching $file entry in $mwdh
                cat $mwdh|grep $file > /dev/null 2>&1
                if [ $? == 0 ] ; then 
                        echo hit .... showing corresponding cron entry
                        cat $cronfile|grep $mwdh|egrep -v [#]
                else 
                        echo no hit 
                fi

        done 
        echo "" 
done
echo "" 

echo showing rsnapshot logfiles sorted by modification date
echo "-------------------------------------------"
cd $logfolder
ls -lt 
