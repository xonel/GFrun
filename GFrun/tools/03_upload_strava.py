import json, traceback, glob, threading, sqlite3, os, sys
import urllib.request, time, tkinter, tkinter.messagebox

## Strava duplicate activity detection seems to be nearly broken for the API, make sure you're not uploading duplicate files


def get_auth_token(credentials={"email":"your@email.com","password":"your_password"}):

    post_data=json.dumps(credentials).encode("utf-8")
    headers = {}
    headers['Content-Type'] = "application/json"
    try:
        req = urllib.request.Request("http://www.strava.com/api/v2/authentication/login", post_data,headers)
        res = urllib.request.urlopen(req)
        token = json.loads(res.read().decode('utf-8'))['token']
        print("Successfully authenticated to Strava!")
    except:
        print("There was an error authenticating to Strava")
        print(traceback.format_exc())
        return False    
    
    return token



def upload_fit_file(token, fitfile):

    fitdata = open(fitfile,"rb").read()

    data = urllib.parse.urlencode({'token': token,'data': fitdata,'type': 'fit','activity_name': fitfile}).encode()
    
    try:
        req = urllib.request.Request("http://www.strava.com/api/v2/upload", data)
        res = urllib.request.urlopen(req)

        upload_id = json.loads(res.read().decode('utf-8'))['upload_id']
        print("Uploaded file: %s" % fitfile)
    except:
        print("There was an error uploading the file")
        print(traceback.format_exc())
        return False, fitfile
    
    return upload_id, fitfile

def get_upload_status(token, upload_id, filename):
    start_time = time.time()
    while 1:
        
        req = urllib.request.Request("http://www.strava.com/api/v2/upload/status/%s?token=%s" % (upload_id,token))
        res = urllib.request.urlopen(req)

        status = json.loads(res.read().decode('utf-8'))
        
        if "upload_error" in status:
            print("Error on %s: %s" % (filename,status['upload_error']))
            return
        elif status['upload_progress'] == 100:
            
            store_filename(os.path.basename(filename))
        
            print("%s successfully uploaded and processed in %s seconds." % (filename,round(time.time()-start_time,2)))
            return
        
        time.sleep(0.5)
    

def store_filename(filename):
    conn = sqlite3.connect('uploads.sqlite')
    c = conn.cursor()
    result = c.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='uploads';").fetchone()
    if not result:
        c.execute('''create table uploads(filename text)''')

    c.execute("INSERT INTO uploads VALUES (?)" , [filename])
    conn.commit()
    conn.close()
    
def hasbeen_uploaded(filename):
    conn = sqlite3.connect('uploads.sqlite')
    c = conn.cursor()
    try:
        result = c.execute("SELECT filename FROM uploads WHERE filename = ?", [filename]).fetchall()
    except:
        return False
    
    return True
    
 
def upload_fits_dir(dirpath):
    
    skipped = 0
    upload_files = []
    
    fitfiles = glob.glob("%s/*.fit" % dirpath)
 
    for fitfile in fitfiles:
        if not hasbeen_uploaded(os.path.basename(fitfile)):
            upload_files.append(fitfile)
        else:
            skipped +=1
            
    if len(upload_files)>0:
        
        #Only auth if there's something to upload
        token = get_auth_token() 
        
        for fitfile in upload_files:
            upload_id, filename = upload_fit_file(token, fitfile)
            if upload_id:
                thread = threading.Thread(target=get_upload_status, args=(token,upload_id, filename))
                thread.start()
        while threading.activeCount() > 1: # wait for all files to finish processing
            pass
    else: #nothing to upload
        print ("Nothing to upload.")
    
    print ("%s files skipped." % skipped)
           
    
    
"""
This is an infinite loop to continuously check if the Garmin has been plugged in
It probably wastes a lot of cpu cycles so I'm not using it

uploaded=False

while 1:
    try:
        os.stat("R:\\Garmin\\Activities")
        if not uploaded:
            upload_fits_dir("R:\\Garmin\\Activities")
            uploaded = True
        time.sleep(1)
        
    except:
        uploaded=False
        time.sleep(1)
   
"""   

class simpleLogger():
    
    def __init__(self,logfile):
        self.logfile = logfile
        open(logfile,"w").write("") ##clear out any previous contents
    
    def write(self,logtext):
        logfile = open(self.logfile,"a")
        logfile.write(logtext)
        logfile.close()
        return 0
    
    def flush(self):
        return 0

sys.stdout = simpleLogger("output.txt")
 
try:
    os.stat("R:\\Garmin\\Activities")
    upload_fits_dir("R:\\Garmin\\Activities")
except:
    print(traceback.format_exc())
    print("Wrong path or the Garmin isn't plugged in.")
    
win = tkinter.Tk()
win.wm_withdraw()
output = open("output.txt","r").read()
tkinter.messagebox.showinfo("Strava upload status", output)

