GFrun
=====

Garmin Forerunner 310XT - Inside Linux

Nous avons donc tout pour connecter nos montres (ANT-FS  => ex: 310XT) sous LINUX :

- garminplugin_0.3.16-1 :
      + Permet de connecter notre firefox au site http://connect.garmin.com
- Garmin-Forerunner-610-Extractor :
      + Récupère les fichiers via ANT+ de nos montres (ANT-FS)
      + convertit les .FIT en .TCX à l'aide du script (40-convert_to_tcx.py)
- gcpuploader
      + upload automatiquement les "FIT/TCX" sur http://connect.garmin.com


CONFIGURATION DE TEST POUR DEV DU SCRIPT :

+ Garmin Forerunner 310XT (Allumée)
+ Clef Usb ANT (connecté à l'ordinateur) 
+ Ubuntu 13.10 64bit (25/04/2013 UpDate) / Ubuntu 12.04 64bit


INSTALL : (ATTENTION : Script en cours de dev !! Bugs possibles !! ...) :

wget https://github.com/xonel/GFrun/raw/master/install/SetupGFrun.py
chmod a+x SetupGFrun.py
sudo ./SetupGFrun.py

J'ai utilisé le script de "postinstall" de Nicolargo : http://nicolargo.github.io/ubuntupostinstall/
avec les modifications nécessaires pour une installation simplifié de toutes ces briques.

FAIT :
+ installation et pres config de Garmin-Forerunner-610-Extractor : Version MASTER via GIT
+ installation du dépôt pour garminplugin_0.3.16-1 (compatible uniquement quantal)
+ installation de gcpuploader (mais pas encore activé en automatique)
+ installation de python-fitparse :  Version MASTER via GIT
+ installation et configuration du script : 40-convert_to_tcx.py

A FAIRE :
- récupérer le  <Id>3xx89xxxx9</Id> de la montre pour tout configurer automatiquement.
- Modifier  Garmin-Forerunner-610-Extractor ou exploiter son dossier script pour automatiser auto-upload via gcpuploader.
- Créer automatiquement la structure du dossier DEVICES pour garminplugin sans utiliser WINDOWS


Forum : http://forum.ubuntu-fr.org/viewtopic.php?pid=13312901#p13312901
