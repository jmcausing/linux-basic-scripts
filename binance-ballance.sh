#!/bin/bash
# Author: John Mark Causing
# Date: Dec 16, 2021
# Description: 
# Get ETH balance from Binance
# Bash script for windows with CRON that appends data to a file name. This will appear in the windows tool bar

# Setup path and JQ
JQ=$(command -v jq)
export PATH="/usr/local/bin:$PATH"
path="/mnt/c/API/"
pathfile="/mnt/c/API/ETHPHP"

# Check if files exist then delete
if ls $pathfile* 1> /dev/null 2>&1; then
    #echo "files do exist"
    rm $pathfile*
fi


APIKEY=xxxxxx
APISECRET=xxxxxx
RECVWINDOW=50000
RECVWINDOW="recvWindow=$RECVWINDOW"
TIMESTAMP="timestamp=$(( $(date +%s) *1000))"
QUERYSTRING="$RECVWINDOW&$TIMESTAMP"

SIGNATURE=$(echo -n "$QUERYSTRING" | openssl dgst -sha256 -hmac $APISECRET | cut -c 10-)
SIGNATURE="signature=$SIGNATURE"

raw_bal=$(curl -s -H "X-MBX-APIKEY: $APIKEY" "https://api.binance.com/api/v3/account?$RECVWINDOW&$TIMESTAMP&$SIGNATURE" | jq '.');
bal=$($JQ -r '.balances | .[2] | .free'  <<< $raw_bal)

# 1 ETH TO USD
ethusdt=$(curl -s  "https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT" | jq '.');
ethusdt2=$($JQ -r '.price'  <<< $ethusdt)

# 1 USD to PHP
one_usd_to_php=$(curl -s "https://api.coingecko.com/api/v3/coins/markets?vs_currency=php&ids=tether")
one_usd_to_php2=$($JQ -r ".[] | .current_price" <<< $one_usd_to_php)

# 1 ETH to PHP
ehtusd_to_php=$(echo "scale=2; $ethusdt2*$one_usd_to_php2" | bc)
ehtusd_to_php2=`printf "%.0f" $ehtusd_to_php`

# ETH balance to PHP
ethbal_to_usd=$(echo "scale=2; $bal*$ehtusd_to_php2" | bc)
ethbal_to_usd2=`printf "%.0f" $ethbal_to_usd`

#echo "ETH: $bal | ETH to PHP: $ehtusd_to_php2 | ETH PHP Balance: $ethbal_to_usd2"

# Append the data to a file name
newfilename="ETHPHP: $ehtusd_to_php2.lnk";
touch "$path$newfilename"
