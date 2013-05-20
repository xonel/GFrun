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

CONFIG :
---------------
Configuration de test pour le developpement du script "GFrun" :
   + Garmin Forerunner 310XT (Allumée)
   + Clef Usb ANT (connecté à l'ordinateur) 
   + Ubuntu 13.10 64bit (25/04/2013 UpDate) / Ubuntu 12.04 64bit

INSTALL :
---------

STABLE Version (branch GFrun) :
<pre><code>wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh
chmod a+x GFrunMenu.sh
sudo sh ./GFrunMenu.sh
</code></pre>

<pre><code>wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
</code></pre>

DEV Version (branch MASTER) :
<pre><code>wget -N https://github.com/xonel/GFrun/raw/master/GFrun/install/GFrunMenu.sh && chmod a+x GFrunMenu.sh && sudo sh ./GFrunMenu.sh
</code></pre>

VISUEL :
---------

<a href='http://pix.toile-libre.org/upload/original/1367627754.png'><img src='http://pix.toile-libre.org/upload/original/1367627754.png' /></a>

Modules inside GFrun :
+ garminplugin_0.3.16-1 : ( https://github.com/adiesner/GarminPlugin )
  - plugin firefox <> http:// connect.garmin.com
+ Garmin-Forerunner-610-Extractor : ( https://github.com/Tigge/Garmin-Forerunner-610-Extractor) 
  - Extract .FIT from (ANT-FS), convert .FIT to .TCX with (40-convert_to_tcx.py)
+ gcpuploader : ( http://sourceforge.net/projects/gcpuploader/ )
  - Auto upload "FIT/TCX" on http:// connect.garmin.com

DONE :
-----
+ install and config de Garmin-Forerunner-610-Extractor : Version MASTER via GIT
+ install and config : garminplugin_0.3.16-1 
+ install gcpuploader (script config OK / Script upload via GFrunMenu OK)
+ install python-fitparse :  Version MASTER via GIT
+ install and config : 40-convert_to_tcx.py
+ Multi versions DEV/STABLE/OFFLINE
+ Icons.svg and GFrun.desktop

TODO :
--------
- GUI (Qt/GTK or ??)
- Manual
- Learn 'Bash' ;O)

Forum (FR) : http://forum.ubuntu-fr.org/viewtopic.php?id=1267521
