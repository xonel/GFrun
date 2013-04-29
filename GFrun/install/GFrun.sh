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
# wget https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh
# chmod a+x GFrunMenu.sh
# sudo sh ./GFrunMenu.sh
#
# OneCopyColle : 
# wget https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
########################################################################
#
Vbranche="GFrun"

F_clear(){
	#Nettoyage
	rm -Rf $HOME/master.zip* $HOME/GFrun/resources/FIT-to-TCX-master/master.zip* $HOME/GFrun/resources/FIT-to-TCX-master/python-fitparse-master/ $HOME/GFrun/resources/master.zip* $HOME/GFrun/resources/pygupload_20120516.zip* $HOME/.config/_.config_GFrun.zip* /tmp/ligneCmd.sh* $HOME/GFrun/Garmin-Forerunner-610-Extractor-master
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
	cd $HOME && wget https://github.com/Tigge/Garmin-Forerunner-610-Extractor/archive/master.zip
	cd $HOME/GFrun/resources/ && wget https://github.com/Tigge/FIT-to-TCX/archive/master.zip
	cd $HOME/GFrun/resources/FIT-to-TCX-master/ && wget https://github.com/dtcooper/python-fitparse/archive/master.zip
	cd $HOME/GFrun/resources/ && wget http://freefr.dl.sourceforge.net/project/gcpuploader/pygupload_20120516.zip
	cd $HOME/.config/ && wget https://raw.github.com/xonel/GFrun/$Vbranche/_.config/_.config_GFrun.zip
}

F_unzip(){
	#Garmin-Forerunner-610-Extractor-master
	cd $HOME && unzip -o master.zip -d GFrun
	#FIT-to-TCX-master
	cd $HOME/GFrun/resources/ && unzip -o master.zip
	#python-fitparse-master
	cd $HOME/GFrun/resources/FIT-to-TCX-master/ && unzip -o master.zip
	#gcpuploader
	cd $HOME/GFrun/resources/ && unzip -o pygupload_20120516.zip
	cd $HOME/.config/ && unzip -o _.config_GFrun.zip
}

F_cpmv(){
	#Garmin-Forerunner-610-Extractor-master
	cp -Rf $HOME/GFrun/Garmin-Forerunner-610-Extractor-master/* $HOME/GFrun
	##Convert fit to tcx
	mkdir -p $HOME/.config/garmin-extractor/scripts/
	cp -f $HOME/GFrun/scripts/40-convert_to_tcx.py $HOME/.config/garmin-extractor/scripts/
	mv -f $HOME/GFrun/resources/FIT-to-TCX-master/python-fitparse-master/fitparse $HOME/GFrun/resources/FIT-to-TCX-master/
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
	cd $HOME && wget https://raw.github.com/xonel/GFrun/$Vbranche/GFrunOffline.zip && unzip -o GFrunOffline.zip
fi
}

## MAIN ##

echo "#:'######:::'########:'########::'##::::'##:'##::: ##:
#   '##... ##:: ##.....:: ##.... ##: ##:::: ##: ###:: ##:
#    ##:::..::: ##::::::: ##:::: ##: ##:::: ##: ####: ##:
#    ##::'####: ######::: ########:: ##:::: ##: ## ## ##:
#    ##::: ##:: ##...:::: ##.. ##::: ##:::: ##: ##. ####:
#    ##::: ##:: ##::::::: ##::. ##:: ##:::: ##: ##:. ###:
#   . ######::: ##::::::: ##:::. ##:. #######:: ##::. ##:
#   :......::::..::::::::..:::::..:::.......:::..::::..::"
echo "Arg : >>>>>>>" $1 "<<<<<<"

	case $1
		in
          -d) # Lancer le Script pour : 
		####################################################################
				F_clear
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

          -s) # Lancer le Script pour : 
		####################################################################
				F_clear
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

          -l) # Lancer le Script pour : 
		####################################################################
				F_clear
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
             
          *) # anything else
		####################################################################
            echo
            echo "\"$1\" n'est pas une entrée Valide."
            sleep 3
		####################################################################
            ;;
        esac

echo "PROCEDURE TERMINEE"
exit

