# PI-GPT
This script is meant to flash raspberrypi operational systems .img files to large hardrives over 2Tb in size 
as we know most images made for the pi uses the mbr file system limiting your large harddrive to 2 TB only 
So we have to convert the drive to gpt and thats exactlly what this scrip does automatically flash the .img file
and expand it to use the entire space avaliable in the dive, even though this is meant to large drives over 2TB 
you can use it to flash operational systems to smaller flash drives as well,
It uses the good old dd command to flash the drive and mbr2gpt to convert it and expand it. 

## USAGE
Download the Operational system you want extract the .img file then place it inside the pi-gpt folder,
Notice do not place multiple .img files inside the pi-gpt folder it has to be only one at a time
then run ./gptflasher.sh script to start,
select your usb drive type yes to continue and fallow the prompt.
