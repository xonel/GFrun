===============================================================================
#GFrun - Garmin Forerunner 310XT ANT- Inside Linux
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
<pre><code>wget https://github.com/xonel/GFrun/raw/master/Garmin-Forerunner-610-Extractor-master/install/GFrunMenu.sh
chmod a+x GFrunMenu.sh
sudo sh ./GFrunMenu.sh
</code></pre>

OneCopyColle : 
<pre><code>
wget https://github.com/xonel/GFrun/raw/master/Garmin-Forerunner-610-Extractor-master/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
</code></pre>

Voici la nouvelle version de GFrun, au programme :
- Un Menu un peut plus convivial.
- Une Version GFrunOnline (version DEV - derniere version des Master git garminplugin/gcpuploader/etc...)
- Une version GFrunOffline (version STABLE au 23/04/2013).
- Une Mini Toolbox de script pour automatiser les configs (plugin, ID montre,etc).

voici un aperçu :
<pre><code>
 =========================================================================================
   888888ba                         8888ba.88ba 
   88    .8b                        88  .8b  .8b 
   88     88 .d8888b. dP.  .dP      88   88   88 .d8888b. 88d888b. dP    dP 
   88     88 88'  .88  .8bd8'       88   88   88 88ooood8 88'  .88 88    88 
   88     88 88.  .88  .d88b.       88   88   88 88.  ... 88    88 88.  .88 
   dP     dP .88888P' dP'  .dP  dP  dP   dP   dP .88888P' dP    dP .88888P. 
 =========================================================================================
 Garmin Forerunner (GFrun / Garmin-Forerunner-610-Extractor / garminplugin / gcpuploader)
 =========================================================================================
 
INSTALLATION :
1. Full Install DEV - (GFrunOnline)
2. Full Install STABLE - (GFrunOffline)

CONFIGURATION :
3. Config Auto-Upload - (gcpuploader)
4. Config Garminplugin -(connect.garmin.com)

APPLICATION :
5. Telecharger Activites - (Montre > Local)
6. Uploader Activites - (Local > connect.garmin.com)

Faite votre choix : 
</code></pre>

FAIT :
-----
+ installation et pres config de Garmin-Forerunner-610-Extractor : Version MASTER via GIT
+ installation du dépôt pour garminplugin_0.3.16-1 
+ installation de gcpuploader (script config OK / Script upload via GFrunMenu OK)
+ installation de python-fitparse :  Version MASTER via GIT
+ installation et configuration du script : 40-convert_to_tcx.py
+ Créer automatiquement la structure du dossier DEVICES pour garminplugin sans utiliser WINDOWS
+ récupérer le  <Id>ID_MA_MONTRE</Id> de la montre pour tout configurer automatiquement.
+ Version Offline/Stable sans les masters Git.
+ .desktop / raccourci Unity disponible dans le dash "GFrun"

A FAIRE :
--------
- Modifier  Garmin-Forerunner-610-Extractor ou exploiter son dossier script pour automatiser auto-upload via gcpuploader.
- une Gui serait un plus
- Faire une petite Doc/Tuto
- Apprendre à Faire du 'Bash' ;O)

Forum : http://forum.ubuntu-fr.org/viewtopic.php?pid=13312901#p13312901
