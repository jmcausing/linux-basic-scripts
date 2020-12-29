#!/bin/bash

echo "This will  generate random set of letters and numbers appending (15 characters only from A-Z, a-z and 0-9) to the file ranfile.txt until it reached 1Mib or 1049 Kib"

# generate file
touch ranfile.txt;

#set variable for current file size with integer value
declare -i cz=$(ls -al  | grep ranfile.txt | awk '{print $5}');


# start loop to check if the file is less than 1048 Kilobytes
while [ $cz -le 1048 ]
do

        #set value for file size while is in the loop
        inloop_file_size=$(ls -al  | grep ranfile.txt | awk '{print $5}');

        echo "The file ranfile.txt is not yet bigger than 1048Kib or 1Mib. Current file size of ranfile.txt is $inloop_file_size. Generating more random lines.."


        # Append the random letters and numbers to the file ranfile.txt
        echo "$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 15)" >> ranfile.txt

        # update the file size value of the variable 'cz'
        declare -i cz=$(ls -al  | grep ranfile.txt | awk '{print $5}');
done

current_file_size=$(ls -al  | grep ranfile.txt | awk '{print $5}');
echo "It's done! Now the file size is: $current_file_size";

