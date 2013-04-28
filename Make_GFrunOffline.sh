#!/bin/bash
#
# GARMIN FORERUNNER - GFrun
# Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.1"
#     Licence: GNU
############################
echo "#:'######:::'########:'########::'##::::'##:'##::: ##:
#      '##... ##:: ##.....:: ##.... ##: ##:::: ##: ###:: ##:
#       ##:::..::: ##::::::: ##:::: ##: ##:::: ##: ####: ##:
#       ##::'####: ######::: ########:: ##:::: ##: ## ## ##:
#       ##::: ##:: ##...:::: ##.. ##::: ##:::: ##: ##. ####:
#       ##::: ##:: ##::::::: ##::. ##:: ##:::: ##: ##:. ###:
#     .  ######::: ##::::::: ##:::. ##:. #######:: ##::. ##:
#     :......::::..::::::::..:::::..:::.......:::..::::..::"
#
# zip fichier de config offline (GFrunOffline.zip) + config garminplugin (_.GFrunGarminplugin.zip)
mv _.config/ .config/
mv _.local/ .local/
zip -r GFrunOffline.zip  master.zip .config/ .local/ Garmin-Forerunner-610-Extractor-master/ install/
cd .config/ && zip -r _.GFrunGarminplugin.zip garmin-extractor/ garminplugin/
cd .. && mv .config/ _.config/ && mv .local/ _.local/
echo "FIN"
