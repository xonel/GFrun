#!/bin/bash
#
# Configuration file for GARMIN FORERUNNER - GFrun
# Modif by Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.3.3"
#     Licence: GNU
############################
#
########################################################################
# wget https://github.com/xonel/GFrun/raw/master/install/GFrunMenu.sh
# chmod a+x GFrunMenu.sh
# sudo sh ./GFrunMenu.sh
#
# OneCopyColle : 
# wget https://github.com/xonel/GFrun/raw/master/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
########################################################################
#
#
echo "
#      :'######:::'########:'########::'##::::'##:'##::: ##:
#      '##... ##:: ##.....:: ##.... ##: ##:::: ##: ###:: ##:
#       ##:::..::: ##::::::: ##:::: ##: ##:::: ##: ####: ##:
#       ##::'####: ######::: ########:: ##:::: ##: ## ## ##:
#       ##::: ##:: ##...:::: ##.. ##::: ##:::: ##: ##. ####:
#       ##::: ##:: ##::::::: ##::. ##:: ##:::: ##: ##:. ###:
#     .  ######::: ##::::::: ##:::. ##:. #######:: ##::. ##:
#     :......::::..::::::::..:::::..:::.......:::..::::..::"
#
#Example '.guploadrc'
#[Credentials]
#username=<myusername>
#password=<mypassword>
#
#Replace <myusername> and <mypassword> above with your own login
#credentials.
#
#EXAMPLE:
#Upload file and set activty name:
#gupload.py -l myusername mypassword -a 'Run at park - 12/23' myfile.tcx
#
#Upload multiple files:
#gupload.py -l myusername mypassword myfile1.tcx myfile2.tcx myfile3.fit
#
#Upload file using config file for credentials, name file, verbose output:
#gupload.py -v 1 -a 'Run at park - 12/23' myfile.tcx
myusername=toto
mypassword=passworddetoto
activities=2013-*

cd $HOME/.config/garmin-extractor/Garmin/Activities
python $HOME/Garmin-Forerunner-610-Extractor-master/resources/pygupload/gupload.py -l $myusername $mypassword $activities
