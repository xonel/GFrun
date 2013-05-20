#! /bin/bash
#
# GFrun
#
#  Auteurs : Le.NoX ;o)
#  M@il : le.nox @ free.fr
#  Version="0.4.1"
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
##########################################################################################################################################################
#(STABLE - GFrun)  : wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
#(DEV    - MASTER) : wget -N https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
##########################################################################################################################################################
#
#Vbranche="GFrun"
Vbranche="master"
Vcpt=0

color()
{
printf '\033[%sm%s\033[m\n' "$@"
}

echo `color 32 ">>> SUDO_USER"`

if [ ! "$SUDO_USER" ]; then
	echo "Installing GFrun requires administrator rights."
fi

F_uninstall(){
echo " BACKUP WILL BE DONE INSIDE : " $HOME"/GFrun_Activities_Backup.zip "
echo""
echo `color 31 "======================================================"`
echo " !! UNINSTALL !! WARNING !! UNINSTALL !!"
echo `color 31 "======================================================"`
echo -n "UNINSTALL ALL (FGrun + ConfigFiles + Activities) >> YES / [NO] :"

read Vchoix

	if [ "$Vchoix" = "YES" ]; then
			zip -ur  $HOME/GFrun_Activities_Backup.zip  $HOME/.config/garmin-extractor/
			rm -f  $HOME/.local/share/icons/GFrun.svg $HOME/.local/share/applications/GFrun.desktop /usr/share/icons/GFrun.svg
			rm -Rf  $HOME/GFrun $HOME/.config/garmin-extractor $HOME/.config/garminplugin
			echo " Backup Activities DONE : $HOME/GFrun_Activities_Backup.zip "
		else
			sh $HOME/GFrun/install/GFrunMenu.sh
	fi
}

F_clear(){
echo `color 32 ">>> F_clear"`
	#Nettoyage
	rm -f $HOME/GFrun.sh* $HOME/master.zip* $HOME/GFrun/resources/FIT-to-TCX-master/master.zip* $HOME/GFrun/resources/master.zip* $HOME/GFrun/resources/pygupload_20120516.zip* /tmp/ligneCmd.sh*
	rm -Rf  $HOME/GFrun/resources/FIT-to-TCX-master/python-fitparse-master $HOME/GFrun/Garmin-Forerunner-610-Extractor-master
}

F_mkdir(){
echo `color 32 ">>> F_mkdir"`
	mkdir -p $HOME/GFrun/resources/FIT-to-TCX-master/
	mkdir -p $HOME/.config/garmin-extractor/scripts/
	mkdir -p $HOME/.config/garminplugin
	mkdir -p $HOME/.config/garmin-extractor/gconnect/
}

F_apt(){
echo `color 32 ">>> F_apt"`
	dpkg -l > /tmp/pkg-before.txt
	
	sudo apt-get install -y lsb-release python python-pip libusb-1.0-0 python-lxml python-pkg-resources python-poster python-serial
	
	#[repos]
	if ! grep -q "deb http://ppa.launchpad.net/andreas-diesner/garminplugin/ubuntu $(lsb_release -cs) main" < /etc/apt/sources.list
	 then
		if [ "$(lsb_release -is)" = "ubuntu" ]; then
			sudo apt-add-repository -y ppa:andreas-diesner/garminplugin
		else
			echo "deb http://ppa.launchpad.net/andreas-diesner/garminplugin/ubuntu $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list
			sudo apt-get update >> /dev/null 2> /tmp/${NAME}_apt_add_key.txt
			key=`cat /tmp/${NAME}_apt_add_key.txt | cut -d":" -f6 | cut -d" " -f3`
			apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key
			rm -rf /tmp/${NAME}_apt_add_key.txt
		fi
	fi

	#[packages]
	sudo apt-get install -y garminplugin
	sudo apt-get upgrade
	pip install pyusb
	dpkg -l > /tmp/pkg-after.txt
	}

