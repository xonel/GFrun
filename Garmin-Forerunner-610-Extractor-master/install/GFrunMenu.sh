#!/bin/bash
#
# Configuration file for GARMIN FORERUNNER - GFrun
# Modif by Le.NoX
#
############################
#     Auteurs : Le.NoX ;o) 
#      Version="0.2"
#     Licence: GNU
############################
#
########################################################################
# wget https://github.com/xonel/GFrun/raw/master//Garmin-Forerunner-610-Extractor-master/install/GFrunMenu.sh
# chmod a+x GFrunMenu.sh
# sudo sh ./GFrunMenu.sh
#
# OneCopyColle : 
# wget https://github.com/xonel/GFrun/raw/master//Garmin-Forerunner-610-Extractor-master/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
########################################################################
#
VChemin="https://github.com/xonel/GFrun/raw/master//Garmin-Forerunner-610-Extractor-master/install/"
Vscript=" "
VWget=" "

color()
{
printf '\033[%sm%s\033[m\n' "$@"
}

GoScript()
{
VWget=$VChemin""$Vscript
echo `color 32 "================================================================================================"`
echo "Wget:" $VWget
echo `color 32 "================================================================================================"`
wget $VWget && sleep 5 && chmod +x ./$Vscript && /bin/sh ./$Vscript
}
########################################################################################################################
#                                                  Le Menu du NoX
########################################################################################################################
 clear
	echo `color 32 "========================================================================================"`
	echo `color 32 " ========================================================================================="`
	echo "   888888ba                         8888ba.88ba "                            
	echo "   88    .8b                        88  .8b  .8b "                            
	echo "   88     88 .d8888b. dP.  .dP      88   88   88 .d8888b. 88d888b. dP    dP " 
	echo "   88     88 88'  .88  .8bd8'       88   88   88 88ooood8 88'  .88 88    88 " 
	echo "   88     88 88.  .88  .d88b.       88   88   88 88.  ... 88    88 88.  .88 " 
	echo "   dP     dP .88888P' dP'  .dP  dP  dP   dP   dP .88888P' dP    dP .88888P. " 
	echo `color 32 " ========================================================================================="`
 	echo `color 31 " Garmin Forerunner (GFrun / Garmin-Forerunner-610-Extractor / garminplugin / gcpuploader)"`
	echo `color 32 " ========================================================================================="`
	echo ""
#        echo "============================"
        echo "**** INSTALLATION :"
        echo `color 32 "1. Full Install DEV - (GFrunOnline)"`
        echo `color 33 "2. Full Install STABLE - (GFrunOffline)"`
        echo ""
        echo "**** CONFIGURATION :"
        echo `color 34 "3. Config Auto-Upload - (gcpuploader)"`
        echo `color 35 "4. Config Garminplugin -(connect.garmin.com)"`
        echo ""
        echo "**** APPLICATION :"
        echo `color 36 "5. Telecharger Activites - (Montre > Local)"`
        echo `color 37 "6. Uploader Activites - (Local > connect.garmin.com)"`
#        echo `color 32 "7. "`
#        echo `color 32 "8. "`
#        echo `color 32 "9. "`
#        echo `color 32 "============================"`
#        echo `color 32 "a. "`
#        echo `color 32 "b. "`
#        echo `color 32 "c. "`
#        echo `color 32 "d. "`
#        echo `color 32 "e. "`
#        echo `color 32 "f. "`
#        echo `color 32 "g. "`
        echo
        echo -n "Faite votre choix : "

        read Vchoix

        case $Vchoix
        in
          1) # Lancer le Script pour : 
		####################################################################
		VChemin="$VChemin"
		Vscript="GFrunOnline.sh"

		GoScript
		####################################################################
            ;;

          *2*) # Lancer le Script pour : 
		####################################################################
		VChemin="$VChemin"
		Vscript="GFrunOffline.sh"

		GoScript
		####################################################################
            ;;

          *3*) # Lancer le Script pour :     
		####################################################################
		VChemin="$VChemin"
		Vscript="Conf_gcpuploader.sh"

		GoScript
		####################################################################
            ;;

          *4*) # Lancer le Script pour : 
		####################################################################
		VChemin=$VChemin
		Vscript="Conf_Garminplugin.sh"
		
		GoScript
		####################################################################  			
            ;;

          *5*) # Lancer le Script pour : 
		####################################################################
		VChemin=$VChemin
		Vscript="Go_GF610E.sh"
		
		GoScript
		####################################################################           
            ;;

          *6*) # Lancer le Script pour : 
		####################################################################
		VChemin=$VChemin
		Vscript="Go_gcpuploader.sh"
		
		GoScript
		#################################################################### 
            ;;

          *7*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 
            ;;

          *8*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 
            ;;

          *9*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 
            ;;

          [aA]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 
            ;;

          [bB]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 
            ;;
            
          [cC]) # Lancer le Script pour : 
		####################################################################
		#wget http://ordiboy.free.fr/open/Linux/Setup_Gwol.sh
		#chmod +x ./Setup_Gwol.sh
		#./Setup_Gwol.sh
		####################################################################
            ;;
            
          [dD]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 
            ;;
            
          [eE]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 
            ;;
                      
          [fF]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 
            ;;
            
          [gG]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#GoScript
		#################################################################### 

             ;;
          [xX]) # exit

            ;;

          *) # anything else

            echo
            echo "\"$Vchoix\" n'est pas une entrée Valide."
            sleep 3

            ;;

        esac
