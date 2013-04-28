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
# wget https://github.com/xonel/GFrun/raw/master//Garmin-Forerunner-610-Extractor-master/install/GFrunMenu.sh
# chmod a+x GFrunMenu.sh
# sudo sh ./GFrunMenu.sh
#
# OneCopyColle : 
# wget https://github.com/xonel/GFrun/raw/master//Garmin-Forerunner-610-Extractor-master/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
########################################################################
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
#

GoScript()
{
	echo " >>> python $HOME/Garmin-Forerunner-610-Extractor-master/resources/pygupload/gupload.py -v 1 $Vactivities"
	echo ""
	cd $HOME/.config/garmin-extractor/Garmin/Activities
	python $HOME/Garmin-Forerunner-610-Extractor-master/resources/pygupload/gupload.py -v 1 $Vactivities
}
echo ""
echo ""
echo "=================================="
echo "SELECT ACTIVITIES PERIOD UPLOAD"
echo "=================================="
echo ""
echo " (T) - Today"
echo " (W) - Week -> don't work :o( " 
echo " (M) - Month"
echo " (Y) - Years" 
echo ""
echo -n "choise { Tt | Ww | Mm | Yy} : "
read Vchoix

        case $Vchoix
        in
          [tT]) # Lancer le Script pour : 2013-04-14_10-29-04-80-9375.fit
		####################################################################
		Vactivities=$(date +%Y-%m-%d_*)

		GoScript
		####################################################################
            ;;

          [wW])  # Lancer le Script pour : 
		####################################################################
		Vactivities=$(date +%Y-%m-%d_*)

		GoScript
		####################################################################
            ;;

          [mM]) # Lancer le Script pour :     
		####################################################################
		Vactivities=$(date +%Y-%m-*)
		
		GoScript
		####################################################################
            ;;

          [yY]) # Lancer le Script pour : 
		####################################################################
		Vactivities=$(date +%Y-*)
				
		GoScript
		####################################################################  			
            ;;
        esac
