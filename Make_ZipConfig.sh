#!/bin/bash
#
# Configuration file for GARMIN FORERUNNER - GFrun
# Modif by Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.1"
#     Licence: GNU
############################
# zip fichier de config offline (GFrunOffline.zip) + config garminplugin (_.GFrunGarminplugin.zip)
zip -r GFrunOffline.zip  master.zip _.config/ Garmin-Forerunner-610-Extractor-master/
cd _.config/ && zip -r _.GFrunGarminplugin.zip garmin-extractor/ garminplugin/
cd .. && mv _.config/_.GFrunGarminplugin.zip Garmin-Forerunner-610-Extractor-master/resources/
echo "FIN"
