
===============================================================================
#GFrun - Garmin Forerunner 310XT ANT- Inside Linux (Ubuntu 12.04 =<OK>= 13.04)
===============================================================================

Nous avons donc tout pour connecter nos montres Garmin Forerunner (ANT-FS  => ex: 310XT) sous LINUX :

- garminplugin_0.3.16-1 :
      + Permet de connecter notre firefox au site http://connect.garmin.com
- Garmin-Forerunner-610-Extractor :
      + Récupère les fichiers via ANT+ de nos montres (ANT-FS)
      + convertit les .FIT en .TCX à l'aide du script (40-convert_to_tcx.py)
- gcpuploader
      + upload automatiquement les "FIT/TCX" sur http://connect.garmin.com


CONFIGURATION :
---------------
Config de test pour le developpement du script "GFrun" :

+ Garmin Forerunner 310XT (Allumée)
+ Clef Usb ANT (connecté à l'ordinateur) 
+ Ubuntu 13.10 64bit (25/04/2013 UpDate) / Ubuntu 12.04 64bit


INSTALL :
---------
(ATTENTION : Script en cours de developpement !! Bugs possibles !! ...) :

+ wget https://github.com/xonel/GFrun/raw/master/install/GFrunMenu.sh
+ chmod a+x GFrunMenu.sh
+ sudo sh ./GFrunMenu.sh

OneCopyColle : 
+ wget https://github.com/xonel/GFrun/raw/master/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh

Voici la nouvelle version de GFrun, au programme :
- Un Menu un peut plus convivial.
- Une Version GFrunOnline (version DEV - derniere version des Master git garminplugin/gcpuploader/etc...)
- Une version GFrunOffline (version STABLE au 23/04/2013).
- Une Mini Toolbox de script pour automatiser les configs (plugin, ID montre,etc).

voici un aperçu :

+ =========================================================================================
+ Garmin Forerunner (GFrun / Garmin-Forerunner-610-Extractor / garminplugin / gcpuploader)
+ =========================================================================================
1. Full Install DEV - GFrunOnline
2. Full Install STABLE - GFrunOffline
3. Config Auto-Upload - gcpuploader
4. Config Garminplugin - www.connect.garmin.com
5. Telecharger Activités en Local
6. Uploader Activites - www.connect.garmin.com

Faite votre choix :

+ ========================================================================================

FAIT :
-----
+ installation et pres config de Garmin-Forerunner-610-Extractor : Version MASTER via GIT
+ installation du dépôt pour garminplugin_0.3.16-1 
+ installation de gcpuploader (mais pas encore activé en automatique)
+ installation de python-fitparse :  Version MASTER via GIT
+ installation et configuration du script : 40-convert_to_tcx.py
+ Créer automatiquement la structure du dossier DEVICES pour garminplugin sans utiliser WINDOWS
+ récupérer le  <Id>3xx89xxxx9</Id> de la montre pour tout configurer automatiquement.
+ Version Offline/Stable sans les masters Git.

A FAIRE :
--------
- Modifier  Garmin-Forerunner-610-Extractor ou exploiter son dossier script pour automatiser auto-upload via gcpuploader.
- faire un .desktop / raccourci Unity / mettre dans le bin/ ou autre chose
- une Gui serait un plus
- Faire une petite Doc/Tuto
- Faire du vrai 'Bash'

Forum : http://forum.ubuntu-fr.org/viewtopic.php?pid=13312901#p13312901
