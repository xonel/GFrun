#! /bin/bash
#
# GFrun
#
#  Auteurs : Le.NoX ;o)
#  M@il : le.nox @ free.fr
Version="0.4.3"
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
VChemin="https://github.com/xonel/GFrun/raw/"$Vbranche"/GFrun/install/"
Vscript=""
Varg=""
VWget=""

color()
{
printf '\033[%sm%s\033[m\n' "$@"
}

F_MenRun(){
echo ""
echo "                        "$Vscript $Varg
echo '              \\\\'
echo '              \c .('
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

GoScript()
{
	VWget=$VChemin""$Vscript
	F_MenRun
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
        echo `color 32 "1. STABLE.........................(GFrun.sh -s .)"`
        echo `color 32 "2. DEV ...........................(GFrun.sh -d .)"`
        echo `color 32 "3. UPDATE.........................(GFrun.sh -up )"`
        echo `color 32 "U. UNINSTALL......................(GFrun.sh -un )"`
        echo ""
        echo "CONFIG :"
        echo "--------"
        echo `color 36 "4. Conf-Pairing...................(GFrun.sh -cp )"`
        echo `color 36 "5. Conf-Garmin.com................(GFrun.sh -cg )"`
        echo `color 36 "D. Conf-Diag .....................(GFrun.sh -cd )"`
        echo ""
        echo "ACTIVITIES :"
        echo "-----------"
        echo `color 33 "6. Extract.Fit >> Local...........(GFrun.sh -el )"`
        echo `color 33 "7. Garmin.com .>> Local ..........(GFrun.sh -gl )"`
        echo `color 33 "8. Local.Fit ..>> Garmin.com .....(GFrun.sh -lg )"`
        echo `color 33 "9. Extract.Fit >> Garmin.com......(GFrun.sh -eg )"`
        echo ""
        echo `color 31 "X. Exit ..........................(GFrun Bye :0 )"`
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
		Varg="-up"
		GoScript
		#############################
		
            ;;
          *4*)     
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-cp"
		GoScript
		############################# 
            ;;

          *5*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-cg"
		GoScript
		#############################
            ;;

          *6*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-el"
		GoScript
		#############################           
            ;;

          *7*) 
		#############################
		VChemin=$VChemin
		Vscript="GFrun.sh"
		Varg="-gl"
		GoScript
		#############################
            ;;

          *8*) 
		#############################
		VChemin=$VChemin
		Vscript="GFrun.sh"
		Varg="-lg"
		GoScript
		#############################
            ;;

          *9*) 
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-eg"
		GoScript
		#############################  
            ;;

          [uU])  
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-un"
		GoScript
		#############################  
            ;;

          [dD])
		#############################
		VChemin="$VChemin"
		Vscript="GFrun.sh"
		Varg="-cd"
		GoScript
		#############################  

            ;;

          [xX]) # exit
				echo ""
				echo "                                 !!!            o           _   _     "
				echo "    -*~*-          ###           _ _           /_\          \\-//     "
				echo "    (o o)         (o o)      -  (OXO)  -    - (o o) -       (o o)     "
				echo "ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-ooO--(_)--Ooo-"
				echo ""
				echo ".........................        Bye       ..........................."
				sleep 3
            ;;

          *) # anything else
		#################################################################### 
            echo
            echo "\"$Vchoix\" NO VALID ENTRY - GFrunMenu.sh"

			if [ -f $HOME/GFrunMenu.sh ]; then
				sleep 3
				sh $HOME/GFrunMenu.sh
			fi
		#################################################################### 
            ;;
        esac
