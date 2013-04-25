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


CONFIGURATION DE TEST POUR DEV SCRIPT :

Garmin Forerunner 310XT (Allumée)
Clef Usb ANT+ (connecté à l'ordinateur)
Ubuntu 13.10 64bit (25/04/2013 UpDate) / Ubuntu 12.04 64bit
