#!/bin/bash
#
# GFrun
#
#  Auteurs : Le.NoX ;o)
#  M@il : le.nox @ free.fr
#  Version="0.4.0"
#
#  Licence: GNU GPL
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##################################################################################################################################
# wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh
# chmod a+x GFrunMenu.sh
# sudo sh ./GFrunMenu.sh
# 
# wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
##################################################################################################################################
#
color()
{
printf '\033[%sm%s\033[m\n' "$@"
}
echo `color 32 "========================================================================"`
echo "#     :......::::..::::::::..:::::..:::.......:::..::::..::"
echo "#      :'######:::'########:'########::'##::::'##:'##::: ##:"
echo "#      '##... ##:: ##.....:: ##.... ##: ##:::: ##: ###:: ##:"
echo "#       ##:::..::: ##::::::: ##:::: ##: ##:::: ##: ####: ##:"
echo "#       ##::'####: ######::: ########:: ##:::: ##: ## ## ##:"
echo "#       ##::: ##:: ##...:::: ##.. ##::: ##:::: ##: ##. ####:"
echo "#       ##::: ##:: ##::::::: ##::. ##:: ##:::: ##: ##:. ###:"
echo "#     .  ######::: ##::::::: ##:::. ##:. #######:: ##::. ##:"
echo "#     :......::::..::::::::..:::::..:::.......:::..::::..::"
echo `color 32 "======================================================================="`
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

# MEMO :
#  Ecrire HASH password 
#  Croiser login/pass avec dump_gconnect
#  

case $1
	in
	  -auto) #9. Extract>>Local>>garmin.com.....(GFrun.sh -a) $HOME/GFrun/install/gupload.sh -auto
	###########################################
	Vactivities=$(date +%Y-%m-*)
	GoScript
	exit
	###########################################
		;;
esac

GoScript()
{
	echo ""
	echo " Script >>> python $HOME/GFrun/resources/pygupload/gupload.py -v 1 $Vactivities"
	cd $HOME/.config/garmin-extractor/Garmin/Activities
	python $HOME/GFrun/resources/pygupload/gupload.py -v 1 $Vactivities
}
echo ""
echo ""
echo `color 32 "=================================="`
echo "SELECT ACTIVITIES PERIOD"
echo `color 32 "=================================="`
echo ""
echo " (T) - Today"
echo " (W) - Week" 
echo " (M) - Month"
echo " (Y) - Years" 
echo ""
echo -n "Choise : (t) . (w) . (m) . (y) "
read Vchoix

        case $Vchoix
        in
          [tT]) # 2013-04-14_10-29-04-80-9375.fit
		################################
		Vactivities=$(date +%Y-%m-%d_*)

		GoScript
		################################
            ;;

          [wW])  # Lancer le Script pour : 
		################################	
		for ((i=0 ; 7 - $i ; i++))
			do Vactivities=$(date "+%Y-%m-%d_*" -d "$i days ago")
			GoScript
		done
		################################
            ;;

          [mM]) # Lancer le Script pour :     
		################################
		Vactivities=$(date +%Y-%m-*)
		
		GoScript
		################################
            ;;

          [yY]) # Lancer le Script pour : 
		################################
		Vactivities=$(date +%Y-*)
				
		GoScript
		################################  			
            ;;
        esac
echo ""
echo "                                 !!!            o           _   _     "
echo "    -*~*-          ###           _ _           /_\          \\-//     "
echo "    (o o)         (o o)      -  (OXO)  -    - (o o) -       (o o)     "
echo "ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-"
echo ""
echo ".........................PROCEDURE TERMINEE..........................."

	if [ -f $HOME/GFrunMenu.sh ]; then
		sleep 5
		sh $HOME/GFrunMenu.sh
		else
		sleep 5
		sh $HOME/GFrun/install/GFrunMenu.sh
	fi