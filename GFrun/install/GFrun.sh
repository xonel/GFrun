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
# wget -N https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh
# chmod a+x GFrunMenu.sh
# sudo sh ./GFrunMenu.sh
# 
# wget -N https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
##################################################################################################################################
#
#Vbranche="GFrun"
Vbranche="master"

color()
{
printf '\033[%sm%s\033[m\n' "$@"
}

F_uninstall(){
echo -n " !! UNINSTALL !! >> FGrun + ConfigFiles + Activities [Yes / No] :"
read Vchoix

	if [ $Vchoix = [yY] ]; then
			rm -Rf  $HOME/GFrun $HOME/.config/garmin-extractor $HOME/.config/garminplugin
		else
			sh $HOME/GFrun/install/GFrunMenu.sh
	fi
}

F_clear(){
	#Nettoyage
	rm -f $HOME/GFrun.sh* $HOME/guploader.sh* $HOME/master.zip* $HOME/GFrun/resources/FIT-to-TCX-master/master.zip* $HOME/GFrun/resources/master.zip* $HOME/GFrun/resources/pygupload_20120516.zip* $HOME/ $HOME/.config/_.config_GFrun.zip* /tmp/ligneCmd.sh*
	rm -Rf  $HOME/GFrun/resources/FIT-to-TCX-master/python-fitparse-master $HOME/GFrun/Garmin-Forerunner-610-Extractor-master
}

F_mkdir(){
	mkdir -p $HOME/GFrun/resources/FIT-to-TCX-master/
	mkdir -p $HOME/.config/garmin-extractor/scripts/
	mkdir -p $HOME/.config/garminplugin
}

F_apt(){
	dpkg -l > /tmp/pkg-before.txt

	#[repos]
	sudo apt-add-repository -y ppa:andreas-diesner/garminplugin
	sudo apt-get update

	#[packages]
	sudo apt-get install -y git git-core 
	sudo apt-get install -y python python-pip libusb-1.0-0 python-lxml python-pkg-resources python-poster python-serial
	sudo apt-get install -y garminplugin
	sudo apt-get upgrade

	pip install pyusb
	dpkg -l > /tmp/pkg-after.txt
	}

F_wget(){
	cd $HOME && wget -N https://github.com/Tigge/Garmin-Forerunner-610-Extractor/archive/master.zip
	cd $HOME/GFrun/resources/ && wget -N https://github.com/Tigge/FIT-to-TCX/archive/master.zip
	cd $HOME/GFrun/resources/FIT-to-TCX-master/ && wget -N https://github.com/dtcooper/python-fitparse/archive/master.zip
	cd $HOME/GFrun/resources/ && wget -N http://freefr.dl.sourceforge.net/project/gcpuploader/pygupload_20120516.zip
	cd $HOME/.config/ && wget -N https://github.com/xonel/GFrun/raw/$Vbranche/_.config/_.config_GFrun.zip
	cd $HOME && wget https://github.com/xonel/GFrun/raw/$Vbranche/GFrunOffline.zip
}

F_unzip(){
	#Garmin-Forerunner-610-Extractor-master
	cd $HOME && unzip -o master.zip -d GFrun
	#FIT-to-TCX-master
	cd $HOME/GFrun/resources/ && unzip -o master.zip
	#python-fitparse-master
	cd $HOME/GFrun/resources/FIT-to-TCX-master/ && unzip -o master.zip
	#guploader
	cd $HOME/GFrun/resources/ && unzip -o pygupload_20120516.zip
	#connect.garmin.com
	cd $HOME/.config/ && unzip -o _.config_GFrun.zip
	#script install
	cd $HOME/ && unzip -oC GFrunOffline.zip "GFrun/install/*" "GFrun/resources/dump_gconnect.py" -d $HOME/
}

