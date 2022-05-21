#!/bin/bash
# Autor: Broly
# License: GNU General Public License v3.0
# https://www.gnu.org/licenses/gpl-3.0.txt
# This script is inteded to create an opencore usb-installer on linux

set -e
clear
	cat << "EOF"
###############################
#  WELCOME TO PI-GPT-FLASHER  #
###############################

Please enter your password!

EOF

[[ "$(whoami)" != "root" ]] && exec sudo -- "$0" "$@"

partformat(){
    clear
	cat << "EOF"
###############################
#    PARTITIONING THE DRIVE   #
###############################

Formating and partitioning the drive with wipefs and sgdisk!

EOF
    umount "$drive"* || :
    sleep 2s
    wipefs -af "$drive"
    sgdisk "$drive" --new=0:0: -t 0:8300 && partprobe
    sleep 2s
}

burning(){
    clear
	cat << "EOF"
####################################
#    COPYING IMAGE TO THE DRIVE    #
####################################

Copying image to the flash drive with dd command!

EOF
    myimg=$(ls *.img)
    dd bs=8M if="$myimg" of="$drive" status=progress oflag=sync
    umount "$drive"?* || :
    sleep 3s
}

gptconvert(){
    clear
	cat << "EOF"
#################################
#    CONVERTING DRIVE TO GPT    #
#################################
EOF
    ./mbr2gpt "$drive"
    printf "Installation finished!!\n"
}

clear
cat << "EOF"
################################################
#  WARNING: THE SELECTED DRIVE WILL BE ERASED  #
################################################

Please select the usb-drive!

EOF
readarray -t lines < <((lsblk -p -no name,size,MODEL,VENDOR,TRAN | grep "usb"))
select choice in "${lines[@]}"; do
    [[ -n "$choice" ]] || { printf ">>> Invalid Selection!\n" >&2; continue; }
    break
done
read -r drive _ <<<"$choice"
if [[ -z "$choice" ]]; then
	printf "Please insert the USB Drive and try again.\n"
	exit 1
fi
while true; do
	read -r -p "$(printf %s "Drive ""$drive"" will be erased, do you wish to continue (y/n)? ")" yn
	case $yn in
		[Yy]* ) partformat; burning; gptconvert; break;;
		[Nn]* ) exit;;
		* ) printf "Please answer yes or no.\n";;
	esac
done
