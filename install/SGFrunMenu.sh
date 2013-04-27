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
# wget https://github.com/xonel/GFrun/raw/master/install/SGFrunMenu.sh
# chmod a+x SGFrunMenu.sh
# sudo sh ./SGFrunMenu.sh
#
# OneCopyColle : 
# wget https://github.com/xonel/GFrun/raw/master/install/SGFrunMenu.sh && chmod a+x SGFrunMenu.sh && sudo sh ./SGFrunMenu.sh
########################################################################
#
VChemin="https://github.com/xonel/GFrun/raw/master/install/"
Vscript=" "
VWget=" "
color()
{
printf '\033[%sm%s\033[m\n' "$@"
}

installscript()
{
VWget=$VChemin""$Vscript
echo `color 32 "============================"`
echo "voici les variables pour Wget:" $VWget
echo `color 32 "============================"`
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
        echo `color 32 "1. Full Install - GFrun"`
        echo `color 33 "2. Config Garminplugin - www.connect.garmin.com"`
        echo `color 34 "3. Config Auto-Upload - gcpuploader"`
#        echo `color 33 "4. "`
#        echo `color 34 "5. "`
#        echo `color 32 "6. "`
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

        read VARIABLE

        case $Vchoix
        in

          1) # Lancer le Script pour : 
		####################################################################
		VChemin="$VChemin"
		Vscript="SGFrun.sh"

		installscript
		####################################################################
            ;;

          *2*) # Lancer le Script pour : 
		####################################################################
		VChemin="$VChemin"
		Vscript="Conf_Garminplugin.sh"

		installscript
		####################################################################
            ;;

          *3*) # Lancer le Script pour :   Setup_FreeNx_0.1.sh     
		####################################################################
		VChemin="$VChemin"
		Vscript="Conf_gcpuploader.sh"

		installscript
		####################################################################
            ;;

          *4*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		####################################################################  			
            ;;

          *5*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		####################################################################           
            ;;

          *6*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		#################################################################### 
            ;;

          *7*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		#################################################################### 
            ;;

          *8*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		#################################################################### 
            ;;

          *9*) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		#################################################################### 
            ;;

          [aA]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		#################################################################### 
            ;;

          [bB]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
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
		#installscript
		#################################################################### 
            ;;
            
          [eE]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		#################################################################### 
            ;;
                      
          [fF]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
		#################################################################### 
            ;;
            
          [gG]) # Lancer le Script pour : 
		####################################################################
		#VChemin=$VChemin
		#Vscript="Setup_GDivFix.sh"
		#
		#installscript
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
