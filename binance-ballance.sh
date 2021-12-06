#!/bin/bash
# Binance Get wallet Balance. Example below is for ETH [2]

export PATH="/usr/local/bin:$PATH"
JQ=$(command -v jq)

APIKEY=XXXXX
APISECRET=XXXXX
RECVWINDOW=50000
RECVWINDOW="recvWindow=$RECVWINDOW"
TIMESTAMP="timestamp=$(( $(date +%s) *1000))"
QUERYSTRING="$RECVWINDOW&$TIMESTAMP"

SIGNATURE=$(echo -n "$QUERYSTRING" | openssl dgst -sha256 -hmac $APISECRET | cut -c 10-)
SIGNATURE="signature=$SIGNATURE"

raw_bal=$(curl -s -H "X-MBX-APIKEY: $APIKEY" "https://api.binance.com/api/v3/account?$RECVWINDOW&$TIMESTAMP&$SIGNATURE" | jq '.');
bal=$($JQ -r '.balances | .[2] | .free'  <<< $raw_bal)
echo $bal
