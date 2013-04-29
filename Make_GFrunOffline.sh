#!/bin/bash
#
# GARMIN FORERUNNER - GFrun
# Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.3"
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
cd .. && zip -r GFrunOffline.zip  master.zip .config/ .local/ GFrun/ install/
rm -r .local/share/

cd .config/ && zip -r _.GFrunGarminplugin.zip garmin-extractor/ garminplugin/
cd .. && mv .config/ _.config/ && mv .local/ _.local/
echo "FIN"
