buildDeps = {
    "files": [
        # get Bison
        "bison",
        "bison-dev",

        # get libssl
        "libssl1.0.2",

        # get openssl
        "openssl",
        "openssl-dev",

        # get libstdc++ 
        "libstdc++-dev",
        "libstdc++6",

        # get libc
        "libc6",
        "libc6-dev",
        "libc6-extra-nss",
        "linux-libc-headers-dev",
        "libcidn1",

        # get libcrypto
        "libcrypto1.0.2",

        # get acl 
        "acl",
        "acl-dbg",
        "acl-dev",
        "libacl1",

        # get libattr
        "libattr1",

        #get python3
        "libpython3.5m1.0",
        "python3-dev"
    ],
    "links" : [ # tuples of target (links to) and source (the link)
        # create symlink for pthread to pthreads (fixes fastrtps being dumb)
        ("usr/lib/libpthreads.so", "usr/lib/libpthread.so")
    ]

}


deployDeps = {
    "files": [
        # get ssl
        "libssl1.0.2",

        # get openssl
        "openssl",

        # get libcrypto
        "libcrypto1.0.2",

        # get bison
        "bison",

        # get python 3.5
        "libpython3.5m1.0",
        "python3-core",

        # get ACL 
        "acl",
        "libacl1",

        # get libattr
        "libattr1"
    ],
    "links" : [

    ]

}

remoteUrl = "https://download.ni.com/ni-linux-rt/feeds/2021.3/arm/main/cortexa9-vfpv3/"
packageUrl = "https://download.ni.com/ni-linux-rt/feeds/2021.3/arm/main/cortexa9-vfpv3/Packages"

numParallelDownloads = 10

import queue
import urllib.request
import os
import logging
import threading
from queue import Empty, Queue
from datetime import datetime
import shutil
import time
import subprocess
import yaml

def singleDownload(download_url, save_as, local_dir):
    # make sure next item is valid
    try:
        if not download_url or not local_dir or not save_as:
            raise RuntimeError("Missing an argument to download")

        absFileName = os.path.join(local_dir, "downloads", save_as)
        urllib.request.urlretrieve(download_url, filename = absFileName)
        logging.info("Downloaded {} successfully as {}".format(download_url, absFileName))
        return True

    except Exception as e:
        logging.warning("error downloading {} : {}".format(download_url, e))
        return False

def getPackageDef(name, localDir):
    pkgFile = os.path.join(localDir, "downloads", "Packages")
    with open(pkgFile) as packageFile:
        start = -1
        parseData = ""
        for num, line in enumerate(packageFile, 1):
            if(start >= 0):
                parseData += line

            if("Package: {}\n".format(name) == line):
                start = num
                parseData += line
                #print("discovered package def")

            if(start >= 0 and "Priority:" in line):
                data = yaml.safe_load(parseData)
                return data 

            #if("Package: {}\n".format(name) in line):
            #        print("'" + line + "'")
    
    logging.error("error finding package {} in file: {}".format(name, pkgFile))
    return {}
    

class Downloader(threading.Thread):
    def __init__(self, queue):
        super(Downloader, self).__init__()
        self.queue = queue
        self.complete = False

    def run(self):
        try:
            while True:
                download_url, save_as, local_dir = self.queue.get(False)
                singleDownload(download_url, save_as, local_dir)
        except queue.Empty:
            self.complete = True
            return
        except Exception as e:
            logging.warning("error downloading resource: {}".format(e))
            self.run()
        

    def isComplete(self):
        return self.complete

def downloadFiles(names: str, localDir: str, remoteBaseUrl: str = remoteUrl):
    queue = Queue()

    # Make sure downloads dir exists
    if(not os.path.exists(os.path.join(localDir, "downloads"))):
        os.mkdir(os.path.join(localDir, "downloads"))

    # download the index first
    singleDownload(packageUrl, "Packages", localDir)

    for name in names:
        data = getPackageDef(name, localDir)
        #print(data)
        url = remoteBaseUrl + data["Filename"]
        filename = name
        queue.put((url, filename, localDir))

    # Start downloads
    threads = []
    for i in range(numParallelDownloads):
        threads.append(Downloader(queue)) # spawn downloaders
        threads[-1].start()

    # Wait for downloads to complete
    complete = True
    while(not complete):
        complete = True

        for downloader in threads:
            complete = complete and downloader.isComplete()

        time.sleep(0.01)
    
    print("All files downloaded, unarchiving")
    time.sleep(0.5)

    for filename in names:
        try:
            # wait for fs to stabilize
            time.sleep(0.1)

            # rip the ipk open
            # open the ipk and get its contents into the current dir
            archive = os.path.join(localDir, "downloads", filename)
            unpackDir = os.path.join(localDir, "downloads")
            exitCode = subprocess.run(["ar", "x", archive, "--output={}".format(unpackDir)])
            if(not exitCode.returncode == 0):
                raise RuntimeError("ar failed with return code {}".format(exitCode))
            
            # rip the data.tar archive open
            # open it from downloads and dump it into the local dir
            file = os.path.join(localDir, "downloads", "data.tar.xz")
            shutil.unpack_archive(file, localDir, "gztar")

            print("Unarchived {} successfully".format(filename))

        except Exception as e:
            logging.error("error unarchiving {} : {}".format(filename, e))

def makeLinks(links, localDir: str):
    for link in links:
        target = os.path.join(localDir, link[0])
        source = os.path.join(localDir, link[1])
        # print(source)
        # print(os.path.islink(source) , os.path.isfile(source))
        if(not (os.path.islink(source) or os.path.isfile(source))):
            os.symlink(source, target)
        



if __name__ == "__main__":
    # Common vars used in path
    USER_HOME = os.path.expanduser('~')
    YEAR = str(datetime.date(datetime.now()).year)
    ARM_PREFIX = "arm-frc{}-linux-gnueabi".format(YEAR)
    CROSS_ROOT = os.path.join(USER_HOME, "wpilib", YEAR, "roborio", ARM_PREFIX)
    CWD = os.getcwd()

    # download deps into cross root
    print("Downloading CC deps")
    buildDepsDir = CROSS_ROOT
    if(not os.path.exists(buildDepsDir)):
        os.mkdir(buildDepsDir)

    downloadFiles(buildDeps["files"], buildDepsDir)
    makeLinks(buildDeps["links"], buildDepsDir)

    #shutil.register_unpack_format("ipk", [".ipk"], )
    #print(shutil.get_archive_formats())

    print("All CC deps downloaded")


    # download deps for install
    print("Downloading deploy deps")
    deployDepDir = os.path.join(CWD, "extra_libs")
    if(not os.path.exists(deployDepDir)):
        os.mkdir(deployDepDir)
    else:
        shutil.rmtree(deployDepDir)
        os.mkdir(deployDepDir)

    downloadFiles(deployDeps["files"], deployDepDir)
    makeLinks(deployDeps["links"], deployDepDir)
    print("All deploy deps downloaded")

