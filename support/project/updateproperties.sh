#!/bin/sh 

DEMO="JBoss Fuse File Transfer Hub Demo"
AUTHORS="Jian Feng"
PROJECT="https://github.com/jbossdemocentral/"

# wipe screen.
clear 
ASCII_WIDTH=60
printf "##  %-${ASCII_WIDTH}s  ##\n" | sed -e 's/ /#/g'
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" "Setting up the ${DEMO}"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" "                #####  #   #  #####  #####"
printf "##  %-${ASCII_WIDTH}s  ##\n" "                #      #   #  #      #"
printf "##  %-${ASCII_WIDTH}s  ##\n" "                #####  #   #  #####  ####"
printf "##  %-${ASCII_WIDTH}s  ##\n" "                #      #   #      #  #"
printf "##  %-${ASCII_WIDTH}s  ##\n" "                #      #####  #####  #####"  
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" "brought to you by,"
printf "##  %-${ASCII_WIDTH}s  ##\n" " ${AUTHORS}"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" " ${PROJECT}"
printf "##  %-${ASCII_WIDTH}s  ##\n"
printf "##  %-${ASCII_WIDTH}s  ##\n" | sed -e 's/ /#/g'
echo

CMDNAME=`basename $0`
if [ $# -ne 3 ]; then
   echo
   echo "ERROR: Not enough command parameters"
   echo
   echo "Usage: $CMDNAME <SFTP_HOSTNAME> <SFTP_USER> <SFTP_PASSWORD>" 1>&2
   echo
   exit 1
fi

SFTP_HOSTNAME=$1
SFTP_USER=$2
SFTP_PASSWORD=$3

FILE_TO_REPLACE=./projects/sample-fuse-file-transfer/src/main/resources/OSGI-INF/blueprint/properties.xml
# Check original file existance before proceeding.	
if [[ -r ${FILE_TO_REPLACE}.org || -L ${FILE_TO_REPLACE}.org ]]; then
	echo "  - found ${FILE_TO_REPLACE}.org is already there, will restore original file before processing"
	rm ${FILE_TO_REPLACE}
	mv ${FILE_TO_REPLACE}.org ${FILE_TO_REPLACE}
fi

# Check file existance before proceeding.	
if [[ -r ${FILE_TO_REPLACE} || -L ${FILE_TO_REPLACE} ]]; then
		echo "  - ${FILE_TO_REPLACE} is in place "
		sed -i ".org" -e "s/hostname\" value=\"localhost\"/hostname\" value=\"${SFTP_HOSTNAME}\"/g" ${FILE_TO_REPLACE}
		sed -i ".bak1" -e "s/username\" value=\"test\"/username\" value=\"${SFTP_USER}\"/g" ${FILE_TO_REPLACE}
		sed -i ".bak2" -e "s/password\" value=\"test\"/password\" value=\"${SFTP_PASSWORD}\"/g" ${FILE_TO_REPLACE}
		rm ${FILE_TO_REPLACE}.bak1 ${FILE_TO_REPLACE}.bak2
		echo
else
		echo "ERROR: Can not find ${FILE_TO_REPLACE} "
		echo
		echo "please make sure running this scription at home dir of DEMO "
		echo 
		exit 1
fi



