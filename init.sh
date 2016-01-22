#!/bin/sh 
#
# Note everything is installed into the target directory, so now that we
# have an easily repeatable installation of your project, you can throw away
# the target directory at any time and run your init.sh to start over!
#

DEMO="JBoss Fuse File Transfer Hub Demo"
AUTHORS="Jian Feng"
PROJECT="https://github.com/jbossdemocentral/"
PRODUCT="YOUR-JBOSS-PRODUCT-HERE"
FUSE=jboss-fuse-6.2.1.redhat-084
FUSE_BIN=jboss-fuse-full-6.2.1.redhat-084.zip
DEMO_HOME=./target
FUSE_HOME=$DEMO_HOME/$FUSE
FUSE_PROJECT=./project/homeloan
FUSE_SERVER_CONF=$FUSE_HOME/etc
FUSE_SERVER_BIN=$FUSE_HOME/bin
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects/sample-fuse-file-transfer
VERSION=1.0
PRE_BUILD_BUNDLE=support/jar/filetransfer-0.0.1-SNAPSHOT

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

# Check Fuse install file before proceeding.	
if [[ -r $SRC_DIR/$FUSE_BIN || -L $SRC_DIR/$FUSE_BIN ]]; then
		echo "  - FUSE install file is in place "
		echo
else
		echo "ERROR: Can not find $SRC_DIR/$FUSE_BIN "
		echo
		echo "Need to download $FUSE_BIN package from the jboss.org "
		echo "and place it in the $SRC_DIR directory to proceed..."
		cat ./installs/README.md
		exit
fi

# Create the target directory if it does not already exist.
if [ ! -x $DEMO_HOME ]; then
		echo "  - creating the demo home directory..."
		echo
		mkdir $DEMO_HOME
else
		echo "  - detected demo home directory, moving on..."
		echo
fi

# Move the old JBoss instance, if it exists, to the OLD position.
if [ -x $FUSE_HOME ]; then
		echo "  - existing JBoss FUSE detected..."
		echo
		echo "  - moving existing JBoss FUSE aside..."
		echo
		rm -rf $FUSE_HOME.OLD
		mv $FUSE_HOME $FUSE_HOME.OLD

		# Unzip the JBoss instance.
		echo "  - Unpacking JBoss FUSE $VERSION "
		echo
		unzip -q -d $DEMO_HOME $SRC_DIR/$FUSE_BIN
else
		# Unzip the JBoss instance.
		echo "  - Unpacking new JBoss FUSE... "
		echo
		unzip -q -d $DEMO_HOME $SRC_DIR/$FUSE_BIN
fi

#SETUP FUSE
echo "  - enabling admin accounts in users.properties file..."
echo
cp $SUPPORT_DIR/fuse/users.properties $FUSE_SERVER_CONF

echo "  - making sure start script for Fuse is executable..."
echo
chmod u+x $FUSE_HOME/bin/start

# Check mvn version must be 3.x.x
verone=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $1}')
vertwo=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $2}')
verthree=$(mvn -version | awk '/Apache Maven/{print $3}' | awk -F[=.] '{print $3}')     
if [[ $verone -eq 3 ]] ; then
		echo "  - build fuse project using Maven version $verone.$vertwo.$verthree ..."
		echo
		(cd ${PRJ_DIR} ; mvn clean install )
else
		echo "  - skip build since Maven 3.x is NOT installed. "
		echo "       will use a pre-build bundle "
		echo
		mkdir ${PRJ_DIR}/target
		cp ${PRE_BUILD_BUNDLE} ${PRJ_DIR}/target
fi

echo "  - Deploy bundle to Fuse..."
echo
cp ${PRJ_DIR}/target/*.jar ${FUSE_HOME}/deploy

echo "  - Start up Fuse in the background..."
echo
sh ${FUSE_SERVER_BIN}/start

echo "  - decrease log level for org.apache.camel.component.file.remote.SftpOperations"
echo
# http://www.rubix.nl/blogs/redhat-fuse-61-disable-logging-orgapachecamelcomponentfileremotesftpoperations
${FUSE_SERVER_BIN}/client -r 60 -d 5 "log:set ERROR org.apache.camel.component.file.remote.SftpOperations"

echo "##################################################################"
echo "To view the log of Fuse process, please tail like below"
echo
echo "   tail -f ${FUSE_HOME}/data/log/fuse.log "
echo
echo "To login to Fuse management console at:"
echo
echo "   http://localhost:8181    (u:admin/p:admin)"
echo 
echo "To stop the backgroud Fuse process, please go to bin and execute stop"
echo
echo "   ${FUSE_HOME}/bin/stop "
echo
echo "To stop and clean everything run"
echo
echo "   ./clean.sh"
echo
echo "##################################################################"
echo
