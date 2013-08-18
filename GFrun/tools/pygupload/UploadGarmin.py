"""
Upload Garmin

Handle the operation to upload to the Garmin Connect Website.

"""
# 
# This file is derived from orignal work by Chmouel Boudjnah <chmouel@chmouel.com>
# Original Source: https://github.com/chmouel/python-garmin-upload
#
# Modifications Copyright (c) David Lotton 01/2012
#
# License: BSD
#
# Modified 01/2012 by David Lotton to allow all upload file formats (tcx, fit, gpx)
# supported by connect.garmin.com.  Renamed all incorrectly named references to
# 'ctx' as 'tcx'. Corrected URI in original 'upload_tcx' function, adding the file
# type extension to the URI.
#

import urllib2
import urllib
import MultipartPostHandler
try:
    import simplejson
except ImportError:
    import json as simplejson
import os.path


class UploadGarmin:
    """
    Upload Garmin

    Handle operation to open to Garmin
    """
    def __init__(self):
        self.opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(),
                                           MultipartPostHandler.MultipartPostHandler)
        urllib2.install_opener(self.opener)

    def login(self, username, password):
        """
        Login to garmin

        @ivar username: Garmin USERNAME
        @type username: str
        @ivar password: Garmin PASSWORD
        @type password: str
        """

        params = {'javax.faces.ViewState': 'j_id1',
                  'login': 'login',
                  'login:loginUsernameField' : username,
                  'login:password': password,
                  'login:signInButton': 'Sign In'}
        params = urllib.urlencode(params)

        #GO Figure out!
        self.opener.open('https://connect.garmin.com/signin').read()
        
        status = self.opener.open('https://connect.garmin.com/signin', params)
        vary_header = status.headers['vary']
        status.close()

        #dlotton - If login succeeds this returns a JSON with the username
        # something like {"username":"fred"}
        json = self.opener.open('http://connect.garmin.com/user/username').read().strip()

        # Uncomment for debugging
        #print '\tLogin_Username: ' + username
        #print '\tJSON: ' + json
        #print '\tJSON_Username: ' + simplejson.loads(json)['username']

        if simplejson.loads(json)['username'] != '':
            return(True)
        else:
            return(False)
    

    def upload_file(self, uploadFile):
        """
        Upload a File

        You need to be logged already

        @ivar uploadFile: The TCX, GPX, or FIT file name to upload
        @type uploadFile: str
        """

        extension = os.path.splitext(uploadFile)[1].lower()

        # Valid File extensions are .tcx, .fit, and .gpx
        if extension not in ['.tcx', '.fit', '.gpx']:
            raise Exception("Invalid File Extension")

        if extension == '.fit':
            mode = 'rb'
        else:
            mode = 'r'
        
        params = {
            "responseContentType" : "text%2Fhtml",
            "data" : open(uploadFile, mode)
        }

        uploadUri='http://connect.garmin.com/proxy/upload-service-1.1/json/upload/'+extension
        # debug:
        #print '\tURI: ' + uploadUri

        output = self.opener.open(uploadUri, params)
        if output.code != 200:
            raise Exception("Error while uploading")
        json = output.read()
        output.close()

        # debug: Helpful info - uncomment the following print statements
        #print '--------------debug-------------'
        #print uploadFile
        #print json
        #print '--------------debug-------------'
        if len(simplejson.loads(json)["detailedImportResult"]["successes"])==0:
            if len(simplejson.loads(json)["detailedImportResult"]["failures"]) != 0:
                # File already exists on Garmin Connect
                return ['EXISTS', simplejson.loads(json)["detailedImportResult"]["failures"][0]["internalId"]]
            else:
                # Don't know what failed
                return ['FAIL', 'Upload Fail']
        else:
            # Upload was successsful
            return ['SUCCESS', simplejson.loads(json)["detailedImportResult"]["successes"][0]["internalId"]]

    def upload_tcx(self, tcx_file):
        """
        Upload a TCX File

        You need to be logged already

        @ivar tcx_file: The TCX file name to upload
        @type tcx_file: str
        """
        params = {
            "responseContentType" : "text%2Fhtml",
            "data" : open(tcx_file)
        }
        
        #dlotton - added '.tcx' to the end of the URI below
        output = self.opener.open('http://connect.garmin.com/proxy/upload-service-1.1/json/upload/.tcx', params)
        if output.code != 200:
            raise Exception("Error while uploading")
        json = output.read()
        output.close()

        return simplejson.loads(json)["detailedImportResult"]["successes"][0]["internalId"]

    def name_workout(self, workout_id, workout_name):
        """
        Name a Workout

        Note: You need to be logged already

        @ivar workout_id: Workout ID to rename
        @type workout_id: int
        @ivar workout_name: New workout name
        @type workout_name: str

        """
        params = dict(value=workout_name)
        params = urllib.urlencode(params)
        output = self.opener.open('http://connect.garmin.com/proxy/activity-service-1.0/json/name/%d' % (workout_id), params)
        json = output.read()
        output.close()

        if simplejson.loads(json)["display"]["value"] != workout_name:
            raise Exception("Naming workout has failed")

    def workout_url(self, workout_id):
        """
        Get the Workout URL

        @ivar workout_id: Workout ID
        @type workout_id: int
        """
        return "http://connect.garmin.com/activity/" % (int(workout_id))
        
if __name__ == '__main__':
    g = UploadGarmin()
    g.login("username", "password")
    wId = g.upload_tcx('/tmp/a.tcx')
    wInfo = g.upload_file('/tmp/a.tcx')
    g.name_workout(wId, "TestWorkout")