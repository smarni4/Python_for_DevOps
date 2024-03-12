#!/bin/bash

# Script to allow web-admins to perform some yum checks
# Usage: ./example1.sh <action> <package>
# check-update: No package required
# check-installed: Specify the required package name
# check-available: Specify the required package name

# variables
action=$1
package=$2

# package manager
yum=/usr/bin/yum

# main

if [ "$action" == "check-update" ] ; then
  $yum check-update >> web_admin.log
  yum_results=$?   # $? returns the previous commands output
        case $yum_results in
                100)
                    echo "Updates available!"
                    exit 111
                    ;;
                0)
                  echo "No updates available!"
                  exit 112
                  ;;
                1)
                  echo "Error!"
                  exit 113
                  ;;
        esac

elif [ "$action" == "check-installed" ] ; then
  $yum list --installed "$package" >> web_admin.log 2>&1  # sends all the stderr to the std input and log to the file.
  yum_results=$?
        case $yum_results in
                0)
                  echo "Package is installed!"
                  exit 114
                  ;;
                1)
                  echo "Package is not installed!"
                  exit 115
                  ;;
        esac

elif [ "$action" == "check-available" ] ; then
  $yum list --available "$package" >> web_admin.log 2>&1
  yum_results=$?
        case $yum_results in
                0)
                  echo "Package is available!"
                  exit 116
                  ;;
                1)
                  echo "Package is not available"
                  exit 117
                  ;;
        esac

else
  echo "Invalid Options. Please specify one of the following:"
  echo "check-update: No package to specify."
  echo "check-installed: Specify the package."
  echo "check-available: Specify the package."
  exit 118

fi

