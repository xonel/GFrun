#!/bin/bash
#
# GARMIN FORERUNNER - GFrun
# Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.4"
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
# zip fichier de config offline (GFrunOffline.zip) + config garminplugin
#

rm GFrunOffline.zip

mv _.config/ .config/
mv _.local/ .local/

cd .local/ && unzip -o  share.zip

cd .. && zip -r GFrunOffline.zip  master.zip .config/ .local/ GFrun/ install/
rm -r .local/share/

cd .config/ && zip -r _.config_GFrun.zip garmin-extractor/ garminplugin/
cd .. && mv .config/ _.config/ && mv .local/ _.local/
echo "FIN"
