"""
Upload Garmin

Handle the operation to upload to the Garmin Connect Website.

"""
#
#
# This version of UploadGarmin.py leverages heavily from work done in the
# tapiriik project (https://github.com/cpfair/tapiriik), particularly the new
# Garmin Connect user authentication using Jasig CAS.
#
# Copyright (c) David Lotton 02/2014
#
# License: Apache 2.0
#
# Information: 2/26/2014
# Complete redesign of UploadGarmin.py due to major changes in the Garmin
# Connect authorization scheme which rolled out in late Feb 2014. License has
# change from previous version of this file to comply with licence of the work
# from which this work was derived.
#
# THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM
# 'AS IS' WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
# IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
# ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
# IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME
# THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
#

import requests
import time
import re
import logging
import os.path

class ServiceExceptionScope:
    Account = "account"
    Service = "service"

class ServiceException(Exception):
    def __init__(self, message, scope=ServiceExceptionScope.Service, block=False, user_exception=None):
        Exception.__init__(self, message)
        self.Message = message
        self.UserException = user_exception
        self.Block = block
        self.Scope = scope

    def __str__(self):
        return self.Message + " (user " + str(self.UserException) + " )"

class APIException(ServiceException):
    pass

class UserExceptionType:
    # Account-level exceptions (not a hardcoded thing, just to keep these seperate)
    Authorization = "auth"
    AccountFull = "full"
    AccountExpired = "expired"
    AccountUnpaid = "unpaid" # vs. expired, which implies it was at some point function, via payment or trial or otherwise.

    # Activity-level exceptions
    FlowException = "flow"
    Private = "private"
    NotTriggered = "notrigger"
    MissingCredentials = "credentials_missing" # They forgot to check the "Remember these details" box
    NotConfigured = "config_missing" # Don't think this error is even possible any more.
    StationaryUnsupported = "stationary"
    TypeUnsupported = "type_unsupported"
    DownloadError = "download"
    ListingError = "list" # Cases when a service fails listing, so nothing can be uploaded to it.
    UploadError = "upload"
    SanityError = "sanity"
    Corrupt = "corrupt" # Kind of a scary term for what's generally "some data is missing"
    Untagged = "untagged"
    LiveTracking = "live"
    UnknownTZ = "tz_unknown"
    System = "system"
    Other = "other"

class UserException:
    def __init__(self, type, extra=None, intervention_required=False, clear_group=None):
        self.Type = type
        self.Extra = extra # Unimplemented - displayed as part of the error message.
        self.InterventionRequired = intervention_required # Does the user need to dismiss this error?
        self.ClearGroup = clear_group if clear_group else type # Used to group error messages displayed to the user, and let them clear a group that share a common cause.


