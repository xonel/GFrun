    #!/bin/bash
     
    # paramètres
    email='votre@email.com'
    password_file='/chemin/vers/le/fichier/texte/contenant/le/mot/de/passe'
    syncdir='/dossier/à/synchroniser/'
    refreshdelay=5
     
    # contrôle du binaire hubic
    if which hubic >/dev/null; then
        sleep 0.01
    else
        echo "*******************************************"
    	echo " ERREUR: client hubic non trouvé."
    	echo "Veuillez installer hubic."
        echo "   --- script fermé dans 10 secondes ---"
        echo "*******************************************"
    	sleep 10
    	exit
    fi
     
    # valeurs de configuration
    hubic config TimeBetweenSynchronization 999
    hubic config UseRecycleBin False
    hubic config AllowBugReporting False
    hubic config UploadSpeedLimit 0
    hubic config DownloadSpeedLimit 0
     
    # login
    state=$(hubic status | grep "State")
    if [ "$state" != 'State: NotConnected' ]; then
    	hubic logout
    fi
    echo "*login en cours: $email"
    hubic login --password_path="$password_file" $email $syncdir
    state=$(hubic status | grep "State")
    while [ "$state" = 'State: NotConnected' ]; do 
    	sleep 1 
    	state=$(hubic status | grep "State")
    done
    while [ "$state" = 'State: Connecting' ]; do
    	sleep 1
    	state=$(hubic status | grep "State")
    done
     
    echo "*état: connecté"
    echo "------------------------------"
     
    # affichage quota
    quota=$(hubic status | grep "Usage:")
    echo "$quota"
    echo "=============================="
    echo "Vous pouvez à présent travailler votre dossier $syncdir"
    read -p "Appuyez sur Entrée pour lancer la synchronisation du dossier quand c'est prêt."
     
    # lancement sync
    echo "- synchronisation du dossier $syncdir ..."
    hubic synchronize
     
    # détection d'état
    state=$(hubic status | grep "State")
    while [ "$state" != 'State: Idle' ]; do
    	# affichage du processus en cours
    	queue=$(hubic status | grep -A3 "Queue:")
    	msg=$(hubic status | grep -A1 "Running operations")
    	while [ ! -z "$msg" ]; do 
    		queue=$(hubic status | grep -A3 "Queue:")
    		msg=$(hubic status | grep -A1 "Running operations")
    		echo "$queue"
    		echo "$msg"
    		echo "=============================="
    		sleep $refreshdelay
    	done
    	state=$(hubic status | grep "State")
    done
    echo "------------------------------"
    echo "*sync terminé"
     
    # logout
    hubic logout
    echo "*déconnecté; Merci et à bientôt :)"