F_wget(){
echo `color 32 ">>> F_wget"`
	cd $HOME && wget -N https://github.com/Tigge/Garmin-Forerunner-610-Extractor/archive/master.zip
	cd $HOME/GFrun/resources/ && wget -N https://github.com/Tigge/FIT-to-TCX/archive/master.zip
	cd $HOME/GFrun/resources/FIT-to-TCX-master/ && wget -N https://github.com/dtcooper/python-fitparse/archive/master.zip
	cd $HOME/GFrun/resources/ && wget -N http://freefr.dl.sourceforge.net/project/gcpuploader/pygupload_20120516.zip
	cd $HOME && wget https://github.com/xonel/GFrun/raw/$Vbranche/GFrunOffline.zip
}

F_unzip(){
echo `color 32 ">>> F_unzip"`
	#Garmin-Forerunner-610-Extractor-master
	cd $HOME && unzip -o master.zip -d GFrun
	#FIT-to-TCX-master
	cd $HOME/GFrun/resources/ && unzip -o master.zip
	#python-fitparse-master
	cd $HOME/GFrun/resources/FIT-to-TCX-master/ && unzip -o master.zip
	#gupload
	cd $HOME/GFrun/resources/ && unzip -o pygupload_20120516.zip
	#script install
	cd $HOME && unzip -oC GFrunOffline.zip "GFrun/install/*" "GFrun/resources/gconnect.py" ".config/*" ".local/*" -d $HOME/
}

