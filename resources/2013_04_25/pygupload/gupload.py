#!/usr/bin/python

###
# Copyright (c) David Lotton 01/2012 <yellow56@gmail.com>
#
# All rights reserved.
#
# License: GNU General Public License (GPL)
#
# THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM 
# 'AS IS' WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
# IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE 
# ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM 
# IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME 
# THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
#
#
# Name: gupload.py
#
#   Brief:  gupload.py is a utility to upload Garmin fitness
#       GPS files to the connect.garmin.com web site.  
#       It requires that you have a user account on that
#       site.  See help (-h option) for more information.
###

# Make sure you have MultipartPostHandler.py in your path as well
import UploadGarmin
import argparse
import os.path
import ConfigParser
import logging
import platform
import string
import glob

parser= argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description='A script to upload .TCX, .GPX, and .FIT files to the Garmin Connect web site.',
    epilog="""
    Status Output:
        The script will output a status for each upload file; Success, FAIL, or
	EXISTS.  Definitions are as follows: 

        SUCCESS = Garmin Connect indicated that the upload was successful.
	FAIL = Garmin Connect indicated there was a problem with the upload.
        EXISTS = Garmin Connect indicated that the workout already exists in
                 your account.

    Credentials:
        Username and password credentials may be placed in a configuration file 
        located either in the current working directory, or in the user's home
        directory.  WARNING, THIS IS NOT SECURE. USE THIS OPTION AT YOUR OWN
        RISK.  Username and password are stored as clear text in a file
        format that is consistent with Microsoft (r) INI files. 
    
        The configuration file must contain a [Credentials] section containing 
        'username' and 'password' entries.

        The name of the config file for non-windows platforms is '.guploadrc'
        for windows platforms the config file is named 'gupload.ini'.


        Example \'.guploadrc\' (or \'gupload.ini\' for windows):
            [Credentials]
            username=<myusername>
            password=<mypassword>

        Replace <myusername> and <mypassword> above with your own login 
        credentials.

    Priority of credentials:
        Command line credentials take priority over config files, current 
        directory config file takes priority over a config file in the user's
        home directory.

    Examples:
        Upload file and set activty name:
            gupload.py -l myusername mypassword -a 'Run at park - 12/23' myfile.tcx

        Upload multiple files:
            gupload.py -l myusername mypassword myfile1.tcx myfile2.tcx myfile3.fit

        Upload file using config file for credentials, name file, verbose 
        output:
            gupload.py -v 1 -a 'Run at park - 12/23' myfile.tcx
    """)
parser.add_argument('filename', type=str, nargs='+', help='Path and name of file(s) to upload.')
parser.add_argument('-a', type=str, nargs=1, help='Sets the activity name for the upload file. This option is ignored if multiple upload files are given.')
parser.add_argument('-l', type=str, nargs=2, help='Garmin Connect login credentials \'-l username password\'')
parser.add_argument('-v', type=int, nargs=1, default=[3], choices=[1, 2, 3, 4, 5] , help='Verbose - select level of verbosity. 1=DEBUG(most verbose), 2=INFO, 3=WARNING, 4=ERROR, 5= CRITICAL(least verbose). [default=3]')

myargs = parser.parse_args()

logging.basicConfig(level=(myargs.v[0]*10))

if platform.system() == 'Windows':
    configFile='gupload.ini'
else:
    configFile='.guploadrc'


# ----Login Credentials for Garmin Connect----
# If credentials are given on command line, use them.
# If no credentials are given on command line, look in 
# current directory for a .guploadrc file (or gupload.ini
# for windows).  If no .guploadrc/gupload.ini file exists
#  in the current directory look in the user's home directory.
configCurrentDir=os.path.abspath(os.path.normpath('./' + configFile))
configHomeDir=os.path.expanduser(os.path.normpath('~/' + configFile))

if myargs.l:
    logging.debug('Using credentials from command line.')
    username=myargs.l[0]
    password=myargs.l[1]
elif os.path.isfile(configCurrentDir):
    logging.debug('Using credentials from \'' + configCurrentDir + '\'.')
    config=ConfigParser.RawConfigParser()
    config.read(configCurrentDir)
    username=config.get('Credentials', 'username')
    password=config.get('Credentials', 'password')
elif os.path.isfile(configHomeDir):
    logging.debug('Using credentials from \'' + configHomeDir + '\'.')
    config=ConfigParser.RawConfigParser()
    config.read(configHomeDir)
    username=config.get('Credentials', 'username')
    password=config.get('Credentials', 'password')
else:
    cwd = os.path.abspath(os.path.normpath('./'))
    homepath = os.path.expanduser(os.path.normpath('~/'))
    logging.critical('\'' + configFile + '\' file does not exist in current directory (' + cwd + ') or home directory (' + homepath + ').  Use -l option.')
    exit(1)

def obscurePassword(password):
    length=len(password)
    if length==1:
        return('*')
    elif length == 2:
        return(password[1] + '*')
    else:
        obscured=password[0]
        for letter in range(1, length-1):
            obscured=obscured+'*'
        obscured=obscured+password[length-1]
        return(obscured)


logging.debug('Username: ' + username)
logging.debug('Password: ' + obscurePassword(password))

filenames=myargs.filename

def checkFile(filename, fileList):
    # checkFile - check to see if file exists, append to file list if exsists
    logging.debug('Filename: ' + filename)
    if os.path.isfile(filename):
        logging.debug('File exists.')

        # Get file extension from name
        extension = os.path.splitext(filename)[1].lower()
        logging.debug('File Extension: ' + extension)

        # Valid file extensions are .tcx, .fit, and .gpx
        if extension in ['.tcx', '.fit', '.gpx']:
            logging.debug('File \'' + filename + '\' extension \'' + extension + '\' is valid.')
            fileList.append([filename])
        else: 
            logging.warning('File \'' + filename + '\' extension \'' + extension + '\' is not valid. Skipping file...')
    else:
        logging.warning('File \'' + filename + '\' does not exist. Skipping...')

# Check to see if files exist and if the file type is valid
# Build a list of 'workouts' that includes the valid files
# workout=[str filename, int workoutId, str status]
workouts=[]
for filename in filenames:
    if string.find(filename, '*') < 0:
        checkFile(filename, workouts)
    else:
        # For Windows we have to expand wildcards ourself
        # Ubuntu Linux appears to do the expansion
        wildcards=glob.glob(filename)
        for wildcard in wildcards:
            checkFile(wildcard, workouts)

if len(workouts) == 0:
    logging.critical('No valid Files.')
    exit(1)

if myargs.a and len(workouts)==1:
    activityName=myargs.a[0]
    logging.debug('Activity Name: ' + activityName)

# Create object
g = UploadGarmin.UploadGarmin()

# LOGIN
if not g.login(username, password):
    logging.critical('LOGIN FAILED - please verify your login credentials')
    exit(1)
else:
    logging.info('Login Successful.')

    
# UPLOAD files and append results (workout ID and status)
# to each workout in 'workouts'
for workout in workouts:
    workout += g.upload_file(workout[0])
    print 'File: ' + workout[0] + '    ID: ' + str(workout[2]) + '   Status: ' + workout[1]


# Name workout if name given. Only for single file.  Easier
# to name multiple files from the Garmin Connect site.
if 'activityName' in locals() and len(workouts) == 1:
    if workouts[0][1] == 'SUCCESS':
        g.name_workout(workouts[0][2], activityName)
        logging.info('Acivity name \'' + activityName + '\' written.')
    else: 
        logging.error('Acivity name not written')

exit()

