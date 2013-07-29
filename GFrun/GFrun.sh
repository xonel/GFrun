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
#(STABLE) : wget -N https://github.com/xonel/GFrun/raw/master/GFrun/GFrun.sh && chmod a+x GFrun.sh && sudo sh ./GFrun.sh
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
echo '  jgs             --'
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
echo ""                              $Version
echo ""
echo ".........................PROCEDURE TERMINEE..........................."
}

F_Xterm_Geometry(){
	echo `color 32 ">>> F_Xterm_Geometry"`
	echo "$Vscript $Voption"
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e "/bin/sh ./$Vscript $Voption"
}

F_Script(){
	echo `color 32 ">>> F_Script"`

	G_MenRun
	VChemin="https://github.com/xonel/GFrun/raw/"$Vbranche"/GFrun/"	
	VWget=$VChemin""$Vscript
	echo `color 32 "===================================================="`
	echo "Wget:" $VWget
	echo "$Vscript $Voption"
	echo `color 32 "===================================================="`
	echo ""
	echo ""
if [ -f $HOME/$Vscript ]; then
	cd $HOME/ && chmod +x ./$Vscript && F_Xterm_Geometry
else
	if [ -f $HOME/GFrun/$Vscript ]; then
		cd $HOME/GFrun/ && chmod +x ./$Vscript && F_Xterm_Geometry
	else
		cd $HOME/ && wget -N $VWget && sleep 2 && chmod +x ./$Vscript && F_Xterm_Geometry
	fi
fi
}

F_Chk_SUDO(){
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
		
		xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e 'sudo /bin/sh $HOME/GFrun.sh -menu'
		exit
	fi
}

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
			rm -f  $HOME/.guploadrc $HOME/.local/share/icons/GFrun.svg $HOME/.local/share/applications/GFrun.desktop /usr/share/icons/GFrun.svg
			rm -Rf  $HOME/GFrun $HOME/.config/garmin-extractor $HOME/.config/garminplugin
			echo " Backup Activities DONE : $HOME/GFrun_Activities_Backup.zip "
			sleep 3
		else
			M_GFrunMenu
	fi
}

F_clear(){
	echo `color 32 ">>> F_clear"`
	rm -f $HOME/GFrun.sh* $HOME/master.zip* $HOME/GFrun/tools/FIT-to-TCX/master.zip* $HOME/GFrun/tools/master.zip* $HOME/GFrun/tools/pygupload_20120516.zip* /tmp/ligneCmd.sh*
}

F_mkdir(){
	echo `color 32 ">>> F_mkdir"`
	mkdir -p $HOME/.config/garmin-extractor/scripts/
	mkdir -p $HOME/.config/garminplugin
}