F_cpmv(){
echo `color 32 ">>> F_cpmv"`
	
	cp -f $HOME/GFrun/resources/ant-usbstick2.rules /etc/udev/rules.d/
	udevadm control --reload-rules
	
	#Garmin-Forerunner-610-Extractor-master
	cp -Rf $HOME/GFrun/Garmin-Forerunner-610-Extractor-master/* $HOME/GFrun
	##Convert fit to tcx
	cp -f $HOME/GFrun/scripts/40-convert_to_tcx.py $HOME/.config/garmin-extractor/scripts/
	cp -Rf $HOME/GFrun/resources/FIT-to-TCX-master/python-fitparse-master/fitparse $HOME/GFrun/resources/FIT-to-TCX-master/
	mv -f $HOME/GFrunOffline.zip $HOME/GFrun/resources/
	#Icons
	cp -f $HOME/.local/share/icons/GFrun.svg /usr/share/icons/
	#getkey.py
	cp -f $HOME/GFrun/resources/getkey.py $HOME/GFrun/
}

F_extractfit(){
echo `color 32 ">>> F_extractfit"`
	#Extractor FIT
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e 'cd $HOME/GFrun/ && python ./garmin.py'
}

F_getkey(){
echo `color 32 ">>> F_getkey"`
	#Extractor FIT
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e 'cd $HOME/GFrun/ && python ./getkey.py'
}

F_configfiles(){
echo `color 32 ">>> F_configfiles"`

	#$NUMERO_DE_MA_MONTRE
	NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts | grep -v gconnect)

	#GarminDevice.xml
	if [ -n "$NUMERO_DE_MA_MONTRE" ]; then
		echo $NUMERO_DE_MA_MONTRE >> $HOME/GFrun/resources/IDs
		cd $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/
		ln -sf $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities -T $HOME/.config/garmin-extractor/Garmin/Activities
		ln -sf $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE -T $HOME/GFrun/$NUMERO_DE_MA_MONTRE
		src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
		
		echo `color 32 "============================================="`
		echo "...> CONFIG KEY Forerunner - OK - : " $Vcpt 
		echo `color 32 "============================================="`	
	else
		if [ $Vcpt -lt 3 ]; then
			Vcpt=$(($Vcpt+1))
					
			echo `color 31 "============================================="`
			echo "...> Grab Key from Forerunner - Testing" $Vcpt "/3" 
			echo `color 31 "============================================="`	
			echo "You need :"	
			echo "...1) Garmin ForeRunner [ ON ] + [PARING MODE ]"
			echo "...2) Dongle USB-ANT plugged"
			echo ""
			echo `color 31 "============================================="`
			F_getkey
			sleep 3
			F_configfiles
			sleep 5 #Delay USB-ANT time out connect 
		fi
	fi

	#40-convert_to_tcx.py
	src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HOME/GFrun/resources/FIT-to-TCX-master/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/scripts/40-convert_to_tcx.py" >> /tmp/ligneCmd.sh
	src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/garminplugin.xml" >> /tmp/ligneCmd.sh

	#ligneCmd.sh
	chmod u+x /tmp/ligneCmd.sh && sh /tmp/ligneCmd.sh
}

F_chownchmod(){
echo `color 32 ">>> F_chownchmod"`
	#Chown Chmod
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garminplugin $HOME/.config/garmin-extractor $HOME/GFrun $HOME/.local/share/
	chmod -R a+x $HOME/.config/garmin-extractor/scripts/ $HOME/GFrun/install/ $HOME/GFrun/scripts/ 
}

F_chk_GFrunOffline(){
echo `color 32 ">>> F_chk_GFrunOffline"`
if [ -f $HOME/GFrunOffline.zip ] ; then
		unzip -o $HOME/GFrunOffline.zip -d $HOME/
	else
		if [ -f $HOME/GFrun/resources/GFrunOffline.zip ] ; then
			unzip -o $HOME/GFrun/resources/GFrunOffline.zip -d $HOME/
			else
				cd $HOME && wget https://github.com/xonel/GFrun/raw/$Vbranche/GFrunOffline.zip && unzip -o GFrunOffline.zip
				unzip -o $HOME/GFrunOffline.zip -d $HOME/
		fi
fi
}

F_conf_gupload(){
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
			echo  "CHECK >> $HOME/.guploadrc"
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
          -d) # 1. Full Install DEV
		####################################################################
				F_clear
				F_mkdir
#				F_chk_GFrunOffline
				F_apt
				F_wget
				F_unzip
				F_cpmv
				F_configfiles
				F_chownchmod
				F_extractfit
				F_clear
		####################################################################
            ;;

          -s) # 2. Full Install STABLE
		####################################################################
				F_clear
				F_mkdir
				F_chk_GFrunOffline
				F_apt
#				F_wget
				F_unzip
				F_cpmv
				F_configfiles
				F_chownchmod
				F_extractfit
				F_clear
		####################################################################
            ;;

          -o) # 3. Full Install LOCAL / UPDATE
		####################################################################
				F_clear
				F_mkdir
				F_chk_GFrunOffline
#				F_apt
#				F_wget
				F_unzip
				F_cpmv
				F_configfiles
				F_chownchmod
				F_extractfit
				F_clear
		####################################################################
             ;;
             
          -c) # 5. Config Garminplugin -(connect.garmin.com)
		####################################################################
				F_configfiles
		####################################################################
             ;;

          -e) # 6. Telecharger Activites - (Montre > Local) 
		####################################################################
				F_extractfit
		####################################################################
             ;;

          -a) # 9. Extract>>Local>>garmin.com.....(GFrun.sh -a) 
		####################################################################
				F_extractfit
				sh $HOME/GFrun/install/gupload.sh -auto
		####################################################################
             ;;

          -g) # 4. Config Auto-Upload		(gupload) 
		####################################################################
				F_conf_gupload
		####################################################################
             ;;

          -u) #U. UNINSTALL......................(GFrun.sh -x) 
		####################################################################
				F_uninstall
				F_clear
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
		sleep 3
		sh $HOME/GFrunMenu.sh
	else
		if [ -f $HOME/GFrun/install/GFrunMenu.sh ]; then
			sleep 3
			sh $HOME/GFrun/install/GFrunMenu.sh
		fi
	fi
exit

