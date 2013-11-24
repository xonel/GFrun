#!/bin/bash
PID=$$
FIFO=/tmp/FIFO${PID}
mkfifo $FIFO
#############################################################################################

################################
### À savoir sur le terminal ###
################################

## 1) Glade
# >>> Crée une box (vide, ne pas oublier le _ au début du nom, exemple _hbox1), et ajouter
# un viewport au dessus.
# >>> Utiliser le callback redim_term avec le signal size-allocate sur le viewport. (pour pouvoir redimensionner le terminal)

# WIDGET => viewport1
# SIGNAL => size-allocate
# CALLBACK => redim_term

## 2) Script d'appel (go_*)
# >>> Pour utiliser un terminal, il faut le déclarer au lancement de glade2script (voir le fichier go_ExConsole.sh).
# >>> Le terminal est personnalisable (voir doc).

### ATTENTION ###
# >>> Le paquet python-vte est indispensable pour utiliser un terminal.

#############################################################################################

## Définitions des fonctions

#Vroot="user"

btn_exit(){ # Envoie le pid du terminal et quitte glade2script
        echo "TERM@@WRITE@@ Bye ;O): $terminal_PID"
        echo "EXIT@@"
}

_root(){
		if [[ $1 == True ]]; then
			Vroot="sudo "
		else
			Vroot=""
		fi
		echo "Right :" $Vroot 	
}

#btn_kill()#
# WIDGET => btn_kill
# SIGNAL => clicked
# CALLBACK => kill_term_child

# Permet de killer les processus enfants.
#}

btn_ok(){ # GFrun Menu
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -menu\n'
}

## Install
btn_button1(){ # stable
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -s\n'
}

btn_button2(){ # unstable
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -d\n'
}

btn_button3(){ # upload
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -up\n'
}

btn_button4(){ # uninstall
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -un\n'
}

## Config
btn_button5(){ # pairing
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -cp\n'
}

btn_button6(){ # garmin.com
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -cg\n'
}

btn_button7(){ #  Repare / Diag.
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -cd\n'
}

## Activities
btn_button8(){ # Extract.Fit >> Local
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -el\n'
}

btn_button9(){ # Garmin.com .>> Local
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -gl\n'
}

btn_button10(){ # Extract.Fit >> Garmin.com
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -eg\n'
}

btn_button11(){ # Local.Fit ..>> Garmin.com
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -lg\n'
}

## Début du script

# Récupère le pid du terminal
echo 'GET@terminal_PID'

echo 'SET@window1.show()'
##########################################################################################
while read ligne; do
    if [[ "$ligne" =~ GET@ ]]; then
       eval ${ligne#*@}
       echo "DEBUG => in boucle bash :" ${ligne#*@}
    else
       echo "DEBUG=> in bash NOT GET" $ligne
       $ligne
   fi
done < <(while true; do
    read entree < $FIFO
    [[ "$entree" == "QuitNow" ]] && break
     echo $entree
done)
exit
