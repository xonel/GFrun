#! /bin/bash
#
# GFrun
#
#  Auteurs : Le.NoX ;o)
#  M@il : le . nox @ free . fr
#  https://github.com/xonel/GFrun
Version="0.5.1"
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
#(STABLE) : wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
#(DEV)    : wget -N https://github.com/xonel/GFrun/raw/master/GFrun/GFrun.sh && chmod a+x GFrun.sh && sudo bash ./GFrun.sh
##########################################################################################################################################################
#

Vcpt=0
Vcpt_patch=0

HGFrun="$HOME/GFrun"
Hconf_Gplugin="$HOME/.config/garminplugin"
Hconf_Gextractor="$HOME/.config/garmin-extractor"

color(){
	printf '\033[%sm%s\033[m\n' "$@"
}

G_MenRun(){
echo ""
echo "                        "$Vscript $Voption
echo '              """""'
echo '              |c .'
echo '               \ _/'
echo '            ___/(  /('
echo '           /--/ \\//'
echo '       __ )/ /\/ \/'
echo '       -.\  //\\'
echo '         \\//  \\'
echo '          \/    \\'
echo '                 \\'
echo '                  --'
echo "                 $Version"
}

G_Title(){
 	echo ".....................>>>>>>> GFrun "$1" <<<<<<................"
 clear
	echo `color 32 " =============================================================="`
 	echo `color 31 "   GFrun - Garmin Forerunner 60 - 405CX - 310XT - 610 - 910XT "`
	echo `color 32 " =============================================================="`
echo "   : '######...'########.'########..'##....'##.'##... ##:
   :'##... ##.. ##....... ##.... ##. ##.... ##. ###.. ##:
   : ##:::..::: ##::::::: ##:::: ##: ##:::: ##: ####: ##:
   : ##..'####. ######... ########.. ##.... ##. ## ## ##.
   : ##::: ##:: ##...:::: ##.. ##::: ##:::: ##: ##. ####:
   : ##... ##.. ##....... ##... ##.. ##.... ##. ##.. ###:
   :  ######::: ##::::::: ##:::. ##:. #######:: ##::. ##:
   :....................................................:"
   	echo "                                                   " $Version
	echo `color 32 " =============================================================="`
 	echo `color 31 "   Garmin-Forerunner-610-Extractor - garminplugin - gcpuploader "`
	echo `color 32 " =============================================================="`
}

G_Bye(){
echo ".........................      ~ Bye ~     ..........................."
echo ""
echo "                                 !!!            o           _   _     "
echo "    -*~*-          ###           _ _           /_\          \\-//     "
echo "    (o o)         (o o)      -  (OXO)  -    - (o o) -       (o o)     "
echo "ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-"
echo $Version
}

F_Path(){
	echo `color 32 ">>> F_Path"`
	if [ -f $HOME/GFrunLocal/GFrun/GFrun/GFrun.sh ]; then
		Vpath="$HOME/GFrunLocal/GFrun/GFrun"
	else

		if [ -f $HGFrun/GFrun.sh ]; then
			if [ -f $HOME/GFrunDev ]; then
				echo `color 32 "========================"`
				echo "Choise : VERSION - GFrun.sh "
				echo "On Line (Option)   - tape (O/o) "
				echo "Local   (Default)  - tape [ENTER] "
				echo `color 32 "========================"`
				read -p '(Default) [ENTER] : ' Vo
					if [ "$Vo" = "O" ] || [ "$Vo" = "o" ]; then
						Vpath="$HOME"
					else
						Vpath="$HGFrun"
					fi
			else
				Vpath="$HGFrun"
			fi
		else
			Vpath="$HOME"
			mkdir -p $HOME/logs/
		fi
	fi
}

