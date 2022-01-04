buildDeps = {
    "files": [
        # get Bison
        "bison_3.0.4-r0.256_cortexa9-vfpv3.ipk",
        "bison-dev_3.0.4-r0.256_cortexa9-vfpv3.ipk",

        # get libssl
        "libssl1.0.2_1.0.2o-r0.16_cortexa9-vfpv3.ipk",

        # get openssl
        "openssl_1.0.2o-r0.16_cortexa9-vfpv3.ipk",
        "openssl-dev_1.0.2o-r0.16_cortexa9-vfpv3.ipk",

        # get libstdc++ 
        "libstdc++-dev_7.3.0-r0.16_cortexa9-vfpv3.ipk",
        "libstdc++6_7.3.0-r0.16_cortexa9-vfpv3.ipk",

        # get libc
        "libc6_2.24-r0.79_cortexa9-vfpv3.ipk",
        "libc6-dev_2.24-r0.79_cortexa9-vfpv3.ipk",
        "libc6-extra-nss_2.24-r0.79_cortexa9-vfpv3.ipk",
        "linux-libc-headers-dev_4.15.7-r0.13_cortexa9-vfpv3.ipk",
        "libcidn1_2.24-r0.79_cortexa9-vfpv3.ipk",

        # get libcrypto
        "libcrypto1.0.2_1.0.2o-r0.16_cortexa9-vfpv3.ipk",

        # get acl 
        "acl_2.2.52-r0.183_cortexa9-vfpv3.ipk",
        "acl-dbg_2.2.52-r0.183_cortexa9-vfpv3.ipk",
        "acl-dev_2.2.52-r0.183_cortexa9-vfpv3.ipk",
        "libacl1_2.2.52-r0.183_cortexa9-vfpv3.ipk",

        # get libattr
        "libattr1_2.4.47-r0.513_cortexa9-vfpv3.ipk",

        #get python3
        "libpython3.5m1.0_3.5.5-r1.0.19_cortexa9-vfpv3.ipk",
        "python3-dev_3.5.5-r1.0.19_cortexa9-vfpv3.ipk"
    ],
    "links" : [ # tuples of target (links to) and source (the link)
        # create symlink for pthread to pthreads (fixes fastrtps being dumb)
        ("usr/lib/libpthreads.so", "usr/lib/libpthread.so")
    ]

}


deployDeps = {
    "files": [
        # get ssl
        "libssl1.0.2_1.0.2o-r0.16_cortexa9-vfpv3.ipk",

        # get openssl
        "openssl_1.0.2o-r0.16_cortexa9-vfpv3.ipk",

        # get libcrypto
        "libcrypto1.0.2_1.0.2o-r0.16_cortexa9-vfpv3.ipk",

        # get bison
        "bison_3.0.4-r0.256_cortexa9-vfpv3.ipk",

        # get python 3.5
        "libpython3.5m1.0_3.5.5-r1.0.19_cortexa9-vfpv3.ipk",
        "python3-core_3.5.5-r1.0.19_cortexa9-vfpv3.ipk",

        # get ACL 
        "acl_2.2.52-r0.183_cortexa9-vfpv3.ipk",
        "libacl1_2.2.52-r0.183_cortexa9-vfpv3.ipk",

        # get libattr
        "libattr1_2.4.47-r0.513_cortexa9-vfpv3.ipk"
    ],
    "links" : [

    ]

}


remoteUrl = "https://download.ni.com/ni-linux-rt/feeds/2019/arm/cortexa9-vfpv3/"

numParallelDownloads = 10

import urllib.request
import os
import logging
import threading
from queue import Queue
from datetime import datetime
import shutil
import time
import subprocess

class Downloader(threading.Thread):
    def __init__(self, queue):
        super(Downloader, self).__init__()
        self.queue = queue
        self.complete = False

    def run(self):
        while True:
            download_url, save_as, local_dir = self.queue.get()
            
            # make sure next item is valid
            if not download_url:
                self.complete = True
                return
            try:
                urllib.request.urlretrieve(download_url, filename=os.path.join(local_dir, "downloads", save_as))
                logging.info("Downloaded {} successfully".format(download_url))

            except Exception as e:
                logging.warning("error downloading {} : {}".format(download_url, e))

    def isComplete(self):
        return self.complete

def downloadFiles(names: str, localDir: str, remoteBaseUrl: str = remoteUrl):
    queue = Queue()
    threads = []
    for i in range(numParallelDownloads):
        threads.append(Downloader(queue)) # spawn downloaders
        threads[-1].start()

    # Make sure downloads dir exists
    if(not os.path.exists(os.path.join(localDir, "downloads"))):
        os.mkdir(os.path.join(localDir, "downloads"))

    for name in names:
        url = remoteBaseUrl + name
        filename = name
        print("Downloading {} as {}".format(url, filename))
        queue.put((url, filename, localDir))

    for i in range(numParallelDownloads):
        queue.put((None, None, None))

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
            file = os.path.join(localDir, "downloads", "data.tar.gz")
            shutil.unpack_archive(file, localDir, "gztar")

            print("Unarchived {} successfully".format(filename))

        except Exception as e:
            logging.warning("error unarchiving {} : {}".format(filename, e))

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
    #TODO Remove the -1 on the year once wpilib releases full 2022
    YEAR = str(datetime.date(datetime.now()).year -1) # temporary hack because we haven't gotten the season release for 22
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

