#!/usr/bin/python
#
# Ant
#
# Copyright (c) 2012, Gustav Tiger <gustav@tiger.name>
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

#from ant.base import Message
#from ant.easy.node import Node, Message
#from ant.easy.channel import Channel
from ant.fs.manager import Application, AntFSAuthenticationException
from ant.fs.file import File

import utilities
import scripting

import array
import logging
import time
from optparse import OptionParser   
import os
import struct
import sys
import traceback

_logger = logging.getLogger("garmin")

_directories = {
    ".":          File.Identifier.DEVICE,
    "activities": File.Identifier.ACTIVITY,
    "courses":    File.Identifier.COURSE,
    #"profile":   File.Identifier.?
    #"goals?":    File.Identifier.GOALS,
    #"bloodprs":  File.Identifier.BLOOD_PRESSURE,
    #"summaries": File.Identifier.ACTIVITY_SUMMARY,
    "settings":   File.Identifier.SETTING,
    "sports":     File.Identifier.SPORT_SETTING,
    "totals":     File.Identifier.TOTALS,
    "weight":     File.Identifier.WEIGHT,
    "workouts":   File.Identifier.WORKOUT}

_filetypes = dict((v, k) for (k, v) in _directories.items())


class Device:
    
    class ProfileVersionException(Exception):
        pass
    
    _PROFILE_VERSION      = 1
    _PROFILE_VERSION_FILE = "profile_version"
    
    def __init__(self, basedir, serial, name):
        self._path   = os.path.join(basedir, str(serial))
        self._serial = serial
        self._name   = name
        
        # Check profile version, if not a new device
        if os.path.isdir(self._path):
            if self.get_profile_version() < self._PROFILE_VERSION:
                raise Device.ProfileVersionException("Profile version mismatch, too old")
            elif self.get_profile_version() > self._PROFILE_VERSION:
                raise Device.ProfileVersionException("Profile version mismatch, to new")

        # Create directories
        utilities.makedirs_if_not_exists(self._path)
        for directory in _directories:
            directory_path = os.path.join(self._path, directory)
            utilities.makedirs_if_not_exists(directory_path)

        # Write profile version (If none)
        path = os.path.join(self._path, self._PROFILE_VERSION_FILE)
        if not os.path.exists(path):
            with open(path, 'wb') as f:
                f.write(str(self._PROFILE_VERSION))

    def get_path(self):
        return self._path

    def get_serial(self):
        return self._serial

    def get_name(self):
        return self._name

    def get_profile_version(self):
        path = os.path.join(self._path, self._PROFILE_VERSION_FILE)
        try:
            with open(path, 'rb') as f:
                return int(f.read())
        except IOError as e:
            # TODO
            return 0

    def read_passkey(self):

        try:
            with open(os.path.join(self._path, "authfile"), 'rb') as f:
                d = array.array('B', f.read())
                _logger.debug("loaded authfile: %r", d)
                return d
        except:
            return None
            
    def write_passkey(self, passkey):

        with open(os.path.join(self._path, "authfile"), 'wb') as f:
            passkey.tofile(f)
            _logger.debug("wrote authfile: %r, %r", self._serial, passkey)




class Garmin(Application):

    PRODUCT_NAME = "garmin-extractor"

    def __init__(self, uploading):
        Application.__init__(self)
        
        _logger.debug("Creating directories")
        self.config_dir = utilities.XDG(self.PRODUCT_NAME).get_config_dir()
        self.script_dir = os.path.join(self.config_dir, "scripts")
        utilities.makedirs_if_not_exists(self.config_dir)
        utilities.makedirs_if_not_exists(self.script_dir)
        
        self.scriptr  = scripting.Runner(self.script_dir)
        
        self.device = None
        self._uploading = uploading

    def setup_channel(self, channel):
        channel.set_period(4096)
        channel.set_search_timeout(255)
        channel.set_rf_freq(50)
        channel.set_search_waveform([0x53, 0x00])
        channel.set_id(0, 0x01, 0)
        
        channel.open()
        #channel.request_message(Message.ID.RESPONSE_CHANNEL_STATUS)
        print "Searching..."

    def on_link(self, beacon):
        _logger.debug("on link, %r, %r", beacon.get_serial(),
                      beacon.get_descriptor())
        self.link()
        return True

    def on_authentication(self, beacon):
        _logger.debug("on authentication")
        serial, name = self.authentication_serial()
        self._device = Device(self.config_dir, serial, name)
        
        passkey = self._device.read_passkey()
        print "Authenticating with", name, "(" + str(serial) + ")"
        _logger.debug("serial %s, %r, %r", name, serial, passkey)
        
        if passkey != None:
            try:
                print " - Passkey:",
                self.authentication_passkey(passkey)
                print "OK"
                return True
            except AntFSAuthenticationException as e:
                print "FAILED"
                return False
        else:
            try:
                print " - Pairing:",
                passkey = self.authentication_pair(self.PRODUCT_NAME)
                self._device.write_passkey(passkey)
                print "OK"
                return True
            except AntFSAuthenticationException as e:
                print "FAILED"
                return False

def main():
    
    parser = OptionParser()
    parser.add_option("--upload", action="store_true", dest="upload", default=False, help="enable uploading")
    parser.add_option("--debug", action="store_true", dest="debug", default=False, help="enable debug")
    (options, args) = parser.parse_args()
    
    # Find out what time it is
    # used for logging filename.
    currentTime = time.strftime("%Y%m%d-%H%M%S")

    # Set up logging
    logger = logging.getLogger("garmin")
    logger.setLevel(logging.DEBUG)

    # If you add new module/logger name longer than the 15 characters just increase the value after %(name).
    # The longest module/logger name now is "garmin.ant.base" and "garmin.ant.easy".
    formatter = logging.Formatter(fmt='%(threadName)-10s %(asctime)s  %(name)-15s  %(levelname)-8s  %(message)s (%(filename)s:%(lineno)d)')

    handler = logging.FileHandler(currentTime + "-garmin.log", "w")
    handler.setFormatter(formatter)
    logger.addHandler(handler)

    if options.debug:
        logger.addHandler(logging.StreamHandler())

    try:
        g = Garmin(options.upload)
        g.start()
    except Device.ProfileVersionException as e:
        print "\nError:", str(e), "\n\nThis means that", \
                Garmin.PRODUCT_NAME, "found that your data directory " \
                "stucture was too old or too new. The best option is " \
                "probably to let", Garmin.PRODUCT_NAME, "recreate your " \
                "folder by deleting your data folder, after backing it up, " \
                "and let all your files be redownloaded from your sports " \
                "watch."
    except (Exception, KeyboardInterrupt) as e:
        traceback.print_exc()
        for line in traceback.format_exc().splitlines():
            _logger.error("%r", line)
        print "Interrupted:", str(e)
        g.stop()
        sys.exit(1)

if __name__ == "__main__":
    sys.exit(main())

