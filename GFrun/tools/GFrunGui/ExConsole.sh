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

#btn_kill(){
# WIDGET => btn_kill
# SIGNAL => clicked
# CALLBACK => kill_term_child	
#	}


# Permet de killer les processus enfants.
#}

btn_gfrunmenu(){ # GFrun Menu
		echo 'SET@_label1.set_text("0. MENU..........................(GFrun.sh -menu .)")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -menu\n'
}

## Install
btn_button1(){ # stable
		echo 'SET@_label1.set_text("1. STABLE.........................(GFrun.sh -s .)")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -s\n'
}

btn_button2(){ # unstable
		echo 'SET@_label1.set_text("2. UNSTABLE ......................(GFrun.sh -d .)")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -d\n'
}

btn_button3(){ # update
		echo 'SET@_label1.set_text("3. UPDATE.........................(GFrun.sh -up )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -up\n'
}

btn_button4(){ # uninstall
		echo 'SET@_label1.set_text("U. UNINSTALL......................(GFrun.sh -un )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -un\n'
}

## Config
btn_pairing(){ # pairing
		echo 'SET@_label1.set_text("4. Conf-Pairing...................(GFrun.sh -cp )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -cp\n'
}

btn_gconnect(){ # garmin.com
		echo 'SET@_label1.set_text("5. Conf-Garmin.com................(GFrun.sh -cg )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -cg\n'
}

btn_reparediag(){ #  Repare / Diag.
		echo 'SET@_label1.set_text("D. Conf-Diag .....................(GFrun.sh -cd )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -cd\n'
}

## Activities
btn_button8(){ # Extract.Fit >> Local
		echo 'SET@_label1.set_text("6. Extract.Fit >> Local...........(GFrun.sh -el )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -el\n'
}

btn_button9(){ # Garmin.com .>> Local
		echo 'SET@_label1.set_text("7. Garmin.com .>> Local ..........(GFrun.sh -gl )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -gl\n'
}

btn_button10(){ # Extract.Fit >> Garmin.com
		echo 'SET@_label1.set_text("9. Extract.Fit >> Garmin.com......(GFrun.sh -eg )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -eg\n'
}

btn_button11(){ # Local.Fit ..>> Garmin.com
		echo 'SET@_label1.set_text("8. Local.Fit ..>> Garmin.com .....(GFrun.sh -lg )")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -lg\n'
}

btn_backup(){ # GFrun Menu
		echo 'SET@_label1.set_text("STABLE")'
		echo 'TERM@@SEND@@'$Vroot'bash ../../GFrun.sh -bk\n'
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
