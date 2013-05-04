===============================================================================
#GFrun - Garmin Forerunner 60 - 405CX - 310XT - 610 - 910XT - Inside Linux
===============================================================================

GFrun :
-------
GFrun est capable de :
   + Simplifier l'installation des différents modules.
   + Configurer les fichiers de config en fonction de la config utilisateur.
   + Extraitre le .FIT des montres Garmin Forerunner
   + Convertir les .FIT en .TCX
   + Uploader les "activites" sur http://connect.garmin.com

CONFIGURATION :
---------------
Configuration de test pour le developpement du script "GFrun" :
   + Garmin Forerunner 310XT (Allumée)
   + Clef Usb ANT (connecté à l'ordinateur) 
   + Ubuntu 13.10 64bit (25/04/2013 UpDate) / Ubuntu 12.04 64bit

INSTALL :
---------
(ATTENTION : Script en cours de developpement !! Bugs possibles !! ...) :

<pre><code>wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh
chmod a+x GFrunMenu.sh
sudo sh ./GFrunMenu.sh
</code></pre>

<pre><code>
wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
</code></pre>

VISUEL :
---------

<a href='http://pix.toile-libre.org/upload/original/1367627754.png'><img src='http://pix.toile-libre.org/upload/original/1367627754.png' /></a>

Voici les briques principales de GFrun :
+ garminplugin_0.3.16-1 : ( https://github.com/adiesner/GarminPlugin )
  - Permet de connecter notre firefox au site http:// connect.garmin.com
+ Garmin-Forerunner-610-Extractor : ( https://github.com/Tigge/Garmin-Forerunner-610-Extractor) 
  - Récupère les fichiers .FIT de nos montres (ANT-FS) et convertit les .FIT en .TCX à l'aide du script (40-convert_to_tcx.py)
+ gcpuploader : ( http://sourceforge.net/projects/gcpuploader/ )
  - upload automatiquement les "FIT/TCX" sur http:// connect.garmin.com

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

Forum : http://forum.ubuntu-fr.org/viewtopic.php?id=1267521
