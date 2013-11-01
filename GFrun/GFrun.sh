#! /bin/bash
#
# GFrun
#
#  Auteurs : Le.NoX ;o)
#  M@il : le . nox @ free . fr
#  https://github.com/xonel/GFrun
Version="0.5.0"
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
#(STABLE) : wget -N https://github.com/xonel/GFrun/raw/master/GFrun/GFrun.sh && chmod a+x GFrun.sh && sudo bash ./GFrun.sh
##########################################################################################################################################################
#

Vcpt=0



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
		if [ -f $HOME/GFrun/GFrun.sh ]; then
			Vpath="$HOME/GFrun"
		fi
	fi
	echo "=> "$Vpath
}

F_extractor(){
	F_Path
	echo `color 32 ">>> F_extractor"`
	#Extractor FIT
	echo "$Vpath/logs/extractorLogs"
	#xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e "python $HOME/GFrun/tools/extractor/garmin.py > $Vpath/logs/extractorLogs | tail && read -p 'Press [Enter] key to continue...' null" 
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e "python $HOME/GFrun/tools/extractor/garmin.py && read -p 'Press [Enter] key to continue...' null" 
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor
	mv $Vpath/*-garmin.log $Vpath/logs/extractor/
}

F_extractor_getkey(){
	F_Path
	echo `color 32 ">>> F_extractor_getkey"`
	#Pairing Key
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e "python $HOME/GFrun/tools/extractor/extractor_getkey.py && read -p 'Press [Enter] key to continue...' null" 
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor
	mv $Vpath/*-garmin.log $Vpath/logs/extractor_getkey/
}

F_Xterm_Geometry(){
	F_Path
	echo `color 32 ">>> F_Xterm_Geometry"`
	echo "/bin/bash $Vpath/$Vscript $Voption"
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 35x15 -e "/bin/bash $Vpath'/'$Vscript $Voption && read -p 'Press [Enter] key to continue...' null"
}

F_Script(){
	echo `color 32 ">>> F_Script"`
	G_Title
	G_MenRun
	VChemin="https://github.com/xonel/GFrun/raw/"$Vbranche"/GFrun/"	
	VWget=$VChemin""$Vscript
	echo `color 32 "===================================================="`
	echo "Wget:" $VWget
	echo "$Vscript $Voption"
	echo `color 32 "===================================================="`
	echo ""
	echo ""
if [ -f $HOME/GFrunLocal/GFrun/GFrun/$Vscript ]; then
	cd $HOME/GFrunLocal/GFrun/GFrun/ && chmod +x ./$Vscript && F_Xterm_Geometry
else
	if [ -f $HOME/GFrun/$Vscript ]; then
		cd $HOME/GFrun/ && chmod +x ./$Vscript && F_Xterm_Geometry
	else
		cd $HOME/ && wget -N $VWget && sleep 2 && chmod +x ./$Vscript && F_Xterm_Geometry
	fi
fi
}

F_Dump_Gconnect(){
	G_Title
	echo `color 32 "======================================================================="`
	echo ">>>>>  DUMP ALL ACTIVITIES FROM CONNECT GARMIN <<<<<< " 
	echo `color 32 "======================================================================="`
	echo ""
	echo " (10 ~ 20) mins - PLEASE WAIT ... "
	echo ""
	mkdir $HOME/GFrun/forerunners/dump_gconnect/$(date +%Y-%m-%d_%H%M)
	cd $HOME/GFrun/forerunners/dump_gconnect/$(date +%Y-%m-%d_%H%M) && xterm -e 'python $HOME/GFrun/tools/dump_gconnect.py && chown -R $SUDO_USER:$SUDO_USER $HOME/GFrun/forerunners/dump_gconnect/' &
}

F_Uninstall(){
	echo " BACKUP WILL BE DONE INSIDE : " $HOME"/GFrun_Activities_Backup.zip "
	echo""
	echo `color 31 "======================================================"`
	echo " !! UNINSTALL !! WARNING !! UNINSTALL !!"
	echo `color 31 "======================================================"`
	echo -n 'UNINSTALL ALL (FGrun + ConfigFiles + Activities) >> YES / [NO] :'

	read Vchoix

	if [ "$Vchoix" = "YES" ]; then
			zip -ur  $HOME/GFrun_Activities_Backup.zip  $HOME/.config/garmin-extractor/
			rm -f  $HOME/.local/GFrun/.guploadrc $HOME/.local/share/icons/GFrun.svg $HOME/.local/share/applications/GFrun.desktop /usr/share/icons/GFrun.svg
			rm -Rf  $HOME/GFrun $HOME/.config/garmin-extractor $HOME/.config/garminplugin
			rm -Rf  $HOME/GFrun $HOME/.local/GFrun
			echo " Backup Activities DONE : $HOME/GFrun_Activities_Backup.zip "
			read -p 'Press [Enter] key to continue...' null
		else
			M_GFrunMenu
	fi
}

F_garminplugin_UBU(){
	echo `color 32 ">>> F_garminplugin_UBU"`
	if ! grep -q "deb http://ppa.launchpad.net/andreas-diesner/garminplugin/ubuntu $(lsb_release -cs) main" < /etc/apt/sources.list
	 then
		sudo apt-add-repository -y ppa:andreas-diesner/garminplugin
		sudo apt-get update
		sudo apt-get install -y garminplugin
	else
		sudo apt-get update
		sudo apt-get install -y garminplugin
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
	echo `color 32 ">>> SUDO_USER"`
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
		echo 'Please : tape your password administrator (SUDO)'
		echo ""
		#read -p "Press [Enter] key to continue..." null
		#xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e "sudo "$0"" &
	fi
}

F_clean_up(){
	echo `color 32 ">>> F_clean_up"`
	rm -f $HOME/GFrun.sh* $HOME/master.zip* $HOME/GFrun/tools/FIT-to-TCX/master.zip* $HOME/GFrun/tools/master.zip* $HOME/GFrun/tools/pygupload_20120516.zip* /tmp/ligneCmd.sh*
}

F_Apt(){
	F_Path
	echo `color 32 ">>> F_Apt"`
	echo $(date +%Y-%m-%d_%H%M)"= BEFORE ==========================" >> $HOME/GFrun_Install.log

	Vlisterror=()
	VlistApt="lsb-release xterm git python python-pip libusb-1.0-0 python-lxml python-pkg-resources python-poster python-serial garminplugin"
	
	for i in ${VlistApt} 
		do
			if [ ! "$(dpkg -l | grep $i)" ]; then
				Vlisterror=(${Vlisterror[@]} $i)
				echo `color 31 "NOK = "`$i 
			else
				echo `color 32 "OK = "`$i 
			fi
		done
	
	#Stop si
	if [ "$(echo "${Vlisterror[@]}")" ]; then
		VlisterrorForm="${Vlisterror[@]}"
		echo "DEPENDANCES/APPS NOT FOUND : ${VlisterrorForm}" 2>/dev/null
		read -p "Press [Enter] key to continue..." null
		sudo apt-get update

		if [ "$(lsb_release -is)" = "Ubuntu" ]; then
			F_garminplugin_UBU
		fi
		
		if [ "$(lsb_release -is)" = "Debian" ]; then
			F_garminplugin_DEB
		fi

		dpkg -l >> $HOME/GFrun_Install.log
		sudo apt-get install -y $VlisterrorForm
		pip install pyusb

	else
		echo "OK = ALL DEPENDANCES" 2>/dev/null
	fi
	echo $(date +%Y-%m-%d_%H%M)"= AFTER ==========================" >> $HOME/GFrun_Install.log
	dpkg -l >> $HOME/GFrun_Install.log	

}

F_Git(){
	echo `color 32 ">>> F_Git"`
	if [ -f $HOME/GFrunLocal/GFrun/GFrun/GFrun.sh ]; then
		mkdir $HOME/GFrun
		cp -rf $HOME/GFrunLocal/GFrun/* $HOME/GFrun
	else
		cd $HOME && git clone -b $Vbranche https://github.com/xonel/GFrun.git
	fi
	mv $HOME/GFrun/GFrun/* $HOME/GFrun && rm -r $HOME/GFrun/GFrun/
	cp -rf $HOME/GFrun/_.config/* $HOME/.config/ && rm -r $HOME/GFrun/_.config
	cp -rf $HOME/GFrun/_.local/* $HOME/.local/ && rm -r $HOME/GFrun/_.local
	#TODO : ln -s $HOME/.local/GFrun/GFrun /usr/bin/GFrun
}

F_Install(){
	echo `color 32 ">>> F_Install"`

	sudo cp -f $HOME/GFrun/tools/extractor/resources/ant-usbstick2.rules /etc/udev/rules.d/
	udevadm control --reload-rules
	
	mkdir -p $HOME/.config/garmin-extractor/scripts
	cp -f $HOME/GFrun/tools/extractor/scripts/* $HOME/.config/garmin-extractor/scripts/
	cp -f $HOME/.local/share/icons/GFrun.svg /usr/share/icons/
	mv $HOME/GFrun_Install.log $HOME/GFrun/logs/GFrun_Install.log
	
	if [ -f $HOME/GFrunUpdate.zip ]; then
		mv -f $HOME/GFrunUpdate.zip $HOME/GFrun/tools/
	fi
}

F_Restore(){
	echo `color 32 ">>> F_Restore"`
	if [ -f $HOME/GFrun_Activities_Backup.zip ] ; then
		echo "#TODO : unzip -o $HOME/GFrun_Activities_Backup.zip -d $HOME/ seulement les Activitées"
	else
		echo "= NO (GFrun_Activities_Backup.zip) AVAILABLE ="
	fi
}

F_Update(){
	echo `color 32 ">>> F_Update"`
	if [ -f $HOME/GFrunUpdate.zip ] ; then
		unzip -o $HOME/GFrunUpdate.zip -d $HOME/
	else
			if [ -f $HOME/GFrun/tools/GFrunUpdate.zip ] ; then
				unzip -o $HOME/GFrun/tools/GFrunUpdate.zip -d $HOME/
			else
				echo "= NO UPDATE AVAILABLE ="
			fi
	fi
}

F_config_Gconnect(){
	F_Path
	echo `color 32 ">>> F_config_Gconnect"`

	#$NUMERO_DE_MA_MONTRE
	NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v scripts)
	#TODO : Test if NUMERO_DE_MA_MONTRE est Valide

	if [ -n "$NUMERO_DE_MA_MONTRE" ]; then
		echo $NUMERO_DE_MA_MONTRE >> $Vpath/logs/IDs
		
		if [ -d $HOME/.config/garmin-extractor ]; then
			mkdir -p $HOME/GFrun/forerunners/dump_gconnect
			ln -sf $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities -T $HOME/.config/garminplugin/Garmin/Activities
			ln -sf $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities -T $HOME/GFrun/forerunners/$NUMERO_DE_MA_MONTRE/activities

			#Garminplugin GarminDevice.xml
			src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
			#02_convert_to_tcx.py
			src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HOME/GFrun/tools/FIT-to-TCX/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/scripts/02_convert_to_tcx.py" >> /tmp/ligneCmd.sh
			src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/garminplugin.xml" >> /tmp/ligneCmd.sh
			
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
			M_GFrunMenu			
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
			M_GFrunMenu
		fi
	fi

	#ligneCmd.sh
	chmod u+x /tmp/ligneCmd.sh && /bin/bash /tmp/ligneCmd.sh
}

F_config_gupload(){
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
	
	#TODO : Encrypt Login / Password
	if [ ! -f $HOME/.local/share/GFrun/.guploadrc ]; then
			read -p 'USERNAME : on connect.garmin.com >> ' Read_user
			read -p 'PASSWORD : on connect.garmin.com >> ' Read_password

			echo "[Credentials]" >> $HOME/.local/share/GFrun/.guploadrc
			echo "enabled = True" >> $HOME/.local/share/GFrun/.guploadrc
			echo "username="$Read_user"" >> $HOME/.local/share/GFrun/.guploadrc
			echo "password="$Read_password"" >> $HOME/.local/share/GFrun/.guploadrc
			ln -s $HOME/.local/share/GFrun/.guploadrc $HOME/.guploadrc
		else
			echo  "CHECK >> $HOME/.local/share/GFrun/.guploadrc"
			echo ""
			echo `color 31 "============================================="`
			echo "Configuration file already exist"
			echo `color 31 "============================================="`

			read -p 'Do you want create new one (N/y) ?' Vo
			case "$Vo" in
				 y|Y)	rm -f $HOME/.local/share/GFrun/.guploadrc
						F_config_gupload;;
				 n|N) echo "OK";;
				 *) echo "not an answer";;
			esac
	fi 
}

F_chownchmod(){
	echo `color 32 ">>> F_chownchmod"`
	#Chown Chmod
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garminplugin $HOME/.config/garmin-extractor $HOME/GFrun $HOME/.local/share/
	chmod -R a+x $HOME/.config/garmin-extractor/scripts/ $HOME/GFrun/tools/ 
}

F_Diag(){
	F_Path
	echo " DIAG FONCTION"
	echo '==================================================================='
	echo 'rm -f $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/authfile'
	echo '==================================================================='
	
	NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v scripts | grep -v dump_gconnect)
	rm -f $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/authfile
	echo "GFrun - $Vbranche - $Version " > $Vpath/logs/DIAG
	uname -a >> $Vpath/logs/DIAG
	lsb_release -a >> $Vpath/logs/DIAG
	
	echo '1 ==================================================================='>> $Vpath/logs/DIAG
	echo $(date +%Y-%m-%d_%H%M) >> $Vpath/logs/DIAG
	echo '2 ==================================================================='>> $Vpath/logs/DIAG
	usb-devices | grep Vendor=0fcf >> $Vpath/logs/DIAG
	echo '3 ==================================================================='>> $Vpath/logs/DIAG
	cat $HOME/GFrun/logs/IDs >> $Vpath/logs/DIAG
	echo '4 ==================================================================='>> $Vpath/logs/DIAG
	cat /etc/udev/rules.d/ant-usbstick2.rules >> $Vpath/logs/DIAG
	echo '5 ==================================================================='>> $Vpath/logs/DIAG
	ls /etc/udev/rules.d/ >> $Vpath/logs/DIAG
	echo '6 ==================================================================='>> $Vpath/logs/DIAG
	ls -l /dev/ttyUSB* >> $Vpath/logs/DIAG
	echo '7 ==================================================================='>> $Vpath/logs/DIAG
	lsmod >> $Vpath/logs/DIAG
	echo '8 ==================================================================='>> $Vpath/logs/DIAG
	dpkg -l | grep libusb >> $Vpath/logs/DIAG
	echo '9 ==================================================================='>> $Vpath/logs/DIAG
	python --version >> $Vpath/logs/DIAG # TODO : Fixer ce BUG pas de print de la version
	echo '10 ==================================================================='>> $Vpath/logs/DIAG
	ls -al /usr/lib/mozilla/plugins/ >> $Vpath/logs/DIAG
	echo '11 ==================================================================='>> $Vpath/logs/DIAG
	ls -al $HOME/.mozilla/plugins/ >> $Vpath/logs/DIAG
	
	read -p 'Press [Enter] key to continue...' null
}

F_Upload_Gconnect_Go()
{
	echo `color 31 "============================================="`
	echo " LOCAL > ...> Upload Activities on going >... > GARMIN.COM" 
	echo `color 31 "============================================="`	
	echo " Script >>> python $HOME/GFrun/tools/pygupload/gupload.py -v 1 $Vactivities"
	cd $HOME/.config/garmin-extractor/Garmin/Activities && python $HOME/GFrun/tools/pygupload/gupload.py -v 1 $Vactivities
}

F_Upload_Gconnect(){
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

M_Main(){
	echo `color 32 ">>> M_Main"`
	case $VMain
		in
           -s) # 1. STABLE.........................(GFrun.sh -s .)
		       #########################################################
				Vbranche="V05"
				F_Sudo
				F_clean_up
				F_Apt
				F_Git
				F_Install
				F_Update
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
				F_clean_up
				F_Apt
				F_Git
				F_Install
				F_Update
				F_Restore
				F_config_Gconnect
				F_config_gupload
				F_chownchmod
#				F_extractor
				F_clean_up
            ;;
          -up) # 3. UPDATE.........................(GFrun.sh -up)
		       #########################################################
				F_Sudo
				F_clean_up
				F_Uninstall
				F_Update
				F_Restore
				F_config_Gconnect
				F_chownchmod
				F_extractor
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
	read -p 'Do you want run GFrunMenu (n/Y) ?' Vo
		case "$Vo" in
			n|N)	G_Bye
					sleep 2
					exit;;
	
			y|Y|*)	M_GFrunMenu;;
		esac
else
	VMain=$1
	M_Main
fi
