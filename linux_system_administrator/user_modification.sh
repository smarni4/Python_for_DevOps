#!/usr/local/bin/bash

# This script allows to add users in batches of 1 or more at a time.
# This script also allows to delete the users.
# Pass the require arguments ACTION to perform, USERFILE.
# ./user_modification add USERFILE PASSWORD: To add users in the USERFILE
# ./user_modification del USERFILE PASSWORD: To remove users in the USERFILE

# variables
ACTION=$1
USERFILE=$2
PASSWORD=$3

# script
if [ "$USERFILE" == "" ] ; then
  echo "enter the userfile"
  exit 101
else
  if [ "$ACTION" == "add" ] ; then

    for user in `cat "$USERFILE"` ;
    do
      echo "Adding the $user and setting the default password!"
      useradd -m $user ; echo "$user:$PASSWORD" | chpasswd
      exit 102
    done

  elif [ "$ACTION" == "del" ] ; then
    for user in `cat $USERFILE`;
    do
      echo "Deleting the $user ..."
      userdel -r $user ;
      exit 103
    done
  else
    echo "Enter the specified action: add or del "
    exit 104
  fi
fi