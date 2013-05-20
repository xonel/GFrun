#!/bin/bash
#
# GFrun
#
#  Auteurs : Le.NoX ;o)
#  M@il : le.nox @ free.fr
Version="0.4.1"
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
#
VChemin="https://github.com/xonel/GFrun/raw/master/GFrun/install/"
Vscript=""
Varg=""
VWget=""

color()
{
printf '\033[%sm%s\033[m\n' "$@"
}

GoScript()
{
	VWget=$VChemin""$Vscript
	echo `color 32 "===================================================="`
	echo "Wget:" $VWget
	echo `color 32 "===================================================="`
	echo ""
	echo ""
	if [ ! -f $HOME/GFrun/install/$Vscript ]; then
			cd $HOME/ && wget -N $VWget && sleep 3 && chmod +x ./$Vscript && /bin/sh ./$Vscript $Varg
		else
			cd $HOME/GFrun/install/ && chmod +x ./$Vscript && /bin/sh ./$Vscript $Varg
	fi
}

####################################################################################
#                                                  Le Menu du NoX
####################################################################################
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

	echo""
#        echo "============================"
        echo "INSTALL :"
        echo "---------"
        echo `color 32 "1. STABLE.........................(GFrun.sh -s)"`
        echo `color 32 "2. DEV ...........................(GFrun.sh -d)"`
        echo `color 32 "3. UPDATE.........................(GFrun.sh -o)"`
        echo ""
        echo "CONFIG :"
        echo "--------"
        echo `color 33 "4. Conf-gupload........................(GFrun.sh -g)"`
        echo `color 33 "5. Conf-Garmin.com.....................(GFrun.sh -c)"`
        echo ""
        echo "ACTIVITIES :"
        echo "-----------"
        echo `color 35 "6. Extract.Fit >> Local...........(GFrun.sh -e)"`
        echo `color 35 "7. Upload.Fit >> garmin.com ......(gupload    )"`
        echo `color 35 "8. garmin.com >> Local ...........(gconnect   )"`
        echo `color 35 "9. Extract>>Local>>garmin.com.....(GFrun.sh -a)"`
        echo ""
        echo `color 32 "U. UNINSTALL......................(GFrun.sh -u)"`
        echo ""
		echo `color 31 "EXIT : Select [x] and [enter]"`
#        echo `color 32 "7. "`
#        echo `color 32 "8. "`
#        echo `color 32 "9. "`
#        echo `color 32 "="`
#        echo `color 32 "a. "`
#        echo `color 32 "b. "`
        echo""
        echo -n "Faite votre choix : "

        read Vchoix

        case $Vchoix
        in
          1) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-s"
		GoScript
		#############################          
            ;;

          *2*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-d"
		GoScript
		#############################
            ;;
            
          *3*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-o"
		GoScript
		#############################
		
            ;;
          *4*)     
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-g"
		GoScript
		############################# 
            ;;

          *5*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-c"
		GoScript
		#############################
            ;;

          *6*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-e"
		GoScript
		#############################           
            ;;

          *7*) 
		#############################
		VChemin=$VChemin
		Vscript="gupload.sh"
		Varg=""
		GoScript
		#############################
            ;;

          *8*) 
		#############################
		VChemin=$VChemin
		Vscript="gconnect.sh"
		Varg=""
		GoScript
		#############################
            ;;
          *9*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-a"
		GoScript
		#############################  
		
            ;;
          [uU])  
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-u"
		GoScript
		#############################  
            ;;

          [aA])
		#############################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		############################# 
            ;;

          [bB]) 
		#############################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		############################# 
            ;;

          [xX]) # exit
				echo ""
				echo "                                 !!!            o           _   _     "
				echo "    -*~*-          ###           _ _           /_\          \\-//     "
				echo "    (o o)         (o o)      -  (OXO)  -    - (o o) -       (o o)     "
				echo "ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-"
				echo ""
				echo ".........................PROCEDURE TERMINEE..........................."
				sleep 3
            ;;

          *) # anything else
		#################################################################### 
            echo
            echo "\"$Vchoix\" NO VALID ENTRY"
			if [ -f $HOME/GFrunMenu.sh ]; then
				sleep 3
				sh $HOME/GFrunMenu.sh
			fi
		#################################################################### 
            ;;
        esac
