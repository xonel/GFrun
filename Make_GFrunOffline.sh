#!/bin/bash
#
# GARMIN FORERUNNER - GFrun
# Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.2"
#     Licence: GNU
############################
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
# zip fichier de config offline (GFrunOffline.zip) + config garminplugin (_.GFrunGarminplugin.zip)
#
mv _.config/ .config/
mv _.local/ .local/

cd .local/ && unzip -o  share.zip
cd .. && zip -r Garmin-Forerunner-610-Extractor-master.zip  master.zip .config/ .local/ Garmin-Forerunner-610-Extractor-master/ install/
zip -r GFrunOffline.zip  master.zip .config/ .local/ GFrun/ install/

rm -r .local/share/

cd .config/ && zip -r _.GFrunGarminplugin.zip garmin-extractor/ garminplugin/
cd .. && mv .config/ _.config/ && mv .local/ _.local/
echo "FIN"
