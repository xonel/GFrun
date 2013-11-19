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

btn_exit(){ # Envoie le pid du terminal et quitte glade2script
        echo "TERM@@WRITE@@Le pid: $terminal_PID"
        sleep 1
        echo "EXIT@@"
}

#btn_kill()#
# WIDGET => btn_kill
# SIGNAL => clicked
# CALLBACK => kill_term_child

# Permet de killer les processus enfants.
#}

loop(){ # Envoie de commande dans le terminal
        echo "SET@terminal.set_scrollback_lines(20)"
        #echo 'SET@terminal.get_child_exit_status()'
        echo 'TERM@@SEND@@for ((i=0;i<10;i++));do echo $i && sleep 2;done; touch /tmp/glade\n'
        while [[ ! -e /tmp/glade ]]; do sleep 1; done
        rm /tmp/glade
        echo "TERM@@WRITE@@oki
        GET@terminal_PID"
}

btn_ok(){ # Exemples d'utilisations
		echo 'TERM@@SEND@@bash ../../GFrun.sh\n'
}


## Début du script

# Lance la fonction en arrière plan
#loop &

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
