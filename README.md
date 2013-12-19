===============================================================================
#GFrun - Garmin Forerunner 60 - 405CX - 310XT - 610 - 910XT - Inside Linux
===============================================================================

GFrun :
-------
   + Simplify the installation of the various modules.
   + Extract the FIT. Garmin Forerunner watches
   + Convert FIT. In. TCX
   + Upload the "activities" of http://connect.garmin.com
   + Download all "activites" of http://connect.garmin.com

REQUIREMENTS:
-------
Software :

   + Linux : Debian (7.x) 
   + Linux : Ubuntu (13.04 64bit  / 12.04 64bit )
   + Python : 2.7+
   + PyUSB : 1.0
   
Dependances :

lsb-release xterm git garminplugin libusb-1.0-0 python-pip python-usb python-vte python-lxml python-pkg-res

Hardware :
   
Garmin Forerunner :
   + Garmin Forerunner 60
   + Garmin Forerunner 405CX
   + Garmin Forerunner 310XT
   + Garmin Forerunner 610
   + Garmin Forerunner 910XT
   + Garmin FR70
   + Garmin Swim

Dongle usb : ANT FS /ANT+ 
   + ID_product 1008
   + ID_product 1009

INSTALL :
---------

STABLE Version (branch GFrun) :
<pre><code>wget -N https://github.com/xonel/GFrun/raw/GFrun/GFrun/GFrun.sh && chmod a+x GFrun.sh && sudo bash ./GFrun.sh
</code></pre>

DEV Version (branch MASTER) :
<pre><code>wget -N https://github.com/xonel/GFrun/raw/master/GFrun/GFrun.sh && chmod a+x GFrun.sh && sudo bash ./GFrun.sh
</code></pre>

VISUEL :
---------

<a href='https://github.com/xonel/GFrun/raw/master/_.local/share/GFrun/GFrun.png'><img src='https://github.com/xonel/GFrun/raw/master/_.local/share/GFrun/GFrun.png' /></a>

Modules inside GFrun :
+ garminplugin_0.3.16-1 : ( https://github.com/adiesner/GarminPlugin )
  - plugin firefox <> http:// connect.garmin.com
+ Garmin-Forerunner-610-Extractor : ( https://github.com/Tigge/Garmin-Forerunner-610-Extractor) 
  - Extract .FIT from (ANT-FS), convert .FIT to .TCX with (40-convert_to_tcx.py)
+ gcpuploader : ( http://sourceforge.net/projects/gcpuploader/ )
  - Auto upload "FIT/TCX" on http:// connect.garmin.com

TODO :
--------
- GUI (Qt/GTK or ??)
- Manual
- Learn 'Bash' ;O)


--------
- GitHub : https://github.com/xonel/GFrun 
- Web : http://gfrun.fr.nf 
- Forum (FR) : http://forum.ubuntu-fr.org/viewtopic.php?id=1267521

