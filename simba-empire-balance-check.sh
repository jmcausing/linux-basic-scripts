#!/bin/bash
# Get SIM balance from polygon scan - will run a loop so you can see if the number changes
JQ=$(command -v jq)
while :
do
	# Set var for API in polygonscan SIM balance
    json1=$(curl -s "https://api.polygonscan.com/api?module=account&action=tokenbalance&contractaddress=0x70784d8a360491562342b4f3d3d039aaacaf8f5d&address=0x9aa2f05b70386ffe0a273c757fe02c21da021d62&tag=latest&apikey=XVQZCD4KN2XE3DYMMQVZZJIM696EMBHGIG") 

    balance_none_eth=$($JQ -r ".result" <<< $json1) # Get current 1ETH to PHP value
    
    # Example of 250,000 SIM Balance results
    #balance_none_eth=250000065705862214311005
    
    #bc <<< "scale=5; $(($balance_none_eth/1000000000000000000))"
    results=$(echo 'scale=4;'"$balance_none_eth / 1000000000000000000"|bc -l)


    # Check if Balance is more than 1,000 SIM
    if (( $(echo "$results > 1000" | bc -l) )); then
    echo "SIM is more than 1,000"
    espeak "Withdraw now"
    fi

    echo SIM Balance: $results

	sleep 1
done
