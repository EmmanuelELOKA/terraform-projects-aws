#!/bin/bash
# Purpose: To remove all files and folders from the web server root directory
# Author: Praful Patel
# Date & Time: June 21, 2022 
# ------------------------------------------

rm -rfv /var/www/html/*
cd /var/www/html/
ls -la
echo "FILES and FOLDER REMOVED SUCCESSFULLY FROM ROOT DIRECTORY "

# aws cloudwatch set-alarm-state --alarm-name 'WebServer_Alarm' --state-value ALARM --state-reason 'Simulate an EC2 HW failure'