F_cpmv(){
	#Garmin-Forerunner-610-Extractor-master
	cp -Rf $HOME/GFrun/Garmin-Forerunner-610-Extractor-master/* $HOME/GFrun
	##Convert fit to tcx
	cp -f $HOME/GFrun/scripts/40-convert_to_tcx.py $HOME/.config/garmin-extractor/scripts/
	cp -Rf $HOME/GFrun/resources/FIT-to-TCX-master/python-fitparse-master/fitparse $HOME/GFrun/resources/FIT-to-TCX-master/
}

F_extractfit(){
	#Garmin-Forerunner-610-Extractor
	xterm -e 'cd $HOME/GFrun/ && python ./garmin.py'
}

F_configfiles(){
	#$NUMERO_DE_MA_MONTRE
	NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts)

	#GarminDevice.xml
	if [ -n "$NUMERO_DE_MA_MONTRE" ]; then
		cd $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/
		ln -s $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities Activities && mv -f Activities $HOME/.config/garmin-extractor/Garmin
		src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
	fi

	#40-convert_to_tcx.py
	src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HOME/GFrun/resources/FIT-to-TCX-master/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/scripts/40-convert_to_tcx.py" >> /tmp/ligneCmd.sh
	src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/garminplugin.xml" >> /tmp/ligneCmd.sh

	#ligneCmd.sh
	chmod u+x /tmp/ligneCmd.sh && sh /tmp/ligneCmd.sh
}

F_chownchmod(){
	#Chown Chmod
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garminplugin $HOME/.config/garmin-extractor $HOME/GFrun
	chmod -R a+x $HOME/.config/garmin-extractor/scripts/ $HOME/GFrun/scripts/
}

F_chk_GFrunOffline(){
if [ ! -f $HOME/GFrunOffline.zip ]; then
	cd $HOME && wget https://github.com/xonel/GFrun/raw/$Vbranche/GFrunOffline.zip && unzip -o GFrunOffline.zip
	else
	cd $HOME && unzip -o GFrunOffline.zip
fi
}

F_conf_guploader(){
	echo "
	# Username and password credentials may be placed in a configuration file
	# located either in the current working directory, or in the user's home
	# directory.  WARNING, THIS IS NOT SECURE. USE THIS OPTION AT YOUR OWN
	# RISK.  Username and password are stored as clear text in a file
	# format that is consistent with Microsoft (r) INI files."
	echo ""
echo `color 32 "============================================="`
	echo "Configuration Auto-Upload on connect.garmin.com"
echo `color 32 "============================================="`

	if [ ! -f $HOME/.guploadrc ]; then
			read -p 'USERNAME : on connect.garmin.com >> ' Read_user
			read -p 'PASSWORD : on connect.garmin.com >> ' Read_password

			echo "[Credentials]" >> $HOME/.guploadrc
			echo "username="$Read_user"" >> $HOME/.guploadrc
			echo "password="$Read_password"" >> $HOME/.guploadrc	
		else
			cat  $HOME/.guploadrc
			echo ""
			echo `color 31 "============================================="`
						echo "Configuration file already exist"
			echo `color 31 "============================================="`
	fi
}

## MAIN ##
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
echo "Arg :.........>>>>>>>" $1 "<<<<<<................"
echo ""
echo ""
	case $1
		in
          -d) # 1. Full Install DEV - (GFrunDev)
		####################################################################
				F_clear
				F_mkdir
#				F_chk_GFrunOffline
				F_apt
				F_wget
				F_unzip
				F_cpmv
				F_extractfit
				F_configfiles
				F_chownchmod
				F_clear
		####################################################################
            ;;

          -s) # 2. Full Install STABLE - (GFrunStable)
		####################################################################
				F_clear
				F_mkdir
				F_chk_GFrunOffline
				F_apt
#				F_wget
				F_unzip
				F_cpmv
				F_extractfit
				F_configfiles
				F_chownchmod
				F_clear
		####################################################################
            ;;

          -o) # 3. Full Install LOCAL - (GFrunLocal)
		####################################################################
				F_clear
				F_mkdir
				F_chk_GFrunOffline
#				F_apt
#				F_wget
				F_unzip
				F_cpmv
				F_extractfit
				F_configfiles
				F_chownchmod
				F_clear
		####################################################################
             ;;
             
          -c) # 5. Config Garminplugin -(connect.garmin.com)
		####################################################################
#				F_clear
#				F_mkdir
#				F_chk_GFrunOffline
#				F_apt
#				F_wget
#				F_unzip
#				F_cpmv
				F_extractfit
				F_configfiles
#				F_chownchmod
#				F_clear
		####################################################################
             ;;

          -e) # 6. Telecharger Activites - (Montre > Local) 
		####################################################################
#				F_clear
#				F_mkdir
#				F_chk_GFrunOffline
#				F_apt
#				F_wget
#				F_unzip
#				F_cpmv
				F_extractfit
#				F_configfiles
#				F_chownchmod
#				F_clear
		####################################################################
             ;;

          -g) # 4. Config Auto-Upload		(guploader) 
		####################################################################
				F_conf_guploader
		####################################################################
             ;;

          -x) # 6. Telecharger Activites - (Montre > Local) 
		####################################################################
				F_clear
				F_uninstall
		####################################################################
             ;;

          *) # anything else
		####################################################################
            echo
            echo "\"$1\" NO VALID ENTRY "
            sleep 3
		####################################################################
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
	fi
exit

