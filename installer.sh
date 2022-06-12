#!/bin/bash
SYSTEMCTLCMD="/usr/bin/systemctl"
DESTINATION="/usr/local/sbin/"
TEMPLATE="alertmailer.py-template"
FILENAME="alertmailer.py"

if [ "$EUID" -ne 0 ]
	then echo "This installer needs to be run as root."
	exit
fi

if [ ! -f $SYSTEMCTLCMD ]; then
	echo "unable to find $SYSTEMCTLCMD"
fi

if [ -f $DESTINATION/$FILENAME ]; then
	$SYSTEMCTLCMD stop alertmailer.service
	$SYSTEMCTLCMD disable alertmailer.service
	rm -rf $DESTINATION/$FILENAME
	$SYSTEMCTLCMD daemon-reload
fi

cp $TEMPLATE $FILENAME
read -p "Enter the email address of the sender: " SENDERADDR

read -p "Enter the name of the sender: " SENDERNAME

read -sp "Enter the app password of the sender: " PASSWORD
BASE64PASSWORD=`echo $PASSWORD | base64`
echo ""
read -p "Enter the email address of the recipient: " RECIPIENT

sed -i 's/SENDERADDR/'"$SENDERADDR"'/g' $FILENAME
sed -i 's/SENDERNAME/'"$SENDERNAME"'/g' $FILENAME
sed -i 's/BASE64PASSWORD/'"$BASE64PASSWORD"'/g' $FILENAME
sed -i 's/RECIPIENT/'"$RECIPIENT"'/g' $FILENAME

#echo ""
###########################################################################
# The following statements are for testing-only:
#echo $TEMPLATE
#echo $FILENAME
#echo $SENDERADDR
#echo $SENDERNAME
#echo $PASSWORD
#echo $BASE64PASSWORD
#echo $RECIPIENT

###########################################################################
cp $FILENAME $DESTINATION
cp alertmailer.service /etc/systemd/system/
chmod a+x $DESTINATION/$FILENAME

$SYSTEMCTLCMD daemon-reload
$SYSTEMCTLCMD enable alertmailer.service
$SYSTEMCTLCMD start alertmailer.service
$SYSTEMCTLCMD status alertmailer.service --no-pager

echo "Complete!"

