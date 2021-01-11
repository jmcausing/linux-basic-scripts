#! /bin/bash
echo "# Load testing..";
read -p "Enter the site url: " siteurl;
read -p "How many request per second? " rps;
read -p "How many seconds you will load test this? " sl;
echo $siteurl;

a=0

while [ $a -lt $sl ]
do
   echo $a
   sleep 1

    for i in `seq 1 $rps`
    do
      curl -s -v "$siteurl" 2>&1 | tr '\r\n' '\\n' | awk -v date="$(date +'%r')" '{print $0"\n-----", date}' >> /tmp/perf-test.log &
    done

   a=`expr $a + 1`


done
