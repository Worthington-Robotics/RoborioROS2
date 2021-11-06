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
        #"python3-core_3.5.5-r1.0.51_cortexa9-vfpv3.ipk",
        "python3-dev_3.5.5-r1.0.19_cortexa9-vfpv3.ipk"
    ],
    "links" : [ # tuples of target (links to) and source (the link)
        # create symlink for pthread to pthreads (fixes fastrtps being dumb)
        ("lib/libpthread.so.0", "lib/libpthreads.so")
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
        "python3-core_3.5.5-r1.0.51_cortexa9-vfpv3.ipk",
        "python3-dev_3.5.5-r1.0.19_cortexa9-vfpv3.ipk",

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
import tarfile

class Downloader(threading.Thread):
    def __init__(self, queue):
        super(Downloader, self).__init__()
        self.queue = queue
        self.complete = False

    def run(self):
        while True:
            download_url, save_as, local_dir = self.queue.get()
            # sentinal
            if not download_url:
                self.complete = True
                return
            try:
                urllib.urlretrieve(download_url, filename=os.path.join(local_dir, "downloads", save_as))
                logging.info("Downloaded %s sucessfully" % download_url)

            except Exception as e:
                logging.warn("error downloading %s: %s" % (download_url, e))

    def isComplete(self):
        return self.complete

def downloadFiles(names: str, localDir: str, remoteBaseUrl: str = remoteUrl):
    queue = Queue()
    threads = []
    for i in range(numParallelDownloads):
        threads.append(Downloader(queue)) # spawn downloaders
        threads[-1].start()

    for name in names:
        url = remoteBaseUrl + name
        filename = name
        print("Download %s as %s" % (url, filename, localDir))
        queue.put((url, filename))

    for i in range(numParallelDownloads):
        queue.put((None, None))

    # Wait for downloads to complete
    complete = False
    while(not complete):
        for downloader in threads:
            complete = complete or downloader.isComplete()
    
    print("All files downloaded, unarchiving")

    for filename in names:
        try:
            # rip the ipk open
            # open the ipk and get its contents into the current dir
            tar = tarfile.open(os.path.join(localDir, "downloads", filename))
            tar.extractall(path = os.path.join(localDir, "downloads"))
            tar.close()

            # rip the data.tar archive open
            # open it from downloads and dump it into the local dir
            tar = tarfile.open(os.path.join(localDir, "downloads", "data.tar.gz"))
            tar.extractall(path = localDir)
            tar.close()

            logging.info("Unarchived %s sucessfully" % filename)

        except Exception as e:
            logging.warn("error unarchiving %s: %s" % (filename, e))

def makeLinks(links, localDir: str):
    for link in links:
        target = os.path.join(localDir, link[0])
        source = os.path.join(localDir, link[1])
        os.symlink(source, target)
        



if __name__ == "__main__":
    # Common vars used in path
    USER_HOME = print(os.path.expanduser('~'))
    YEAR = str(datetime.date(datetime.now()).year)
    ARM_PREFIX = "arm-frc{}-linux-gnueabi".format(YEAR)
    CROSS_ROOT = os.path.join(USER_HOME, "wpilib", YEAR, "roborio", ARM_PREFIX)
    CWD = os.getcwd()

    # download deps into cross root
    print("Downloading CC deps")
    buildDepsDir = CROSS_ROOT
    if(not os.path.exists(buildDepsDir)):
        os.mkdir(buildDepsDir)
    else:
        shutil.rmtree(buildDepsDir)
        os.mkdir(buildDepsDir)

    downloadFiles(buildDeps.files, buildDepsDir)
    makeLinks(buildDeps.links, buildDepsDir)

    print("All CC deps downloaded")


    # download deps for install
    print("Downloading deploy deps")
    deployDepDir = os.path.join(CWD, "extra_libs")
    if(not os.path.exists(deployDepDir)):
        os.mkdir(deployDepDir)
    else:
        shutil.rmtree(deployDepDir)
        os.mkdir(deployDepDir)

    downloadFiles(deployDeps.files, deployDepDir)
    makeLinks(deployDeps.links, deployDepDir)
    print("All deploy deps downloaded")

