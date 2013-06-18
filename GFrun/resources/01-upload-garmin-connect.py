#!/usr/bin/python
#
# Script to run to upload FIT file to garmin connect.
#
# Leveraged from code in python-ant-downloader project on github.
#
# To use, place uploader.cfg in ~/.config/garmin-extractor and fill
# in your login information.
#
#
# Copyright (c) 2012, Braiden Kindt.
# Copyright (c) 2012, Mario Limonciello <superm1@ubuntu.com>
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

import errno
import os
import subprocess
import sys
import urllib
import urllib2
import cookielib
import json
import glob
import logging
import ConfigParser

DEFAULT_CONFIG_LOCATION = os.path.expanduser("~/.guploadrc")
_log = logging.getLogger("garmin-upload")

class GarminConnect():
    logged_in = False
    login_invalid = False

    def __init__(self, username, password):
        import poster.streaminghttp
        self.username = username
        self.password = password
        cookies = cookielib.CookieJar()
        cookie_handler = urllib2.HTTPCookieProcessor(cookies)
        self.opener = urllib2.build_opener(
                cookie_handler,
                poster.streaminghttp.StreamingHTTPHandler,
                poster.streaminghttp.StreamingHTTPRedirectHandler,
                poster.streaminghttp.StreamingHTTPSHandler)

    def login(self):
        if self.logged_in: return
        if self.login_invalid: raise InvalidLogin()
        # get session cookies
        _log.debug("Fetching cookies from Garmin Connect.")
        self.opener.open("http://connect.garmin.com/signin")
        # build the login string
        login_dict = {
            "login": "login",
            "login:loginUsernameField": self.username,
            "login:password": self.password,
            "login:signInButton": "Sign In",
            "javax.faces.ViewState": "j_id1",
        }
        login_str = urllib.urlencode(login_dict)
        # post login credentials
        _log.debug("Posting login credentials to Garmin Connect. username=%s", self.username)
        self.opener.open("https://connect.garmin.com/signin", login_str)
        # verify we're logged in
        _log.debug("Checking if login was successful.")
        reply = self.opener.open("http://connect.garmin.com/user/username")
        if json.loads(reply.read())["username"] != self.username: 
            self.login_invalid = True
            raise InvalidLogin()
        self.logged_in = True
    
    def upload(self, format, file_name):
        import poster.encode
        with open(file_name) as file:
            upload_dict = {
                "responseContentType": "text/html",
                "data": file,
            }
            data, headers = poster.encode.multipart_encode(upload_dict)
            _log.info("Uploading %s to Garmin Connect.", file_name) 
            request = urllib2.Request("http://connect.garmin.com/proxy/upload-service-1.1/json/upload/.%s" % format, data, headers)
            self.opener.open(request)

def main(action, filename):

    if action != "DOWNLOAD" or not os.path.exists(DEFAULT_CONFIG_LOCATION):
        return 0

    cfg = ConfigParser.SafeConfigParser()
    read = cfg.read([DEFAULT_CONFIG_LOCATION])
    if not read:
        return read
    try:
        if cfg.getboolean("garmin.connect", "enabled"):
            username = cfg.get("garmin.connect", "username")
            password = cfg.get("garmin.connect", "password")
            client = GarminConnect(username, password)
            client.login()
            client.upload("fit", filename)
    except ConfigParser.NoSectionError: pass
    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1], sys.argv[2]))

