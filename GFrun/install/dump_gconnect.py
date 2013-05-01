#!/usr/bin/env python

# Copyright (c) 2012, Mattias Lidman
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL MATTIAS LIDMAN BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Creates a local back-up of a Garmin Connect users activity files in GPX, TCX
# and KLM format.

import urllib2
import urllib
import re
import json
import os
import getpass

class GarminConnectClient():

    def __init__(self, username, password, gc_host='connect.garmin.com'):
        # Signs user in to Garmin Connect.
        self.gc_host = 'https://' + gc_host
        signin_path = '/signin'
        username_path = '/user/username'

        self.opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(),
                                           urllib2.BaseHandler)
        urllib2.install_opener(self.opener)

        params = {'javax.faces.ViewState': 'j_id1',
                  'login': 'login',
                  'login:loginUsernameField' : username,
                  'login:password': password,
                  'login:signInButton': 'Sign In'}
        params = urllib.urlencode(params)

        self.opener.open(self.gc_host + signin_path).read()
        self.opener.open(self.gc_host + signin_path, params)

        # The signin method will return a 200 OK even if the signin failed,
        # so verify by getting the username instead:
        username_json = self.opener.open(self.gc_host + username_path).read()
        if not json.loads(username_json)['username'] == username:
            exit("Login failed.")

    def get_activity_ids(self):
        # Scrape the Activities page for activity IDs.
        # NOTE: I have no idea if this will work when you start having a large
        # number of activities on your page. Presumably Garmin Connect does
        # some sort of paging.
        activities_page = self.opener.open(self.gc_host + '/activities').read()
        id_matches = re.search('/activity/[0-9]+', activities_page)
        id_matches = re.findall('/activity/[0-9]+', activities_page)
        ids = [ id.replace('/activity/', '') for id in id_matches ]
        return ids

    def dump_activities(self, activity_ids, path, overwrite_existing=False, gpx=True, tcx=True, kml=True):
        # Save all activities in a list of IDs to disk, in one or more of the
        # following formats:
        #   GPX (GPS eXchange Format): Common format that is basically a
        #   collection of timestamped GPS points.
        #   TCX (Training Center XML): Garmin format that extends GPX but does
        #   not seem to be a strict superset. For instance, GPX files downloaded
        #   from GC contains the name of the activity but the TCX does not.
        #   KML (Keyhole Markup Language): Google Earth format.

        gpx_path = '/proxy/activity-service-1.1/gpx/activity/'
        tcx_path = '/proxy/activity-service-1.1/tcx/activity/'
        kml_path = '/proxy/activity-service-1.0/kml/activity/'
        for activity_id in activity_ids:
            if gpx and (not os.path.isfile(path+'/gpx/'+activity_id+'.gpx') or overwrite_existing):
                activity = self.opener.open(self.gc_host + gpx_path + activity_id + '?full=true').read()
                self._write_to_disk(path+'/gpx/', activity_id+'.gpx', activity, overwrite_existing)
            if tcx and (not os.path.isfile(path+'/tcx/'+activity_id+'.tcx') or overwrite_existing):
                if os.path.isfile(path+'/tcx/'+activity_id+'.tcx') and not overwrite_existing:
                    continue
                activity = self.opener.open(self.gc_host + tcx_path + activity_id + '?full=true').read()
                self._write_to_disk(path+'/tcx/', activity_id+'.tcx', activity, overwrite_existing)
            if kml and (not os.path.isfile(path+'/kml/'+activity_id+'.kml') or overwrite_existing):
                if os.path.isfile(path+'/kml/'+activity_id+'.kml') and not overwrite_existing:
                    continue
                activity = self.opener.open(self.gc_host + kml_path + activity_id + '?full=true').read()
                self._write_to_disk(path+'/kml/', activity_id+'.kml', activity, overwrite_existing)

    def _write_to_disk(self, path, filename, activity, overwrite):
        if not os.path.exists(path):
            os.makedirs(path)
        with open(path + filename, "w") as text_file:
            text_file.write(activity)

username = raw_input("Garmin Connect username: ")
password = getpass.getpass()
directory = raw_input("Destination directory (default: current):")
directory = '.' if directory == '' else directory
directory = os.path.expanduser(directory)
client = GarminConnectClient(username, password)
ids = client.get_activity_ids()
client.dump_activities(ids, directory)
