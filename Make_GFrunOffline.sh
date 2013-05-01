#!/bin/bash
#
# GARMIN FORERUNNER - GFrun
# Le.NoX
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
# zip config offline : GFrunOffline.zip 
#
mv ./_.config/ ./.config/
mv ./_.local/ ./.local/
mv ./GFrun/ressources/master_fitpars.zip ./GFrun/ressources/master.zip
mv ./GFrun/ressources/master_extractor.zip ./master.zip

#Vexclude="./local/share.zip
#./GFrun/ressources/xxxx.zip
#./GFrun/ressources/yyyy.zip"

unzip -o ./.local/share.zip -d ./.local/

zip -ur ./GFrunOffline.zip ./.config/ ./GFrun/ ./.local/ -x $Vexclude
zip -ur ./.config/_.config_GFrun.zip ./.config/garmin-extractor/ ./.config/garminplugin/ -d ./.config/ 

rm -r ./.local/share/

mv ./.config/ ./_.config/
mv ./.local/ ./_.local/
mv ./GFrun/ressources/master.zip ./GFrun/ressources/master_fitpars.zip 
mv ./master.zip ./GFrun/ressources/master_extractor.zip 

echo ""
echo "                                 !!!            o           _   _     "
echo "    -*~*-          ###           _ _           /_\          \\-//     "
echo "    (o o)         (o o)      -  (OXO)  -    - (o o) -       (o o)     "
echo "ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-"
echo ""
echo ".........................PROCEDURE TERMINEE..........................."