class UploadGarmin:
    """
    Upload Garmin

    Handle operation to open to Garmin
    """
    def __init__(self, logLevel = 30):
        self._last_req_start = None
        self.cookies = None
        logging.basicConfig(level=logLevel)


    def _rate_limit(self):
        min_period = 1 # I appear to been banned from Garmin Connect while determining this.
        if not self._last_req_start:
            self._last_req_start = 0.0

        wait_time = max(0, min_period - (time.time() - self._last_req_start))
        time.sleep(wait_time)

        self._last_req_start = time.time()
        #print("Rate limited for %f" % wait_time)
        logging.info("Rate limited for %f" % wait_time)


    def login(self, username, password):
        if self._get_cookies(username=username, password=password):
            return True
        else:
            return False


    def _get_cookies(self, username=None, password=None):
        if self.cookies:
            return self.cookies

        if username is None or password is None:
            raise APIException("Username and/or password missing")

        # Start session
        session = requests.Session()

        # First, get SSO server hostname
        self._rate_limit()
        sso_resp = session.get('https://connect.garmin.com/gauth/hostname')
        if sso_resp.status_code != 200:
            raise APIException("SSO Hostname retrieval failed")
        sso_hostname = sso_resp.json().get('host', None).rstrip('.garmin.com')
        logging.debug('SSO Hostname: %s' % sso_hostname)

        # Then get login ticket
        # With full parameters from a web browser request
        # Don't ask me why Garmin needs all this garbage :/
        self._rate_limit()
        params = {
            'clientId' : 'GarminConnect',
            'webhost' : sso_hostname,
            'consumeServiceTicket' : 'false',
            'createAccountShown' : 'true',
            'cssUrl' : 'https://static.garmincdn.com/com.garmin.connect/ui/css/gauth-custom-v1.1-min.css',
            'displayNameShown' : 'false',
            'embedWidget' : 'false',
            'gauthHost' : 'https://sso.garmin.com/sso',
            'generateExtraServiceTicket' : 'false',
            'id' : 'gauth-widget',
            'initialFocus' : 'true',
            'locale' : 'fr',
            'openCreateAccount' : 'false',
            'redirectAfterAccountCreationUrl' : 'https://connect.garmin.com/post-auth/login',
            'redirectAfterAccountLoginUrl' : 'https://connect.garmin.com/post-auth/login',
            'rememberMeChecked' : 'false',
            'rememberMeShown' : 'true',
            'service' : 'https://connect.garmin.com/post-auth/login',
            'source' : 'https://connect.garmin.com/fr-FR/signin',
            'usernameShown' : 'false',
        }
        ticket_resp = session.get('https://sso.garmin.com/sso/login', params=params)
        if ticket_resp.status_code != 200:
            raise APIException("Ticket retrieval failed")

        # Get the login ticket value
        regex = '<input\s+type="hidden"\s+name="lt"\s+value="(?P<lt>\w+)"\s+/>'
        res = re.search(regex, ticket_resp.text)
        if not res:
          raise APIException('No login ticket')
        login_ticket = res.group('lt')
        logging.debug('Found login ticket %s', login_ticket)

        # Login/Password with login ticket
        # Send through POST
        data = {
          # All parameters are needed
          '_eventId' : 'submit',
          'displayNameRequired' : 'false',
          'embed' : 'true',
          'lt' : login_ticket,
          'username' : username,
          'password' : password,
        }
        headers = {
          'Host' : 'sso.garmin.com', # Don't ask. Really.
        }

        self._rate_limit()
        login_resp = session.post('https://sso.garmin.com/sso/login', params=params, data=data, headers=headers)
        if login_resp.status_code != 200:
          raise APIException('First authentification failed.')

        # Try to find the full post login url in response
        # From JS code source :
        # var response_url = 'https://connect.garmin.com/post-auth/login?ticket=ST-03582405-W6gvTaVCJe0Yx93AB2yu-cas'
        regex = 'var response_url(\s+)= \'https://connect.garmin.com/post-auth/login\?ticket=(?P<ticket>.+)\''
        matches = re.search(regex, login_resp.text)
        if not matches:
            raise APIException('Authentication ticket not found')
        params = {
            'ticket' : matches.group('ticket'),
        }
        logging.debug('Found service ticket %s', params['ticket'])

        # Lastly, do a final auth with the service ticket
        self._rate_limit()
        headers = {
            'Host' : 'connect.garmin.com',
        }
        final_resp = session.get('https://connect.garmin.com/post-auth/login', params=params, headers=headers)
        if final_resp.status_code != 200 and not final_resp.history:
            raise APIException('Second auth step failed.')

        # Check login
        check_resp = session.get('https://connect.garmin.com/user/username')
        if check_resp.status_code != 200:
            raise APIException("Login check retrieval failed")
        garmin_user = check_resp.json()
        if not garmin_user.get('username', None):
            raise APIException("Login check failed.")
        logging.info('Logged in as %s' % (garmin_user['username']))

        self.cookies = session.cookies
        return self.cookies


    def upload_file(self, uploadFile):

        extension = os.path.splitext(uploadFile)[1].lower()

        # Valid File extensions are .tcx, .fit, and .gpx
        if extension not in ['.tcx', '.fit', '.gpx']:
            raise Exception("Invalid File Extension")

        if extension == '.fit':
            mode = 'rb'
        else:
            mode = 'r'

        files = {"file": (uploadFile, open(uploadFile, mode))}
        cookies = self._get_cookies()
        self._rate_limit()
        res = requests.post("https://connect.garmin.com/modern/proxy/upload-service/upload/%s" % extension, files=files, cookies=cookies)
        if res.status_code not in (200, 201, 409):
            return ['FAIL', 'Upload failed, status %d' % res.status_code]
        res = res.json()["detailedImportResult"]

        if len(res["successes"]) == 0:
          if res["failures"][0]["messages"][0]['code'] == 202:
            return ['EXISTS', res["failures"][0]["internalId"]]
          else:
            return ['FAIL', res["failures"][0]["messages"]]
        else:
            # Upload was successsful
            return ['SUCCESS', res["successes"][0]["internalId"]]

    def name_workout(self, workout_id, workout_name):
        cookies = self._get_cookies()
        data = {"value": workout_name.encode("UTF-8")}
        self._rate_limit()
        res = requests.post('http://connect.garmin.com/proxy/activity-service-1.0/json/name/%d' % (workout_id), data=data, cookies=cookies)
        res = res.json()["display"]["value"]

        if res != workout_name:
            raise Exception("Naming workout has failed")



if __name__ == '__main__':
    g = UploadGarmin()
    g.login("username", "password")
    wId = g.upload_tcx('/tmp/a.tcx')
    wInfo = g.upload_file('/tmp/a.tcx')
    g.name_workout(wId, "TestWorkout")