F_extractor(){
	clear
	echo `color 32 ">>> F_extractor"`
	#Extractor FIT
	echo "=== $Vpath/logs/extractorLogs"
	#xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e "python $HGFrun/tools/extractor/garmin.py > $Vpath/logs/extractorLogs | tail && read -p 'Press [Enter] key to continue...' null" 
	python $HGFrun/tools/extractor/garmin.py && read -p 'Press [Enter] key to continue...' null
	#xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 65x35 -e "python $HGFrun/tools/extractor/garmin.py && read -p 'Press [Enter] key to continue...' null" 
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor
	mv $Vpath/*-garmin.log $Vpath/logs/extractor/ 1>/dev/null
}

F_extractor_getkey(){
	clear
	echo `color 32 ">>> F_extractor_getkey"`
	#Pairing Key
	#xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 65x35 -e "python $HGFrun/tools/extractor/extractor_getkey.py && read -p 'Press [Enter] key to continue...' null" 
	python $HGFrun/tools/extractor/extractor_getkey.py && read -p 'Press [Enter] key to continue...' null
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor
	mv $Vpath/*-garmin.log $Vpath/logs/extractor_getkey/
}

F_Xterm_Geometry(){
	echo `color 32 ">>> F_Xterm_Geometry"`
	echo "=== /bin/bash $Vpath/$Vscript $Voption"
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 65x35 -e "/bin/bash $Vpath'/'$Vscript $Voption && read -p 'Press [Enter] key to continue...' null"
}

F_Script(){
	echo `color 32 ">>> F_Script"`
	G_Title
	G_MenRun
	
	if $Vbranche == ''; then
		Vbranche="master"
	fi
	
	VChemin="https://github.com/xonel/GFrun/raw/"$Vbranche"/GFrun/"	
	VWget=$VChemin""$Vscript
	echo `color 32 "===================================================="`
	echo "Wget:" $VWget
	echo "$Vscript $Voption"
	echo "Vbranche = "$Vbranche 
	echo `color 32 "===================================================="`
	echo ""
	echo ""
	
if [ -f $HOME/GFrunLocal/GFrun/GFrun/$Vscript ]; then
	Vpath="$HOME/GFrunLocal/GFrun/GFrun"
	cd $HOME/GFrunLocal/GFrun/GFrun/ && chmod +x ./$Vscript && F_Xterm_Geometry
else
	if [ -f $HGFrun/$Vscript ]; then
		Vpath="$HGFrun"
		cd $HGFrun/ && chmod +x ./$Vscript && F_Xterm_Geometry
	else
		Vpath="$HOME"
		cd $HOME/ && wget -N $VWget && sleep 2 && chmod +x ./$Vscript && F_Xterm_Geometry
	fi
fi
}

F_Dump_Gconnect(){
	clear
	echo `color 32 ">>> F_Dump_Gconnect"`
	G_Title
	echo ""
	echo `color 32 "==============================================================="`
	echo ">>>>>  DUMP ALL ACTIVITIES FROM CONNECT GARMIN <<<<<< " 
	echo `color 32 "==============================================================="`
	echo ""
	echo " (10 ~ 20) mins - PLEASE WAIT ... "
	echo ""
	mkdir -p $Hconf_Gextractor/dump_gconnect/$(date +%Y-%m-%d_%H)
	cd $Hconf_Gextractor/dump_gconnect/$(date +%Y-%m-%d_%H) && python $HGFrun/tools/dump_gconnect.py && read -p ' - DUMP TERMINED - Press [Enter] key to continue...' null
	#cd $Hconf_Gextractor/dump_gconnect/$(date +%Y-%m-%d_%H) && xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 65x15 -e "python $HGFrun/tools/dump_gconnect.py && read -p ' - DUMP TERMINED - Press [Enter] key to continue...' null" 
	
	sudo chown -R $SUDO_USER:$SUDO_USER $Hconf_Gextractor/dump_gconnect/
	cd $Hconf_Gextractor/dump_gconnect/ && mv gpx tcx kml -t $(date +%Y-%m-%d_%H)
	cd $Hconf_Gextractor/dump_gconnect/ && zip -ur dump_gconnect_$(date +%Y-%m-%d_%H) $(date +%Y-%m-%d_%H)
	ln -sf $Hconf_Gextractor/dump_gconnect -T $HOME/GFrun/forerunners/dump_gconnect
	#ln -sf $Hconf_Gextractor/dump_gconnect/dump_gconnect_$(date +%Y-%m-%d_%H).zip -T $HGFrun/forerunners/dump_gconnect/dump_gconnect_$(date +%Y-%m-%d_%H).zip
}

F_Uninstall(){
	echo `color 32 ">>> F_Uninstall"`
	if [ -d $HGFrun/ ]; then

		echo""
		echo `color 31 "======================================================"`
		echo " !! UNINSTALL !! WARNING !! UNINSTALL !!"
		echo -e " ONE BACKUP WILL BE DONE : \n" $HOME"/GFrun_Backup.zip "
		echo `color 31 "======================================================"`
		echo -n 'UNINSTALL ALL (GFrun + ConfigFiles + Activities) >> YES / [NO] : '

		read Vchoix

		if [ "$Vchoix" = "YES" ]; then
				cd $HOME && zip -ur  $HOME/GFrun_Backup.zip  .config/garmin-extractor/ .config/garminplugin/ .local/GFrun 1>/dev/null
				rm -f  /usr/bin/GFrun $HOME/.guploadrc $HOME/.local/share/icons/GFrun.svg $HOME/.local/share/applications/GFrun.desktop /usr/share/icons/GFrun.svg
				rm -Rf  $HGFrun $HOME/.config/garmin-extractor $HOME/.config/garminplugin $HOME/logs 
				rm -Rf  $HGFrun $HOME/.local/share/GFrun
				echo -e " Backup Activities DONE :\n $HOME/GFrun_Backup.zip "
				read -p 'Press [Enter] key to continue...' null
			else
				M_GFrunMenu
		fi
	else
		echo `color 36 "<<< UNINSTALL NOT NEEDED ..."`
	fi
}

F_garminplugin_UBU(){
	echo `color 32 ">>> F_garminplugin_UBU"`

	if [ $(ls /etc/apt/sources.list.d/ | grep "andreas-diesner-garminplugin-$(lsb_release -cs).list ") ] || grep -q "deb http://ppa.launchpad.net/andreas-diesner/garminplugin/ubuntu $(lsb_release -cs) main" < /etc/apt/sources.list ;
	 then
		sudo apt-add-repository -y ppa:andreas-diesner/garminplugin 1>/dev/null
		echo `color 36 "<<< apt-get update : ... "`
		sudo apt-get update 1>/dev/null
		echo `color 36 "<<< apt-get install -y garminplugin : ... "`
		sudo apt-get install -y garminplugin 1>$Verror
	else
		echo `color 36 "<<< apt-get update : ... "`
		sudo apt-get update 1>/dev/null
		echo `color 36 "<<< apt-get install -y garminplugin : ... "`
		sudo apt-get install -y garminplugin 1>$Verror
	fi
	
	if [ -n "$Verror" ]
		then
		echo `color 31 "ERROR : sudo apt-get install -y garminplugin"`
		echo $Verror
		read -p 'Press [Enter] key to continue...' null
		#M_GFrunMenu
	fi
}

F_garminplugin_DEB(){
	echo `color 32 ">>> F_garminplugin_DEB"`
	MACHINE_TYPE=`uname -m`
	if [ ${MACHINE_TYPE} == 'x86_64' ]; then
	  Varchi='~raring_amd64.deb'
	else
	  Varchi='~raring_i386.deb'
	fi

	wget http://ppa.launchpad.net/andreas-diesner/garminplugin/ubuntu/pool/main/g/garminplugin/garminplugin_0.3.17-1$Varchi
	sudo dpkg -i garminplugin_0.3.17-1$Varchi

	mkdir -p $HOME/.mozilla/plugins
	ln -s /usr/lib/mozilla/plugins/npGarminPlugin.so $HOME/.mozilla/plugins/npGarminPlugin.so
}

F_Sudo(){
	echo `color 32 ">>> F_Sudo"`
	if [ ! "$SUDO_USER" ]; then
		echo `color 31 "======================================================"`
		echo "....................... Install GFrun - requires ............."
		echo `color 31 "======================================================"`
		echo '1) Administrator rights (SUDO)'
		echo '2) Debian 7 / ubuntu 12+' 
		echo '3) Python 2.7+'
		echo '4) PyUSB 1.0+'
		echo `color 31 "======================================================"`
		echo ""
		echo "! YOU ARE NOT ADMINISTRATOR !"		
		#echo 'Please : tape your password administrator (SUDO)'
		echo ""
		read -p "Press [Enter] key to continue..." null
		#xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e "sudo "$0"" &
		M_GFrunMenu
	fi
}

F_clean_up(){
	echo `color 32 ">>> F_clean_up"`
	rm -f $HOME/Verror* $HOME/GFrun.sh* $HOME/master.zip* $HGFrun/tools/FIT-to-TCX/master.zip* $HGFrun/tools/master.zip* $HGFrun/tools/pygupload_20120516.zip* /tmp/ligneCmd.sh* 1>/dev/null
	rm -fr $HOME/pyusb/ 1>/dev/null
	cp -fr $HOME/GFrun_Backup $HGFrun/GFrun_Backup 1>/dev/null && rm -fr $HOME/GFrun_Backup 1>/dev/null
	cp -f $HOME/logs $HGFrun/logs 1>/dev/null && rm -fr $HOME/logs 1>/dev/null
}

F_Apt(){
	F_Path
	echo `color 32 ">>> F_Apt"`
	echo $(date +%Y-%m-%d_%H%M)"= BEFORE ==========================" >> $HOME/GFrun_Install.log

	Vlisterror=()
	VlistApt="lsb-release xterm git garminplugin libusb-1.0-0 python python-pip python-usb python-vte python-lxml python-pkg-resources python-poster python-serial"
	
	for i in ${VlistApt} 
		do
			if [ ! "$(dpkg -l | grep -w "$i")" ]; then
				Vlisterror=(${Vlisterror[@]} $i)
				echo `color 31 "NOK = "`$i 
			else
				echo `color 32 "OK = "`$i 
			fi
		done
	
	#Stop si
	if [ "$(echo "${Vlisterror[@]}")" ]; then
		VlisterrorForm="${Vlisterror[@]}"
		
		echo "=============================="
		echo "DEPENDANCES/APPS NOT FOUND : "
		echo `color 31 "${VlisterrorForm}"`
		echo "=============================="
		read -p "Press [Enter] key to continue..." null
		
		if [ "$(dpkg -l | grep -w "garminplugin ")" ]; then
				echo `color 36 "<<< garminplugin already installed"`
		else
				case "$(lsb_release -is)" in
					 Ubuntu) F_garminplugin_UBU;;
					 Debian) F_garminplugin_DEB;;
					 *mga*) echo "Mageia - not supported for the moment ...";;
					 *) echo "not an answer";;
				esac
		fi
		
		dpkg -l >> $HOME/GFrun_Install.log
		
		sudo apt-get update 1>/dev/null
		echo `color 36 "<<< apt-get update : ... "`
		sudo apt-get install -y $VlisterrorForm  1>Verror
		echo `color 36 "<<< apt-get install -y $VlisterrorForm : ... "`
		
		#Import pyusb from Github
		#cd $HOME && git clone https://github.com/walac/pyusb && cd $HOME/pyusb/ && sudo python setup.py install

		sudo pip install pyusb 1>/dev/null
		sudo pip install --upgrade pyusb 1>/dev/null
		
		if [ -n "$Verror" ]
			then
			echo `color 31 "Check APT CONFIG and try again GFrun Install procedure"`
			echo -e "ERROR: \n sudo apt-get install -y $VlisterrorForm \n Info(Verror): $Verror \n"
			read -p 'Press [Enter] key to continue...' null
			M_GFrunMenu	
		fi

	else
		echo "OK = ALL DEPENDANCES"
	fi
	echo $(date +%Y-%m-%d_%H%M)"= AFTER ==========================" >> $HOME/GFrun_Install.log
	dpkg -l >> $HOME/GFrun_Install.log	

}

F_Git(){
	echo `color 32 ">>> F_Git"`
	if [ -f $HOME/GFrunLocal/GFrun/GFrun/GFrun.sh ]; then
		mkdir $HGFrun
		cp -rf $HOME/GFrunLocal/GFrun/* $HGFrun
	else

		if [ -d $HGFrun ]; then
			#TODO : $HOME/GFrunOld_$(date %m-%d_%H%M)
			mv -f $HGFrun $HOME/GFrun_Old 
		fi
		
		#cd $HOME && git clone -b $Vbranche https://github.com/xonel/GFrun.git 1>/dev/null
		cd $HOME && wget -N https://codeload.github.com/xonel/GFrun/zip/$Vbranche 1>/dev/null && unzip -o $Vbranche 1>/dev/null && mv $HGFrun-$Vbranche $HGFrun 1>/dev/null

		cp -rf $HGFrun/_.config/* $HOME/.config/ && rm -r $HGFrun/_.config
		cp -rf $HGFrun/_.local/* $HOME/.local/ && rm -r $HGFrun/_.local
		mv $HGFrun/GFrun/* $HGFrun && rm -r $HGFrun/GFrun/ 
		
		# install pyusb via sources from GFrun /= github and pip
		cd $HGFrun/tools/pyusb/ && sudo python setup.py install 1>/dev/null
		
		if [ -d $Hconf_Gextractor/ ] || [ -d $Hconf_Gplugin/ ] || [ -d $HGFrun/ ] ; then
			echo `color 36 "<<< F_Git : OK"`
		else
			echo `color 31 "F_Git : ERROR (Check your CONFIG and try again GFrun Install procedure)"`
			read -p 'Press [Enter] key to continue...' null
			#M_GFrunMenu
		fi
		
		ln -s $HOME/.local/GFrun/GFrun /usr/bin/GFrun
	fi
}

F_Install(){
	echo `color 32 ">>> F_Install"`

	sudo cp -f $HGFrun/tools/extractor/resources/ant-usbstick2.rules /etc/udev/rules.d/
	sudo cp -f $HGFrun/tools/10-ant-usbstick2.rules /lib/udev/rules.d/
	sudo udevadm control --reload-rules
	
	mkdir -p $Hconf_Gextractor/scripts
	cp -f $HGFrun/tools/extractor/scripts/* $Hconf_Gextractor/scripts/
	
	cp -f $HOME/.local/share/icons/GFrun.svg /usr/share/icons/
	cp -f $HOME/.local/share/icons/GFrunS.svg /usr/share/icons/
	cp -f $HOME/.local/share/icons/GFrunG.svg /usr/share/icons/
	
	mv $HOME/GFrun_Install.log $HGFrun/logs/GFrun_Install.log
	
	ln -sf $HOME/.local/share/GFrun/GFrun -T /usr/bin/GFrun
	
	if [ -f $HOME/GFrunUpdate.zip ]; then
		mv -f $HOME/GFrunUpdate.zip $HGFrun/tools/
	fi

	if [ -f /etc/udev/rules.d/ant-usbstick2.rules ] || [ "$(ls -A $Hconf_Gextractor/scripts/)" ] || [ -f /usr/share/icons/GFrun.svg ] ; then
		echo `color 36 "<<< F_Install : OK"`
	else
		echo `color 31 "F_Install : ERROR (Check your CONFIG and try again GFrun Install procedure)"`
		read -p 'Press [Enter] key to continue...' null
		#M_GFrunMenu
	fi
}

F_Restore(){
	echo `color 32 ">>> F_Restore"`
	if [ -f $HOME/GFrun_Backup.zip ] ; then
			echo "=============================="
			read -p 'RESTORE BACKUP (Y/N) ? ' Vo
			echo "=============================="
			echo ""
			case "$Vo" in
				 y|Y)	sudo unzip -o GFrun_Backup.zip -d /tmp/GFrun_A_B/ 1>/dev/null 

						PATH_TRAVAIL="/tmp/GFrun_A_B/.config/garmin-extractor"
						NUMERO_DE_MA_MONTRE=$(ls $PATH_TRAVAIL | grep [0123456789])
						NBRS_DE_MONTRE=$(ls $PATH_TRAVAIL | grep [0123456789] -c)
						
						echo "=== PATH_TRAVAIL= " $PATH_TRAVAIL
						echo "=== NUMERO_DE_MA_MONTRE= " $NUMERO_DE_MA_MONTRE
						echo "=== NBRS_DE_MONTRE= " $NBRS_DE_MONTRE
						
						if [ -n "$NUMERO_DE_MA_MONTRE" ] && [ "$NBRS_DE_MONTRE" == "1" ]; then
							
							mkdir $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/ 2>/dev/null
							mkdir $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/activities/ 2>/dev/null
							mkdir $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/activities_tcx/ 2>/dev/null
							
							sudo cp -rf $PATH_TRAVAIL/$NUMERO_DE_MA_MONTRE/activities/ $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/
							sudo cp -rf $PATH_TRAVAIL/$NUMERO_DE_MA_MONTRE/activities_tcx/ $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/
							
							mkdir $HOME/GFrun_Backup/
							mv -f $HOME/GFrun_Backup.zip $HOME/GFrun_Backup/$(date +%Y_%m_%d_%H%M) 1>/dev/null
							
							sudo chown -R $SUDO_USER:$SUDO_USER $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/
							sudo rm -R /tmp/GFrun_A_B/ 1>/dev/null
							echo `color 36 "<<< F_Restore : OK"`
						fi;;
						
				 n|N) echo `color 36 "<<< CANCEL - RESTORE BACKUP"`;;
				 *) echo "not an answer";;
			esac	
	else
		echo `color 36 "<<< NO BACKUP DETECTED"`
		read -p 'Press [Enter] key to continue...' null
	fi
}

F_Update(){
	echo `color 32 ">>> F_Update"`
	Vbranche="master"
	Vscript="GFrun.sh"
	
	echo `color 36 "<<< wget https://codeload.github.com/xonel/GFrun/zip/$Vbranche/GFrun/$Vscript"`	
	cd $HOME/ && wget "https://codeload.github.com/xonel/GFrun/zip/$Vbranche/GFrun/$Vscript" 1>/dev/null

	cp -f $HOME/GFrun.sh $HGFrun/
	echo `color 36 "<<< UPDATE SCRIPT : $Vbranche - $Vscript"`

	read -p 'Do you want update CORE $Vbranche (N/y) ?' Vo
			case "$Vo" in
				 y|Y)
					echo `color 36 "<<< wget https://codeload.github.com/xonel/GFrun/zip/$Vbranche"`				 		
					cd $HOME && wget -N https://codeload.github.com/xonel/GFrun/zip/$Vbranche 1>/dev/null && unzip -o $Vbranche 1>/dev/null && mv $HGFrun-$Vbranche $HGFrun 1>/dev/null

					rm -r $HGFrun/_.config
					rm -r $HGFrun/_.local
					cp -f $HGFrun/GFrun/* $HGFrun && rm -r $HGFrun/GFrun/
					echo `color 36 "<<< UPDATE CORE : $Vbranche.zip"`;;
					
				 n|N|*) echo "NO UPDATE CORE";;

			esac

	
	if [ -f $HOME/GFrunUpdate.zip ] ; then
		unzip -o $HOME/GFrunUpdate.zip -d $HOME/ 1>/dev/null
	else
			if [ -f $HGFrun/tools/GFrunUpdate.zip ] ; then
				unzip -o $HGFrun/tools/GFrunUpdate.zip -d $HOME/ 1>/dev/null
			else
				echo `color 36 "<<< NO UPDATE DETECTED"`
			fi
	fi
}

F_config_Gconnect(){
	F_Path
	echo `color 32 ">>> F_config_Gconnect"`

	#$NUMERO_DE_MA_MONTRE
	NUMERO_DE_MA_MONTRE=$(ls $Hconf_Gextractor/ | grep [0123456789])
	NBRS_DE_MONTRE=$(ls $Hconf_Gextractor/ | grep [0123456789] -c)

	if [ -n "$NUMERO_DE_MA_MONTRE" ] && [ "$NBRS_DE_MONTRE" == "1" ]; then
		echo $NUMERO_DE_MA_MONTRE >> $Vpath/logs/IDs
		
		PATH_ACTIVITES="$Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/activities/"
		if [ -d $HOME/.config/garmin-extractor ] && [ -d $PATH_ACTIVITES ] ; then
			#mkdir -p $HGFrun/forerunners/dump_gconnect
			mkdir -p $HGFrun/forerunners/$NUMERO_DE_MA_MONTRE
			ln -sf $PATH_ACTIVITES -T $Hconf_Gplugin/Garmin/Activities
			ln -sf $PATH_ACTIVITES -T $HGFrun/forerunners/$NUMERO_DE_MA_MONTRE/activities

			#Garminplugin GarminDevice.xml
			src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $Hconf_Gplugin/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
			#02_convert_to_tcx.py
			src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HGFrun/tools/FIT-to-TCX/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $Hconf_Gextractor/scripts/02_convert_to_tcx.py" >> /tmp/ligneCmd.sh
			src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $Hconf_Gplugin/garminplugin.xml" >> /tmp/ligneCmd.sh
			#start ligneCmd.sh & check config garminplugin
			chmod u+x /tmp/ligneCmd.sh && /bin/bash /tmp/ligneCmd.sh
			cat $Hconf_Gplugin/garminplugin.xml | grep $NUMERO_DE_MA_MONTRE 1>/dev/null
			cat $Hconf_Gplugin/Garmin/GarminDevice.xml | grep $HOME 1>/dev/null

			echo `color 32 "============================================="`
			echo "...> CONFIG : KEY Forerunner & Garminplugin - OK - : " $Vcpt 
			echo `color 32 "============================================="`
		else
			clear
			echo `color 31 "============================================="`
			echo "ERROR : $HOME/.config/garmin-extractor"
			echo""
			echo "PLease check your setting HARDWARE / SOFTWARE & Reinstall GFrun."
			echo `color 31 "============================================="`	
			
			echo '==================================================================='>> $Vpath/logs/DIAG
			echo 'ERROR : $HOME/.config/garmin-extractor - NOT FOUND -' >> $Vpath/logs/DIAG
			echo '==================================================================='>> $Vpath/logs/DIAG
			read -p 'Press [Enter] key to continue...' null
			
			F_chownchmod
			F_clean_up
			#M_GFrunMenu			
		fi
		
	else
		if [ $Vcpt -lt 3 ]; then
			Vcpt=$(($Vcpt+1))
					
			echo `color 31 "============================================="`
			echo "...> Grab Key from Forerunner - Testing" $Vcpt "/3" 
			echo `color 31 "============================================="`	
			echo "You need :"	
			echo '...1) Garmin ForeRunner [ ON ] + [PARING MODE ]'
			echo '...2) Dongle USB-ANT plugged'
			echo ""
			echo `color 31 "============================================="`
			F_extractor_getkey
			F_config_Gconnect
		else
			clear
			echo `color 31 "============================================="`
			echo "ERROR : Key GARMIN Forerunner - NOT FOUND -"
			echo""
			echo "PLease check your setting HARDWARE / SOFTWARE."
			echo `color 31 "============================================="`	
			
			echo '==================================================================='>> $Vpath/logs/DIAG
			echo 'ERROR : Key GARMIN Forerunner - NOT FOUND -' >> $Vpath/logs/DIAG
			echo '==================================================================='>> $Vpath/logs/DIAG
			read -p 'Press [Enter] key to continue...' null
			F_Diag
			F_chownchmod
			F_clean_up
			#M_GFrunMenu
		fi
	fi
}

F_config_gupload(){
	echo `color 32 ">>> F_config_gupload"`
	clear
	echo "# WARNING, THIS IS NOT SECURE. USE THIS OPTION AT YOUR OWN RISK."  
	echo "# Username and password are stored as CLEAR text in a file :"
	echo "# $HOME/.local/share/GFrun/.guploadrc"
	
	echo `color 32 "============================================="`
	echo "Configuration Auto-Upload on connect.garmin.com"
	echo `color 32 "============================================="`
	
	#TODO : Encrypt Login / Password

	if [ ! -f $HOME/.local/share/GFrun/.guploadrc ]; then
			read -p 'USERNAME : on connect.garmin.com >> ' Read_user
			read -p 'PASSWORD : on connect.garmin.com >> ' Read_password

			echo "[Credentials]" >> $HOME/.local/share/GFrun/.guploadrc
			echo "enabled = True" >> $HOME/.local/share/GFrun/.guploadrc
			echo "username="$Read_user"" >> $HOME/.local/share/GFrun/.guploadrc
			echo "password="$Read_password"" >> $HOME/.local/share/GFrun/.guploadrc
		else
			echo ""
			echo `color 31 "============================================="`
			echo "Configuration file already exist"
			echo "$HOME/.local/share/GFrun/.guploadrc"
			echo `color 31 "============================================="`

			read -p 'Do you want create new one (N/y) ?' Vo
			case "$Vo" in
				 y|Y)	rm -f $HOME/.local/share/GFrun/.guploadrc
						F_config_gupload;;
				 n|N) echo "OK";;
				 *) echo "not an answer";;
			esac
	fi
	ln -s -f $HOME/.local/share/GFrun/.guploadrc $HOME/.guploadrc 
}

F_chownchmod(){
	echo `color 32 ">>> F_chownchmod"`
	#Chown Chmod
	chown -R $SUDO_USER:$SUDO_USER  $HGFrun $Hconf_Gextractor $Hconf_Gplugin $HOME/.local/share/GFrun 1>/dev/null
	chown -R $SUDO_USER:$SUDO_USER $HOME/logs $HOME/GFrun_Old $HOME/GFrun_Backup 2>/dev/null
	chmod -R a+x $Hconf_Gextractor/scripts/ $HGFrun/tools/ $HOME/.local/share/GFrun/GFrun
}

F_Diag(){
	F_Path
	echo `color 32 ">>> F_Diag"`
	echo " DIAG FONCTION"
	echo '==================================================================='
	echo 'rm -f $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/authfile'
	echo '==================================================================='
	
	NUMERO_DE_MA_MONTRE=$(ls $Hconf_Gextractor/ | grep [0123456789])
	rm -f $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/authfile

	echo "GFrun - $Vbranche - $Version " > $Vpath/logs/DIAG
	uname -a >> $Vpath/logs/DIAG
	lsb_release -a >> $Vpath/logs/DIAG
	
	echo '1 ======================================= date '>> $Vpath/logs/DIAG
	echo $(date +%Y-%m-%d_%H%M) >> $Vpath/logs/DIAG
	echo '2 ======================================= usb-devices'>> $Vpath/logs/DIAG
	usb-devices | grep Vendor=0fcf >> $Vpath/logs/DIAG
	echo '3 ======================================= cat $HGFrun/logs/IDs'>> $Vpath/logs/DIAG
	cat $HGFrun/logs/IDs >> $Vpath/logs/DIAG
	echo '4 ======================================= cat /etc/udev/rules.d/ant-usbstick2.rules'>> $Vpath/logs/DIAG
	cat /etc/udev/rules.d/ant-usbstick2.rules >> $Vpath/logs/DIAG
	echo '5 ======================================= ls /etc/udev/rules.d/'>> $Vpath/logs/DIAG
	ls /etc/udev/rules.d/ >> $Vpath/logs/DIAG
	echo '6 ======================================= ls -l /dev/ttyUSB'>> $Vpath/logs/DIAG
	ls -l /dev/ttyUSB* >> $Vpath/logs/DIAG
	echo '7 ======================================= lsmod'>> $Vpath/logs/DIAG
	lsmod >> $Vpath/logs/DIAG
	echo '8 ======================================= dpkg -l | grep libusb'>> $Vpath/logs/DIAG
	dpkg -l | grep libusb >> $Vpath/logs/DIAG
	echo '9 ======================================= python --version'>> $Vpath/logs/DIAG
	python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))'>> $Vpath/logs/DIAG 
	echo '10 ======================================= ls -al /usr/lib/mozilla/plugins/'>> $Vpath/logs/DIAG
	ls -al /usr/lib/mozilla/plugins/ >> $Vpath/logs/DIAG
	echo '11 ======================================= ls -al $HOME/.mozilla/plugins/'>> $Vpath/logs/DIAG
	ls -al $HOME/.mozilla/plugins/ >> $Vpath/logs/DIAG
	
	read -p 'Press [Enter] key to continue...' null
}

F_Upload_Gconnect_Go(){
	echo `color 32 ">>> F_Upload_Gconnect_Go"`
	echo `color 31 "============================================="`
	echo " LOCAL > ...> Upload Activities on going >... > GARMIN.COM" 
	echo `color 31 "============================================="`	
	echo " Script >>> python $HGFrun/tools/pygupload/gupload.py -v 1 $Vactivities"
	
	NUMERO_DE_MA_MONTRE=$(ls $Hconf_Gextractor/ | grep [0123456789])
	cd $Hconf_Gextractor/$NUMERO_DE_MA_MONTRE/activities && python $HGFrun/tools/pygupload/gupload.py -v 1 $Vactivities
}

F_Upload_Gconnect(){
	clear
	echo `color 32 ">>> F_Upload_Gconnect"`
	echo ""
	echo `color 32 "=================================="`
	echo "SELECT ACTIVITIES PERIOD"
	echo `color 32 "=================================="`
	echo ""
	echo " (T) - Today"
	echo " (W) - Week" 
	echo " (M) - Month"
	echo " (Y) - Years" 
	echo ""
	echo -n "Choise : (t) . (w) . (m) . (y) "
	read Vchoix

        case $Vchoix
        in
          [tT]) # (T) - Today
			Vactivities=$(date +%Y-%m-%d_*)
			F_Upload_Gconnect_Go
            ;;

          [wW]) # (W) - Week	
			for c in 1 2 3 4 5 6 7
				do 
				Vactivities=$(date "+%Y-%m-%d_*" -d "$c days ago")
				F_Upload_Gconnect_Go
			done
            ;;

          [mM]) # (M) - Month
			Vactivities=$(date +%Y-%m-*)
			F_Upload_Gconnect_Go
            ;;

          [yY]) # (Y) - Years
			Vactivities=$(date +%Y-*)
			F_Upload_Gconnect_Go
            ;;
        esac
}

F_GFrunGui(){
xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 5x1 -e 'cd $HOME/GFrun && /bin/bash ./tools/GFrunGui/go_ExConsole.sh'
}

M_Main(){
	echo `color 32 ">>> M_Main"`
	case $VMain
		in
           -s) # 1. STABLE.........................(GFrun.sh -s .)
		       #########################################################
				Vbranche="GFrun"
				F_Sudo
				F_Uninstall
				F_clean_up
				F_Apt
				F_Git
				F_Install
				#F_Update
				F_Restore
				F_config_Gconnect
				F_config_gupload
				F_chownchmod
#				F_extractor
				F_clean_up
            ;;
          -d) #2. DEV ...........................(GFrun.sh -d .)
		       #########################################################
				Vbranche="master"
				F_Sudo
				F_Uninstall
				F_clean_up
				F_Apt
				F_Git
				F_Install
				#F_Update
				F_Restore
				F_config_Gconnect
				F_config_gupload
				F_chownchmod
#				F_extractor
				F_clean_up
            ;;
          -up) # 3. UPDATE.........................(GFrun.sh -up)
		       #########################################################
				Vbranche="master"
				F_Sudo
				F_Update
				F_Restore
				F_chownchmod
				F_clean_up
             ;;
             
          -cp) # 4. Conf-Pairing...................(GFrun.sh -cp )
		       #########################################################
				F_extractor_getkey
             ;;
             
          -cg) # 5. Conf-Garmin.com................(GFrun.sh -cg )
		       #########################################################
				F_config_Gconnect
				F_config_gupload
             ;;
             
          -el) # 6. Extract.Fit >> Local...........(GFrun.sh -el ) 
		       #########################################################
				F_extractor
             ;;
             
          -gl) #7. Garmin.com .>> Local ..........(GFrun.sh -gl ) 
		       #########################################################
				F_Dump_Gconnect
             ;;
             
          -lg) # 8. Local.Fit ..>> Garmin.com .....(GFrun.sh -lg ) 
		       #########################################################
				F_Upload_Gconnect
             ;;

          -eg) # 9. Extract.Fit >> Garmin.com......(GFrun.sh -eg ) 
		       #########################################################
				F_extractor
				Vactivities=$(date +%Y-%m-*)
				F_Upload_Gconnect_Go
             ;;
             
          -cd) #D. Conf-Diag .....................(GFrun.sh -cd ) 
		       #########################################################
				F_Diag
				F_extractor
             ;;

          -un) #U. UNINSTALL......................(GFrun.sh -un )
		       #########################################################
		       	F_Sudo
				F_Uninstall
				F_clean_up
             ;;
             
          -menu) #. GFrunMenu .........................(GFrun.sh -menu )
		       #########################################################
				M_GFrunMenu
             ;;
             
          -gui) #. GFrunGUI .........................(GFrun.sh -gui )
		       #########################################################
				F_GFrunGui
             ;;

          *)   # anything else
		       #########################################################
            echo "\"$VMain\" NO VALID ENTRY - GFrun.sh"
            ;;
        esac
}

M_GFrunMenu(){
	
		G_Title
        echo ""		
        echo "INSTALL :"
        echo "---------"
        echo `color 32 " 1. STABLE.........................(GFrun.sh -s .)"`
        echo `color 32 " 2. DEV ...........................(GFrun.sh -d .)"`
        echo `color 32 " 3. UPDATE.........................(GFrun.sh -up )"`
        echo `color 32 " U. UNINSTALL......................(GFrun.sh -un )"`
        echo ""
        echo "CONFIG :"
        echo "--------"
        echo `color 36 " 4. Conf-Pairing...................(GFrun.sh -cp )"`
        echo `color 36 " 5. Conf-Garmin.com................(GFrun.sh -cg )"`
        echo `color 36 " D. Conf-Diag .....................(GFrun.sh -cd )"`
        echo ""
        echo "ACTIVITIES :"
        echo "-----------"
        echo `color 33 " 6. Extract.Fit >> Local...........(GFrun.sh -el )"`
        echo `color 33 " 7. Garmin.com .>> Local ..........(GFrun.sh -gl )"`
        echo `color 33 " 8. Local.Fit ..>> Garmin.com .....(GFrun.sh -lg )"`
        echo `color 33 " 9. Extract.Fit >> Garmin.com......(GFrun.sh -eg )"`
        echo ""
        echo `color 31 " X. Exit ..........................(GFrun Bye :0 )"`
        echo""
        echo "-------------┐"
        echo -n "CHOICE : "
        read Vchoix
        echo "-------------┘"
        case $Vchoix
        in
          1) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-s"
		Vbranche="V05" 
		F_Script
		#############################          
            ;;

          *2*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-d"
		Vbranche="master" 
		F_Script
		#############################
            ;;
            
          *3*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-up"
		Vbranche="master"
		Vpath="$HGFrun" 
		F_Script
		#############################
		
            ;;
          *4*)     
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-cp"
		F_Script
		############################# 
            ;;

          *5*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-cg"
		F_Script
		#############################
            ;;

          *6*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-el"
		F_Script
		#############################           
            ;;

          *7*) 
		#############################
		VChemin=$VChemin
		Vscript="GFrun.sh"
		Voption="-gl"
		F_Script
		#############################
            ;;

          *8*) 
		#############################
		VChemin=$VChemin
		Vscript="GFrun.sh"
		Voption="-lg"
		F_Script
		#############################
            ;;

          *9*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-eg"
		F_Script
		#############################  
            ;;

          [uU])  
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-un"
		F_Script
		#############################  
            ;;

          [dD])
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-cd"
		F_Script
		#############################  

            ;;

          [xX]) # exit
				G_Bye        
				sleep 2
				exit
            ;;

          *) # anything else
		################################################################
            echo "\"$Vchoix\" NO VALID ENTRY - GFrun.sh"
			M_GFrunMenu
            ;;
        esac
}

if [ -z "$1" ]; then #the -z operator checks whether the string is null // -n operator checks whether the string is not null
	G_Title
	read -p 'Do you want run GFrunMenu / GFrunGui / Exit : (M) / g / e ?' Vo
		case "$Vo" in
			E|e)	G_Bye
					sleep 2
					exit;;
					
			G|g)	F_GFrunGui;;
					
			M|m|*)	M_GFrunMenu;;
		esac
else
	VMain=$1
	M_Main
fi