F_garminplugin_UBU(){
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

F_apt(){
	echo `color 32 ">>> F_apt"`
	echo $(date +%Y-%m-%d_%H%M)"= BEFORE ==========================" >> $HOME/GFrun_Install.log
	dpkg -l >> $HOME/GFrun_Install.log
	
	sudo apt-get update
	sudo apt-get install -y git lsb-release python python-pip libusb-1.0-0 python-lxml python-pkg-resources python-poster python-serial
	pip install pyusb

		if [ "$(lsb_release -is)" = "ubuntu" ]; then
			F_garminplugin_UBU
		fi
		
		if [ "$(lsb_release -is)" = "debian" ]; then
			F_garminplugin_DEB
		fi
	echo $(date +%Y-%m-%d_%H%M)"= AFTER ==========================" >> $HOME/GFrun_Install.log
	dpkg -l >> $HOME/GFrun_Install.log
}

F_git(){
	echo `color 32 ">>> F_git"`
	cd $HOME && git clone -b $Vbranche https://github.com/xonel/GFrun.git
	mv $HOME/GFrun/GFrun/* $HOME/GFrun && rm -r $HOME/GFrun/GFrun/
	cp -rf $HOME/GFrun/_.config/* $HOME/.config/ && rm -r $HOME/GFrun/_.config
	cp -rf $HOME/GFrun/_.local/* $HOME/.local/ && rm -r $HOME/GFrun/_.local
}

F_wget(){
	echo `color 32 ">>> F_wget"`
	cd $HOME && wget -N https://github.com/Tigge/Garmin-Forerunner-610-Extractor/archive/drivers.zip && mv drivers.zip master.zip
	cd $HOME/GFrun/tools/ && wget -N https://github.com/Tigge/FIT-to-TCX_master/archive/master.zip
	cd $HOME/GFrun/tools/FIT-to-TCX/ && wget -N https://github.com/dtcooper/python-fitparse/archive/master.zip
	cd $HOME/GFrun/tools/ && wget -N http://freefr.dl.sourceforge.net/project/gcpuploader/pygupload_20120516.zip
	cd $HOME && wget https://github.com/xonel/GFrun/raw/$Vbranche/GFrunUpdate.zip
}

F_unzip(){
	echo `color 32 ">>> F_unzip"`
	#Garmin-Forerunner-610-Extractor-master
	cd $HOME && unzip -o master.zip -d GFrun
	#FIT-to-TCX
	cd $HOME/GFrun/tools/ && unzip -o master.zip
	#python-fitparse-master
	cd $HOME/GFrun/tools/FIT-to-TCX/ && unzip -o master.zip
	#gupload
	cd $HOME/GFrun/tools/ && unzip -o pygupload_20120516.zip
	#script install
	cd $HOME && unzip -oC GFrunUpdate.zip "GFrun/install/*" "GFrun/tools/dump_gconnect.py" ".config/*" ".local/*" -d $HOME/
}

F_install(){
	echo `color 32 ">>> F_install"`

	cp -f $HOME/GFrun/tools/ant-usbstick2.rules /etc/udev/rules.d/
	udevadm control --reload-rules

	cp -f $HOME/GFrun/scripts/* $HOME/.config/garmin-extractor/scripts/
	cp -Rf $HOME/GFrun/tools/FIT-to-TCX/python-fitparse-master/fitparse $HOME/GFrun/tools/FIT-to-TCX/
	mv -f $HOME/GFrunUpdate.zip $HOME/GFrun/tools/
}

F_cpmv(){
	echo `color 32 ">>> F_cpmv"`

	cp -f $HOME/GFrun/tools/ant-usbstick2.rules /etc/udev/rules.d/
	udevadm control --reload-rules

	#Garmin-Forerunner-610-Extractor-master
	cp -Rf $HOME/GFrun/Garmin-Forerunner-610-Extractor-master/* $HOME/GFrun
	##Convert fit to tcx & auto-Upload ConnectGarmin
	cp -f $HOME/GFrun/scripts/40-convert_to_tcx.py $HOME/.config/garmin-extractor/scripts/
	cp -f $HOME/GFrun/scripts/01-upload-garmin-connect.py $HOME/.config/garmin-extractor/scripts/
	cp -Rf $HOME/GFrun/tools/FIT-to-TCX/python-fitparse-master/fitparse $HOME/GFrun/tools/FIT-to-TCX/
	mv -f $HOME/GFrunUpdate.zip $HOME/GFrun/tools/
	#Icons
	cp -f $HOME/.local/share/icons/GFrun.svg /usr/share/icons/
	#getkey.py
	cp -f $HOME/GFrun/tools/getkey.py $HOME/GFrun/
}

F_extractfit(){
	echo `color 32 ">>> F_extractfit"`
	#Extractor FIT
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e 'cd $HOME/GFrun/tools/extractor/ && python ./garmin.py'
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor
}

F_getkey(){
	echo `color 32 ">>> F_getkey"`
	#Pairing Key
	xterm -font -*-fixed-medium-r-*-*-18-*-*-*-*-*-iso8859-* -geometry 75x35 -e 'cd $HOME/GFrun/tools/ && python ./extractor_getkey.py'
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garmin-extractor
}

F_configfiles(){
	echo `color 32 ">>> F_configfiles"`

	#$NUMERO_DE_MA_MONTRE
	NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts)

	#GarminDevice.xml
	if [ -n "$NUMERO_DE_MA_MONTRE" ]; then
		echo $NUMERO_DE_MA_MONTRE >> $HOME/GFrun/tools/IDs
		cd $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/
		ln -sf $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities -T $HOME/.config/garminplugin/Garmin/Activities
		mkdir -p $HOME/GFrun/forerunners/$NUMERO_DE_MA_MONTRE/dump_gconnect
		ln -sf $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/activities -T $HOME/GFrun/forerunners/$NUMERO_DE_MA_MONTRE/activities
		src=ID_MA_MONTRE && cibl=$NUMERO_DE_MA_MONTRE && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/Garmin/GarminDevice.xml" >> /tmp/ligneCmd.sh
		
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
		fi
	fi

	#40-convert_to_tcx.py
	src=/path/to/FIT-to-TCX/fittotcx.py && cibl=$HOME/GFrun/tools/FIT-to-TCX/fittotcx.py && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garmin-extractor/scripts/40-convert_to_tcx.py" >> /tmp/ligneCmd.sh
	src=MON_HOME && cibl=$HOME && echo "sed -i 's|$src|$cibl|g' $HOME/.config/garminplugin/garminplugin.xml" >> /tmp/ligneCmd.sh

	#ligneCmd.sh
	chmod u+x /tmp/ligneCmd.sh && sh /tmp/ligneCmd.sh
}

F_chownchmod(){
	echo `color 32 ">>> F_chownchmod"`
	#Chown Chmod
	chown -R $SUDO_USER:$SUDO_USER $HOME/.config/garminplugin $HOME/.config/garmin-extractor $HOME/GFrun $HOME/.local/share/
	chmod -R a+x $HOME/.config/garmin-extractor/scripts/ $HOME/GFrun/tools/ 
}

F_GFrun_Update(){
	echo `color 32 ">>> F_GFrun_Update"`
	if [ -f $HOME/GFrunUpdate.zip ] ; then
			unzip -o $HOME/GFrunUpdate.zip -d $HOME/
		else
			if [ -f $HOME/GFrun/tools/GFrunUpdate.zip ] ; then
					unzip -o $HOME/GFrun/tools/GFrunUpdate.zip -d $HOME/
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
			echo "enabled = True" >> $HOME/.guploadrc
			echo "username="$Read_user"" >> $HOME/.guploadrc
			echo "password="$Read_password"" >> $HOME/.guploadrc
		else
			echo  "CHECK >> $HOME/.guploadrc"
			echo ""
			echo `color 31 "============================================="`
						echo "Configuration file already exist"
			echo `color 31 "============================================="`

			read -p 'Do you want create new one (N/y) ?' Vo
			case "$Vo" in
			 y|Y)	rm -f $HOME/.guploadrc
					F_conf_gupload;;
			 n|N) echo "OK";;
			 *) echo "not an answer";;
			esac
	fi
}

F_Dump_Gconnect(){
	echo `color 32 "======================================================================="`
	echo ">>>>>  DUMP ALL ACTIVITIES FROM CONNECT GARMIN <<<<<< " 
	echo `color 32 "======================================================================="`
	echo ""
	echo " (10 ~ 20) mins - PLEASE WAIT ... "
	echo ""
	mkdir $HOME/GFrun/forerunners/dump_gconnect/$(date +%Y-%m-%d_%H%M)
	cd $HOME/GFrun/forerunners/dump_gconnect/$(date +%Y-%m-%d_%H%M) && python $HOME/GFrun/tools/dump_gconnect.py
	chown -R $SUDO_USER:$SUDO_USER $HOME/GFrun/forerunners/dump_gconnect/
}

F_Diag(){
	echo " DIAG FONCTION"
	echo '==================================================================='
	echo 'rm -f $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/authfile'
	echo '==================================================================='
	NUMERO_DE_MA_MONTRE=$(ls $HOME/.config/garmin-extractor/ | grep -v Garmin | grep -v scripts | grep -v dump_gconnect)
	rm -f $HOME/.config/garmin-extractor/$NUMERO_DE_MA_MONTRE/authfile
	
	echo "GFrun - $Vbranche - $Version " > $HOME/GFrun/tools/DIAG
	uname -a >> $HOME/GFrun/tools/DIAG
	lsb_release -a >> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	echo 'usb-devices'>> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	usb-devices | grep Vendor=0fcf >> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	echo 'cat $HOME/GFrun/tools/IDs'>> $HOME/GFrun/tools/DIAG
	cat $HOME/GFrun/tools/IDs >> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	echo 'cat /etc/udev/rules.d/ant-usbstick2.rules'>> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	cat /etc/udev/rules.d/ant-usbstick2.rules >> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	ls /etc/udev/rules.d/ >> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	ls -l /dev/ttyUSB* >> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	lsmod >> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	dpkg -l | grep libusb >> $HOME/GFrun/tools/DIAG
	echo '==================================================================='>> $HOME/GFrun/tools/DIAG
	python --version >> $HOME/GFrun/tools/DIAG
}

F_Upload_Gconnect_Go()
{
	echo `color 31 "============================================="`
	echo " LOCAL > ...> Upload Activities on going >... > GARMIN.COM" 
	echo `color 31 "============================================="`	

	echo " Script >>> python $HOME/GFrun/tools/pygupload/gupload.py -v 1 $Vactivities"
	cd $HOME/.config/garmin-extractor/Garmin/Activities
	python $HOME/GFrun/tools/pygupload/gupload.py -v 1 $Vactivities
}

F_Upload_Gconnect(){
	echo ""
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
          [tT]) # 2013-04-14_10-29-04-80-9375.fit
		################################
		Vactivities=$(date +%Y-%m-%d_*)
			F_Upload_Gconnect_Go
            ;;

          [wW])  # Lancer le Script pour : 
		################################	
		for c in 1 2 3 4 5 6 7
			do 
			Vactivities=$(date "+%Y-%m-%d_*" -d "$c days ago")
			F_Upload_Gconnect_Go
		done
            ;;

          [mM]) # Lancer le Script pour :     
		################################
		Vactivities=$(date +%Y-%m-*)
		F_Upload_Gconnect_Go
            ;;

          [yY]) # Lancer le Script pour : 
		################################
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
		################################################################
				Vbranche="master" 
				F_Chk_SUDO
				F_clear
#				F_mkdir
				F_apt
				F_git
				F_GFrun_Update
#				F_wget
#				F_unzip
#				F_cpmv
				F_configfiles
				F_conf_gupload
				F_chownchmod
#				F_extractfit
				F_clear
            ;;
          -d) #2. DEV ...........................(GFrun.sh -d .)
		################################################################
				Vbranche="GFrun" 
				F_Chk_SUDO
				F_clear
#				F_mkdir
				F_apt
				F_git
				F_GFrun_Update
#				F_wget
#				F_unzip
#				F_cpmv
				F_configfiles
				F_conf_gupload
				F_chownchmod
#				F_extractfit
				F_clear
            ;;
          -up) # 3. UPDATE.........................(GFrun.sh -up)
		################################################################
				F_Chk_SUDO
				F_clear
				F_mkdir
				F_GFrun_Update
#				F_apt
#				F_wget
				F_unzip
				F_cpmv
				F_configfiles
				F_chownchmod
				F_extractfit
				F_clear
             ;;
             
          -cp) # 4. Conf-Pairing...................(GFrun.sh -cp )
		################################################################
				F_getkey
             ;;
             
          -cg) # 5. Conf-Garmin.com................(GFrun.sh -cg )
		################################################################
				F_configfiles
				F_conf_gupload
             ;;
             
          -el) # 6. Extract.Fit >> Local...........(GFrun.sh -el ) 
		################################################################
				F_extractfit
             ;;
             
          -gl) #7. Garmin.com .>> Local ..........(GFrun.sh -gl ) 
		################################################################
				F_Dump_Gconnect
             ;;
             
          -lg) # 8. Local.Fit ..>> Garmin.com .....(GFrun.sh -lg ) 
		################################################################
				F_Upload_Gconnect
             ;;

          -eg) # 9. Extract.Fit >> Garmin.com......(GFrun.sh -eg ) 
		################################################################
				F_extractfit
				Vactivities=$(date +%Y-%m-*)
				F_Upload_Gconnect_Go
             ;;
             
          -cd) #D. Conf-Diag .....................(GFrun.sh -cd ) 
		################################################################
				F_Diag
				F_extractfit
             ;;

          -un) #U. UNINSTALL......................(GFrun.sh -un )
		################################################################
				F_uninstall
				F_clear
             ;;
             
          -menu) #. GFrunMenu .........................(GFrun.sh -menu )
		################################################################
				M_GFrunMenu
             ;;
             
          -gui) #. GFrunGUI .........................(GFrun.sh -gui )
		################################################################
				F_GFrunGui
             ;;

          *) # anything else
		################################################################
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
		Vbranche="master" 
		F_Script
		#############################          
            ;;

          *2*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Voption="-d"
		Vbranche="GFrun" 
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

#if [ -f $HOME/GFrun.sh ]; then
#	sleep 1
#	sh $HOME/GFrun.sh
#else
#	if [ -f $HOME/GFrun/GFrun.sh ]; then
#		sleep 1
#		sh $HOME/GFrun/GFrun.sh
#	fi
#fi
#exit
