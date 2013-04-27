#!/bin/bash
#
# Configuration file for GARMIN FORERUNNER - GFrun
# Modif by Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.2"
#     Licence: GNU
############################
#
########################################################################
# wget https://github.com/xonel/GFrun/raw/master/install/SGFrunMenu.sh
# chmod a+x SGFrunMenu.sh
# sudo sh ./SGFrunMenu.sh
#
# OneCopyColle : 
# wget https://github.com/xonel/GFrun/raw/master/install/SGFrunMenu.sh && chmod a+x SGFrunMenu.sh && sudo sh ./SGFrunMenu.sh
########################################################################
#
##Configuration des fichiers de config avec le #HOME et le $NUMERO_DE_MA_MONTRE
NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts)

if [ -n "$NUMERO_DE_MA_MONTRE" ]; then
	cd $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/
	ln -s $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities Activites && mv Activities $HOME/.config/garmin-extractor/Garmin/Activities
	src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
fi

src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HOME/Garmin-Forerunner-610-Extractor-master/resources/FIT-to-TCX-master/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/scripts/40-convert_to_tcx.py" >> /tmp/ligneCmd.sh
src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/garminplugin.xml" >> /tmp/ligneCmd.sh
chmod u+x /tmp/ligneCmd.sh && sh /tmp/ligneCmd.sh
