Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282487664E
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 14:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfGZMvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 08:51:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbfGZMvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 08:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LHyIWQvDsMZWRcGvX09jsvvX6ILWhJom8p9hWq7/d4M=; b=hLbLCbq46YJSmRSkD4w+x5pg7K
        lAXU8WkXua8bipdG7tCE0jiTdm88JfOd8Oi1G6s0qA9PgwEvQZv230p2z/HX86nzpLDWDsgXwCxrh
        qemGWu73U843BsVoVi2UNq9m9gUuQ2HJKLJC3dBy6ZwJu8xYl5wMZk7ReSuqc96B+QTCymjVYRJTz
        EQ5VP84Lhv0DTf3NUyEwlcXNc2WIzirS/ljnerEPCeL4z+stfy2tpcXEUAlP5mTeT/qKy73Y5tUIZ
        3p7RhU6wkw8CAk5CbnStmSQ58trrFmyD1AaF3s4Z6+Ju7SW8lEkDiJ7q1/UkY8hBA3tbsf8m4BPaJ
        zqmVwRzA==;
Received: from [179.95.31.157] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hqzhE-0006AX-I7; Fri, 26 Jul 2019 12:51:41 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hqzhC-0005b6-A9; Fri, 26 Jul 2019 09:51:38 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karsten Keil <isdn@linux-pingi.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v2 15/26] docs: isdn: convert to ReST and add to kAPI bookset
Date:   Fri, 26 Jul 2019 09:51:25 -0300
Message-Id: <d5d05c654679990ce2c7ed3b69c355d2e5ab9fab.1564145354.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1564145354.git.mchehab+samsung@kernel.org>
References: <cover.1564145354.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ISDN documentation is a mix of admin guide, uAPI and kAPI.

Ideally, it should be split. Yet, not sure if it would worth
the troble. Anyway, we have the same kind of mix on several
drivers specific documentation. So, just like the others, keep
the directory at the root Documentation/ tree, just adding a
pointer to it at the kAPI section, as the documentation was
written with the Kernel developers in mind.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/index.rst                       |   1 +
 .../isdn/{README.avmb1 => avmb1.rst}          | 231 ++++++++------
 Documentation/isdn/{CREDITS => credits.rst}   |   7 +-
 .../isdn/{README.gigaset => gigaset.rst}      | 290 +++++++++++-------
 .../isdn/{README.hysdn => hysdn.rst}          | 125 ++++----
 Documentation/isdn/index.rst                  |  24 ++
 .../{INTERFACE.CAPI => interface_capi.rst}    | 182 +++++++----
 .../isdn/{README.mISDN => m_isdn.rst}         |   5 +-
 drivers/staging/isdn/hysdn/Kconfig            |   2 +-
 9 files changed, 536 insertions(+), 331 deletions(-)
 rename Documentation/isdn/{README.avmb1 => avmb1.rst} (50%)
 rename Documentation/isdn/{CREDITS => credits.rst} (96%)
 rename Documentation/isdn/{README.gigaset => gigaset.rst} (74%)
 rename Documentation/isdn/{README.hysdn => hysdn.rst} (80%)
 create mode 100644 Documentation/isdn/index.rst
 rename Documentation/isdn/{INTERFACE.CAPI => interface_capi.rst} (75%)
 rename Documentation/isdn/{README.mISDN => m_isdn.rst} (89%)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 6402f62ac90f..de7be1c31450 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -106,6 +106,7 @@ needed).
    hid/index
    i2c/index
    iio/index
+   isdn/index
    infiniband/index
    leds/index
    media/index
diff --git a/Documentation/isdn/README.avmb1 b/Documentation/isdn/avmb1.rst
similarity index 50%
rename from Documentation/isdn/README.avmb1
rename to Documentation/isdn/avmb1.rst
index 9e075484ef1e..de3961e67553 100644
--- a/Documentation/isdn/README.avmb1
+++ b/Documentation/isdn/avmb1.rst
@@ -1,4 +1,6 @@
-Driver for active AVM Controller.
+================================
+Driver for active AVM Controller
+================================
 
 The driver provides a kernel capi2.0 Interface (kernelcapi) and
 on top of this a User-Level-CAPI2.0-interface (capi)
@@ -11,25 +13,28 @@ The command avmcapictrl is part of the isdn4k-utils.
 t4-files can be found at ftp://ftp.avm.de/cardware/b1/linux/firmware
 
 Currently supported cards:
-	B1 ISA (all versions)
-	B1 PCI
-	T1/T1B (HEMA card)
-	M1
-	M2
-	B1 PCMCIA
+
+	- B1 ISA (all versions)
+	- B1 PCI
+	- T1/T1B (HEMA card)
+	- M1
+	- M2
+	- B1 PCMCIA
 
 Installing
 ----------
 
 You need at least /dev/capi20 to load the firmware.
 
-mknod /dev/capi20 c 68 0
-mknod /dev/capi20.00 c 68 1
-mknod /dev/capi20.01 c 68 2
-.
-.
-.
-mknod /dev/capi20.19 c 68 20
+::
+
+    mknod /dev/capi20 c 68 0
+    mknod /dev/capi20.00 c 68 1
+    mknod /dev/capi20.01 c 68 2
+    .
+    .
+    .
+    mknod /dev/capi20.19 c 68 20
 
 Running
 -------
@@ -38,45 +43,58 @@ To use the card you need the t4-files to download the firmware.
 AVM GmbH provides several t4-files for the different D-channel
 protocols (b1.t4 for Euro-ISDN). Install these file in /lib/isdn.
 
-if you configure as modules load the modules this way:
-
-insmod /lib/modules/current/misc/capiutil.o
-insmod /lib/modules/current/misc/b1.o
-insmod /lib/modules/current/misc/kernelcapi.o
-insmod /lib/modules/current/misc/capidrv.o
-insmod /lib/modules/current/misc/capi.o
-
-if you have an B1-PCI card load the module b1pci.o
-insmod /lib/modules/current/misc/b1pci.o
-and load the firmware with
-avmcapictrl load /lib/isdn/b1.t4 1
+if you configure as modules load the modules this way::
+
+    insmod /lib/modules/current/misc/capiutil.o
+    insmod /lib/modules/current/misc/b1.o
+    insmod /lib/modules/current/misc/kernelcapi.o
+    insmod /lib/modules/current/misc/capidrv.o
+    insmod /lib/modules/current/misc/capi.o
+
+if you have an B1-PCI card load the module b1pci.o::
+
+    insmod /lib/modules/current/misc/b1pci.o
+
+and load the firmware with::
+
+    avmcapictrl load /lib/isdn/b1.t4 1
 
 if you have an B1-ISA card load the module b1isa.o
-and add the card by calling
-avmcapictrl add 0x150 15
-and load the firmware by calling
-avmcapictrl load /lib/isdn/b1.t4 1
+and add the card by calling::
+
+    avmcapictrl add 0x150 15
+
+and load the firmware by calling::
+
+    avmcapictrl load /lib/isdn/b1.t4 1
 
 if you have an T1-ISA card load the module t1isa.o
-and add the card by calling
-avmcapictrl add 0x450 15 T1 0
-and load the firmware by calling
-avmcapictrl load /lib/isdn/t1.t4 1
+and add the card by calling::
+
+    avmcapictrl add 0x450 15 T1 0
+
+and load the firmware by calling::
+
+    avmcapictrl load /lib/isdn/t1.t4 1
 
 if you have an PCMCIA card (B1/M1/M2) load the module b1pcmcia.o
 before you insert the card.
 
 Leased Lines with B1
 --------------------
+
 Init card and load firmware.
+
 For an D64S use "FV: 1" as phone number
+
 For an D64S2 use "FV: 1" and "FV: 2" for multilink
 or "FV: 1,2" to use CAPI channel bundling.
 
 /proc-Interface
 -----------------
 
-/proc/capi:
+/proc/capi::
+
   dr-xr-xr-x   2 root     root            0 Jul  1 14:03 .
   dr-xr-xr-x  82 root     root            0 Jun 30 19:08 ..
   -r--r--r--   1 root     root            0 Jul  1 14:03 applications
@@ -91,84 +109,124 @@ or "FV: 1,2" to use CAPI channel bundling.
 
 /proc/capi/applications:
    applid level3cnt datablkcnt datablklen ncci-cnt recvqueuelen
-	level3cnt: capi_register parameter
-	datablkcnt: capi_register parameter
-	ncci-cnt: current number of nccis (connections)
-	recvqueuelen: number of messages on receive queue
-   for example:
-1 -2 16 2048 1 0
-2 2 7 2048 1 0
+	level3cnt:
+	    capi_register parameter
+	datablkcnt:
+	    capi_register parameter
+	ncci-cnt:
+	    current number of nccis (connections)
+	recvqueuelen:
+	    number of messages on receive queue
+
+   for example::
+
+	1 -2 16 2048 1 0
+	2 2 7 2048 1 0
 
 /proc/capi/applstats:
    applid recvctlmsg nrecvdatamsg nsentctlmsg nsentdatamsg
-	recvctlmsg: capi messages received without DATA_B3_IND
-	recvdatamsg: capi DATA_B3_IND received
-	sentctlmsg: capi messages sent without DATA_B3_REQ
-	sentdatamsg: capi DATA_B3_REQ sent
-   for example:
-1 2057 1699 1721 1699
+	recvctlmsg:
+	    capi messages received without DATA_B3_IND
+	recvdatamsg:
+	    capi DATA_B3_IND received
+	sentctlmsg:
+	    capi messages sent without DATA_B3_REQ
+	sentdatamsg:
+	    capi DATA_B3_REQ sent
+
+   for example::
+
+	1 2057 1699 1721 1699
 
 /proc/capi/capi20: statistics of capi.o (/dev/capi20)
     minor nopen nrecvdropmsg nrecvctlmsg nrecvdatamsg sentctlmsg sentdatamsg
-	minor: minor device number of capi device
-	nopen: number of calls to devices open
-	nrecvdropmsg: capi messages dropped (messages in recvqueue in close)
-	nrecvctlmsg: capi messages received without DATA_B3_IND
-	nrecvdatamsg: capi DATA_B3_IND received
-	nsentctlmsg: capi messages sent without DATA_B3_REQ
-	nsentdatamsg: capi DATA_B3_REQ sent
+	minor:
+	    minor device number of capi device
+	nopen:
+	    number of calls to devices open
+	nrecvdropmsg:
+	    capi messages dropped (messages in recvqueue in close)
+	nrecvctlmsg:
+	    capi messages received without DATA_B3_IND
+	nrecvdatamsg:
+	    capi DATA_B3_IND received
+	nsentctlmsg:
+	    capi messages sent without DATA_B3_REQ
+	nsentdatamsg:
+	    capi DATA_B3_REQ sent
 
-   for example:
-1 2 18 0 16 2
+   for example::
+
+	1 2 18 0 16 2
 
 /proc/capi/capidrv: statistics of capidrv.o (capi messages)
     nrecvctlmsg nrecvdatamsg sentctlmsg sentdatamsg
-	nrecvctlmsg: capi messages received without DATA_B3_IND
-	nrecvdatamsg: capi DATA_B3_IND received
-	nsentctlmsg: capi messages sent without DATA_B3_REQ
-	nsentdatamsg: capi DATA_B3_REQ sent
+	nrecvctlmsg:
+	    capi messages received without DATA_B3_IND
+	nrecvdatamsg:
+	    capi DATA_B3_IND received
+	nsentctlmsg:
+	    capi messages sent without DATA_B3_REQ
+	nsentdatamsg:
+	    capi DATA_B3_REQ sent
+
    for example:
-2780 2226 2256 2226
+	2780 2226 2256 2226
 
 /proc/capi/controller:
    controller drivername state cardname   controllerinfo
-   for example:
-1 b1pci      running  b1pci-e000       B1 3.07-01 0xe000 19
-2 t1isa      running  t1isa-450        B1 3.07-01 0x450 11 0
-3 b1pcmcia   running  m2-150           B1 3.07-01 0x150 5
+
+   for example::
+
+	1 b1pci      running  b1pci-e000       B1 3.07-01 0xe000 19
+	2 t1isa      running  t1isa-450        B1 3.07-01 0x450 11 0
+	3 b1pcmcia   running  m2-150           B1 3.07-01 0x150 5
 
 /proc/capi/contrstats:
     controller nrecvctlmsg nrecvdatamsg sentctlmsg sentdatamsg
-	nrecvctlmsg: capi messages received without DATA_B3_IND
-	nrecvdatamsg: capi DATA_B3_IND received
-	nsentctlmsg: capi messages sent without DATA_B3_REQ
-	nsentdatamsg: capi DATA_B3_REQ sent
-   for example:
-1 2845 2272 2310 2274
-2 2 0 2 0
-3 2 0 2 0
+	nrecvctlmsg:
+	    capi messages received without DATA_B3_IND
+	nrecvdatamsg:
+	    capi DATA_B3_IND received
+	nsentctlmsg:
+	    capi messages sent without DATA_B3_REQ
+	nsentdatamsg:
+	    capi DATA_B3_REQ sent
+
+   for example::
+
+	1 2845 2272 2310 2274
+	2 2 0 2 0
+	3 2 0 2 0
 
 /proc/capi/driver:
    drivername ncontroller
-   for example:
-b1pci                            1
-t1isa                            1
-b1pcmcia                         1
-b1isa                            0
+
+   for example::
+
+	b1pci                            1
+	t1isa                            1
+	b1pcmcia                         1
+	b1isa                            0
 
 /proc/capi/ncci:
    apllid ncci winsize sendwindow
-   for example:
-1 0x10101 8 0
+
+   for example::
+
+	1 0x10101 8 0
 
 /proc/capi/users: kernelmodules that use the kernelcapi.
    name
-   for example:
-capidrv
-capi20
+
+   for example::
+
+	capidrv
+	capi20
 
 Questions
 ---------
+
 Check out the FAQ (ftp.isdn4linux.de) or subscribe to the
 linux-avmb1@calle.in-berlin.de mailing list by sending
 a mail to majordomo@calle.in-berlin.de with
@@ -178,9 +236,10 @@ in the body.
 German documentation and several scripts can be found at
 ftp://ftp.avm.de/cardware/b1/linux/
 
-Bugs 
+Bugs
 ----
-If you find any please let me know. 
+
+If you find any please let me know.
 
 Enjoy,
 
diff --git a/Documentation/isdn/CREDITS b/Documentation/isdn/credits.rst
similarity index 96%
rename from Documentation/isdn/CREDITS
rename to Documentation/isdn/credits.rst
index c1679e913fca..319323f2091f 100644
--- a/Documentation/isdn/CREDITS
+++ b/Documentation/isdn/credits.rst
@@ -1,3 +1,7 @@
+=======
+Credits
+=======
+
 
 I want to thank all who contributed to this project and especially to:
 (in alphabetical order)
@@ -19,7 +23,7 @@ Matthias Hessler (hessler@isdn4linux.de)
   For creating and maintaining the FAQ.
 
 Bernhard Hailer (Bernhard.Hailer@lrz.uni-muenchen.de)
-  For creating the FAQ, and the leafsite HOWTO. 
+  For creating the FAQ, and the leafsite HOWTO.
 
 Michael 'Ghandi' Herold (michael@abadonna.franken.de)
   For contribution of the vbox answering machine.
@@ -67,4 +71,3 @@ Gerhard 'Fido' Schneider (fido@wuff.mayn.de)
 Thomas Uhl (uhl@think.de)
   For distributing the cards.
   For pushing me to work ;-)
-
diff --git a/Documentation/isdn/README.gigaset b/Documentation/isdn/gigaset.rst
similarity index 74%
rename from Documentation/isdn/README.gigaset
rename to Documentation/isdn/gigaset.rst
index f6184b637182..98b4ec521c51 100644
--- a/Documentation/isdn/README.gigaset
+++ b/Documentation/isdn/gigaset.rst
@@ -1,33 +1,36 @@
+==========================
 GigaSet 307x Device Driver
 ==========================
 
 1.   Requirements
-     ------------
+=================
+
 1.1. Hardware
-     --------
+-------------
+
      This driver supports the connection of the Gigaset 307x/417x family of
      ISDN DECT bases via Gigaset M101 Data, Gigaset M105 Data or direct USB
      connection. The following devices are reported to be compatible:
 
      Bases:
-        Siemens Gigaset 3070/3075 isdn
-        Siemens Gigaset 4170/4175 isdn
-        Siemens Gigaset SX205/255
-        Siemens Gigaset SX353
-        T-Com Sinus 45 [AB] isdn
-        T-Com Sinus 721X[A] [SE]
-        Vox Chicago 390 ISDN (KPN Telecom)
+       - Siemens Gigaset 3070/3075 isdn
+       - Siemens Gigaset 4170/4175 isdn
+       - Siemens Gigaset SX205/255
+       - Siemens Gigaset SX353
+       - T-Com Sinus 45 [AB] isdn
+       - T-Com Sinus 721X[A] [SE]
+       - Vox Chicago 390 ISDN (KPN Telecom)
 
      RS232 data boxes:
-        Siemens Gigaset M101 Data
-        T-Com Sinus 45 Data 1
+       - Siemens Gigaset M101 Data
+       - T-Com Sinus 45 Data 1
 
      USB data boxes:
-        Siemens Gigaset M105 Data
-        Siemens Gigaset USB Adapter DECT
-        T-Com Sinus 45 Data 2
-        T-Com Sinus 721 data
-        Chicago 390 USB (KPN)
+       - Siemens Gigaset M105 Data
+       - Siemens Gigaset USB Adapter DECT
+       - T-Com Sinus 45 Data 2
+       - T-Com Sinus 721 data
+       - Chicago 390 USB (KPN)
 
      See also http://www.erbze.info/sinus_gigaset.htm
        (archived at https://web.archive.org/web/20100717020421/http://www.erbze.info:80/sinus_gigaset.htm ) and
@@ -37,17 +40,21 @@ GigaSet 307x Device Driver
      with SX 100 and CX 100 ISDN bases (only in unimodem mode, see section 2.5.)
      If you have another device that works with our driver, please let us know.
 
-     Chances of getting an USB device to work are good if the output of
-        lsusb
-     at the command line contains one of the following:
-        ID 0681:0001
-        ID 0681:0002
-        ID 0681:0009
-        ID 0681:0021
-        ID 0681:0022
+     Chances of getting an USB device to work are good if the output of::
+
+	lsusb
+
+     at the command line contains one of the following::
+
+	ID 0681:0001
+	ID 0681:0002
+	ID 0681:0009
+	ID 0681:0021
+	ID 0681:0022
 
 1.2. Software
-     --------
+-------------
+
      The driver works with the Kernel CAPI subsystem and can be used with any
      software which is able to use CAPI 2.0 for ISDN connections (voice or data).
 
@@ -58,9 +65,11 @@ GigaSet 307x Device Driver
 
 
 2.   How to use the driver
-     ---------------------
+==========================
+
 2.1. Modules
-     -------
+------------
+
      For the devices to work, the proper kernel modules have to be loaded.
      This normally happens automatically when the system detects the USB
      device (base, M105) or when the line discipline is attached (M101). It
@@ -71,13 +80,17 @@ GigaSet 307x Device Driver
      which uses the regular serial port driver to access the device, and must
      therefore be attached to the serial device to which the M101 is connected.
      The ldattach(8) command (included in util-linux-ng release 2.14 or later)
-     can be used for that purpose, for example:
+     can be used for that purpose, for example::
+
 	ldattach GIGASET_M101 /dev/ttyS1
+
      This will open the device file, attach the line discipline to it, and
      then sleep in the background, keeping the device open so that the line
      discipline remains active. To deactivate it, kill the daemon, for example
-     with
+     with::
+
 	killall ldattach
+
      before disconnecting the device. To have this happen automatically at
      system startup/shutdown on an LSB compatible system, create and activate
      an appropriate LSB startup script /etc/init.d/gigaset. (The init name
@@ -86,9 +99,10 @@ GigaSet 307x Device Driver
 
      The modules accept the following parameters:
 
-	Module	 	Parameter  Meaning
+	=============== ========== ==========================================
+	Module		Parameter  Meaning
 
-	gigaset	 	debug	   debug level (see section 3.2.)
+	gigaset		debug	   debug level (see section 3.2.)
 
 			startmode  initial operation mode (see section 2.5.):
 	bas_gigaset )		   1=CAPI (default), 0=Unimodem
@@ -96,11 +110,14 @@ GigaSet 307x Device Driver
 	usb_gigaset )	cidmode    initial Call-ID mode setting (see section
 				   2.5.): 1=on (default), 0=off
 
+	=============== ========== ==========================================
+
      Depending on your distribution you may want to create a separate module
      configuration file like /etc/modprobe.d/gigaset.conf for these.
 
 2.2. Device nodes for user space programs
-     ------------------------------------
+-----------------------------------------
+
      The device can be accessed from user space (eg. by the user space tools
      mentioned in 1.2.) through the device nodes:
 
@@ -113,46 +130,56 @@ GigaSet 307x Device Driver
 
      You can also set a "default device" for the user space tools to use when
      no device node is given as parameter, by creating a symlink /dev/ttyG to
-     one of them, eg.:
+     one of them, eg.::
 
 	ln -s /dev/ttyGB0 /dev/ttyG
 
      The devices accept the following device specific ioctl calls
      (defined in gigaset_dev.h):
 
-     ioctl(int fd, GIGASET_REDIR, int *cmd);
+     ``ioctl(int fd, GIGASET_REDIR, int *cmd);``
+
      If cmd==1, the device is set to be controlled exclusively through the
      character device node; access from the ISDN subsystem is blocked.
+
      If cmd==0, the device is set to be used from the ISDN subsystem and does
      not communicate through the character device node.
 
-     ioctl(int fd, GIGASET_CONFIG, int *cmd);
+     ``ioctl(int fd, GIGASET_CONFIG, int *cmd);``
+
      (ser_gigaset and usb_gigaset only)
+
      If cmd==1, the device is set to adapter configuration mode where commands
      are interpreted by the M10x DECT adapter itself instead of being
      forwarded to the base station. In this mode, the device accepts the
      commands described in Siemens document "AT-Kommando Alignment M10x Data"
      for setting the operation mode, associating with a base station and
      querying parameters like field strengh and signal quality.
+
      Note that there is no ioctl command for leaving adapter configuration
      mode and returning to regular operation. In order to leave adapter
      configuration mode, write the command ATO to the device.
 
-     ioctl(int fd, GIGASET_BRKCHARS, unsigned char brkchars[6]);
+     ``ioctl(int fd, GIGASET_BRKCHARS, unsigned char brkchars[6]);``
+
      (usb_gigaset only)
+
      Set the break characters on an M105's internal serial adapter to the six
      bytes stored in brkchars[]. Unused bytes should be set to zero.
 
      ioctl(int fd, GIGASET_VERSION, unsigned version[4]);
      Retrieve version information from the driver. version[0] must be set to
      one of:
+
      - GIGVER_DRIVER: retrieve driver version
      - GIGVER_COMPAT: retrieve interface compatibility version
      - GIGVER_FWBASE: retrieve the firmware version of the base
+
      Upon return, version[] is filled with the requested version information.
 
 2.3. CAPI
-     ----
+---------
+
      The devices will show up as CAPI controllers as soon as the
      corresponding driver module is loaded, and can then be used with
      CAPI 2.0 kernel and user space applications. For user space access,
@@ -165,21 +192,22 @@ GigaSet 307x Device Driver
      driver.
 
 2.5. Unimodem mode
-     -------------
+------------------
+
      In this mode the device works like a modem connected to a serial port
-     (the /dev/ttyGU0, ... mentioned above) which understands the commands
+     (the /dev/ttyGU0, ... mentioned above) which understands the commands::
 
-         ATZ                 init, reset
-             => OK or ERROR
-         ATD
-         ATDT                dial
-             => OK, CONNECT,
-                BUSY,
-                NO DIAL TONE,
-                NO CARRIER,
-                NO ANSWER
-         <pause>+++<pause>   change to command mode when connected
-         ATH                 hangup
+	 ATZ                 init, reset
+	     => OK or ERROR
+	 ATD
+	 ATDT                dial
+	     => OK, CONNECT,
+		BUSY,
+		NO DIAL TONE,
+		NO CARRIER,
+		NO ANSWER
+	 <pause>+++<pause>   change to command mode when connected
+	 ATH                 hangup
 
      You can use some configuration tool of your distribution to configure this
      "modem" or configure pppd/wvdial manually. There are some example ppp
@@ -189,40 +217,52 @@ GigaSet 307x Device Driver
      control lines. This means you must use "Stupid Mode" if you are using
      wvdial or you should use the nocrtscts option of pppd.
      You must also assure that the ppp_async module is loaded with the parameter
-     flag_time=0. You can do this e.g. by adding a line like
+     flag_time=0. You can do this e.g. by adding a line like::
 
-        options ppp_async flag_time=0
+	options ppp_async flag_time=0
 
-     to an appropriate module configuration file, like
-     /etc/modprobe.d/gigaset.conf.
+     to an appropriate module configuration file, like::
+
+	/etc/modprobe.d/gigaset.conf.
 
      Unimodem mode is needed for making some devices [e.g. SX100] work which
      do not support the regular Gigaset command set. If debug output (see
-     section 3.2.) shows something like this when dialing:
-         CMD Received: ERROR
-         Available Params: 0
-         Connection State: 0, Response: -1
-         gigaset_process_response: resp_code -1 in ConState 0 !
-         Timeout occurred
+     section 3.2.) shows something like this when dialing::
+
+	 CMD Received: ERROR
+	 Available Params: 0
+	 Connection State: 0, Response: -1
+	 gigaset_process_response: resp_code -1 in ConState 0 !
+	 Timeout occurred
+
      then switching to unimodem mode may help.
 
      If you have installed the command line tool gigacontr, you can enter
-     unimodem mode using
-         gigacontr --mode unimodem
-     You can switch back using
-         gigacontr --mode isdn
+     unimodem mode using::
+
+	 gigacontr --mode unimodem
+
+     You can switch back using::
+
+	 gigacontr --mode isdn
 
      You can also put the driver directly into Unimodem mode when it's loaded,
      by passing the module parameter startmode=0 to the hardware specific
-     module, e.g.
+     module, e.g.::
+
 	modprobe usb_gigaset startmode=0
-     or by adding a line like
+
+     or by adding a line like::
+
 	options usb_gigaset startmode=0
-     to an appropriate module configuration file, like
-     /etc/modprobe.d/gigaset.conf
+
+     to an appropriate module configuration file, like::
+
+	/etc/modprobe.d/gigaset.conf
 
 2.6. Call-ID (CID) mode
-     ------------------
+-----------------------
+
      Call-IDs are numbers used to tag commands to, and responses from, the
      Gigaset base in order to support the simultaneous handling of multiple
      ISDN calls. Their use can be enabled ("CID mode") or disabled ("Unimodem
@@ -238,6 +278,7 @@ GigaSet 307x Device Driver
      During active operation, the driver switches to the necessary mode
      automatically. However, for the reasons above, the mode chosen when
      the device is not in use (idle) can be selected by the user.
+
      - If you want to receive incoming calls, you can use the default
        settings (CID mode).
      - If you have several DECT data devices (M10x) which you want to use
@@ -247,25 +288,27 @@ GigaSet 307x Device Driver
      If you want both of these at once, you are out of luck.
 
      You can also use the tty class parameter "cidmode" of the device to
-     change its CID mode while the driver is loaded, eg.
-        echo 0 > /sys/class/tty/ttyGU0/cidmode
+     change its CID mode while the driver is loaded, eg.::
+
+	echo 0 > /sys/class/tty/ttyGU0/cidmode
 
 2.7. Dialing Numbers
-     ---------------
-     The called party number provided by an application for dialing out must
+--------------------
+provided by an application for dialing out must
      be a public network number according to the local dialing plan, without
      any dial prefix for getting an outside line.
 
      Internal calls can be made by providing an internal extension number
-     prefixed with "**" (two asterisks) as the called party number. So to dial
-     eg. the first registered DECT handset, give "**11" as the called party
-     number. Dialing "***" (three asterisks) calls all extensions
+     prefixed with ``**`` (two asterisks) as the called party number. So to dial
+     eg. the first registered DECT handset, give ``**11`` as the called party
+     number. Dialing ``***`` (three asterisks) calls all extensions
      simultaneously (global call).
 
      Unimodem mode does not support internal calls.
 
 2.8. Unregistered Wireless Devices (M101/M105)
-     -----------------------------------------
+----------------------------------------------
+
      The main purpose of the ser_gigaset and usb_gigaset drivers is to allow
      the M101 and M105 wireless devices to be used as ISDN devices for ISDN
      connections through a Gigaset base. Therefore they assume that the device
@@ -279,73 +322,91 @@ GigaSet 307x Device Driver
      modes. See the gigacontr(8) manpage for details.
 
 3.   Troubleshooting
-     ---------------
+====================
+
 3.1. Solutions to frequently reported problems
-     -----------------------------------------
+----------------------------------------------
+
      Problem:
-        You have a slow provider and isdn4linux gives up dialing too early.
+	You have a slow provider and isdn4linux gives up dialing too early.
      Solution:
-        Load the isdn module using the dialtimeout option. You can do this e.g.
-        by adding a line like
+	Load the isdn module using the dialtimeout option. You can do this e.g.
+	by adding a line like::
 
-           options isdn dialtimeout=15
+	   options isdn dialtimeout=15
 
-        to /etc/modprobe.d/gigaset.conf or a similar file.
+	to /etc/modprobe.d/gigaset.conf or a similar file.
 
      Problem:
-        The isdnlog program emits error messages or just doesn't work.
+	The isdnlog program emits error messages or just doesn't work.
      Solution:
-        Isdnlog supports only the HiSax driver. Do not attempt to use it with
+	Isdnlog supports only the HiSax driver. Do not attempt to use it with
 	other drivers such as Gigaset.
 
      Problem:
-        You have two or more DECT data adapters (M101/M105) and only the
-        first one you turn on works.
+	You have two or more DECT data adapters (M101/M105) and only the
+	first one you turn on works.
      Solution:
-        Select Unimodem mode for all DECT data adapters. (see section 2.5.)
+	Select Unimodem mode for all DECT data adapters. (see section 2.5.)
 
      Problem:
-	Messages like this:
+	Messages like this::
+
 	    usb_gigaset 3-2:1.0: Could not initialize the device.
+
 	appear in your syslog.
      Solution:
 	Check whether your M10x wireless device is correctly registered to the
 	Gigaset base. (see section 2.7.)
 
 3.2. Telling the driver to provide more information
-     ----------------------------------------------
+---------------------------------------------------
      Building the driver with the "Gigaset debugging" kernel configuration
      option (CONFIG_GIGASET_DEBUG) gives it the ability to produce additional
      information useful for debugging.
 
      You can control the amount of debugging information the driver produces by
-     writing an appropriate value to /sys/module/gigaset/parameters/debug, e.g.
-        echo 0 > /sys/module/gigaset/parameters/debug
+     writing an appropriate value to /sys/module/gigaset/parameters/debug,
+     e.g.::
+
+	echo 0 > /sys/module/gigaset/parameters/debug
+
      switches off debugging output completely,
-        echo 0x302020 > /sys/module/gigaset/parameters/debug
+
+     ::
+
+	echo 0x302020 > /sys/module/gigaset/parameters/debug
+
      enables a reasonable set of debugging output messages. These values are
      bit patterns where every bit controls a certain type of debugging output.
      See the constants DEBUG_* in the source file gigaset.h for details.
 
      The initial value can be set using the debug parameter when loading the
-     module "gigaset", e.g. by adding a line
-        options gigaset debug=0
+     module "gigaset", e.g. by adding a line::
+
+	options gigaset debug=0
+
      to your module configuration file, eg. /etc/modprobe.d/gigaset.conf
 
      Generated debugging information can be found
-     - as output of the command
-         dmesg
+     - as output of the command::
+
+	 dmesg
+
      - in system log files written by your syslog daemon, usually
        in /var/log/, e.g. /var/log/messages.
 
 3.3. Reporting problems and bugs
-     ---------------------------
+--------------------------------
      If you can't solve problems with the driver on your own, feel free to
      use one of the forums, bug trackers, or mailing lists on
-         https://sourceforge.net/projects/gigaset307x
+
+	 https://sourceforge.net/projects/gigaset307x
+
      or write an electronic mail to the maintainers.
 
      Try to provide as much information as possible, such as
+
      - distribution
      - kernel version (uname -r)
      - gcc version (gcc --version)
@@ -362,7 +423,7 @@ GigaSet 307x Device Driver
      appropriate forums and newsgroups.
 
 3.4. Reporting problem solutions
-     ---------------------------
+--------------------------------
      If you solved a problem with our drivers, wrote startup scripts for your
      distribution, ... feel free to contact us (using one of the places
      mentioned in 3.3.). We'd like to add scripts, hints, documentation
@@ -370,34 +431,35 @@ GigaSet 307x Device Driver
 
 
 4.   Links, other software
-     ---------------------
+==========================
+
      - Sourceforge project developing this driver and associated tools
-         https://sourceforge.net/projects/gigaset307x
+	 https://sourceforge.net/projects/gigaset307x
      - Yahoo! Group on the Siemens Gigaset family of devices
-         https://de.groups.yahoo.com/group/Siemens-Gigaset
+	 https://de.groups.yahoo.com/group/Siemens-Gigaset
      - Siemens Gigaset/T-Sinus compatibility table
-         http://www.erbze.info/sinus_gigaset.htm
+	 http://www.erbze.info/sinus_gigaset.htm
 	    (archived at https://web.archive.org/web/20100717020421/http://www.erbze.info:80/sinus_gigaset.htm )
 
 
 5.   Credits
-     -------
+============
+
      Thanks to
 
      Karsten Keil
-        for his help with isdn4linux
+	for his help with isdn4linux
      Deti Fliegl
-        for his base driver code
+	for his base driver code
      Dennis Dietrich
-        for his kernel 2.6 patches
+	for his kernel 2.6 patches
      Andreas Rummel
-        for his work and logs to get unimodem mode working
+	for his work and logs to get unimodem mode working
      Andreas Degert
-        for his logs and patches to get cx 100 working
+	for his logs and patches to get cx 100 working
      Dietrich Feist
-        for his generous donation of one M105 and two M101 cordless adapters
+	for his generous donation of one M105 and two M101 cordless adapters
      Christoph Schweers
-        for his generous donation of a M34 device
+	for his generous donation of a M34 device
 
      and all the other people who sent logs and other information.
-
diff --git a/Documentation/isdn/README.hysdn b/Documentation/isdn/hysdn.rst
similarity index 80%
rename from Documentation/isdn/README.hysdn
rename to Documentation/isdn/hysdn.rst
index eeca11f00ccd..0a168d1cbffc 100644
--- a/Documentation/isdn/README.hysdn
+++ b/Documentation/isdn/hysdn.rst
@@ -1,4 +1,7 @@
-$Id: README.hysdn,v 1.3.6.1 2001/02/10 14:41:19 kai Exp $
+============
+Hysdn Driver
+============
+
 The hysdn driver has been written by
 Werner Cornelius (werner@isdn4linux.de or werner@titro.de)
 for Hypercope GmbH Aachen Germany. Hypercope agreed to publish this driver
@@ -22,28 +25,28 @@ for Hypercope GmbH Aachen, Germany.
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
-Table of contents
-=================
+.. Table of contents
 
-1. About the driver
+    1. About the driver
 
-2. Loading/Unloading the driver
+    2. Loading/Unloading the driver
 
-3. Entries in the /proc filesystem
+    3. Entries in the /proc filesystem
 
-4. The /proc/net/hysdn/cardconfX file
+    4. The /proc/net/hysdn/cardconfX file
 
-5. The /proc/net/hysdn/cardlogX file
+    5. The /proc/net/hysdn/cardlogX file
 
-6. Where to get additional info and help
+    6. Where to get additional info and help
 
 
 1. About the driver
+===================
 
-   The drivers/isdn/hysdn subdir contains a driver for HYPERCOPEs active 
+   The drivers/isdn/hysdn subdir contains a driver for HYPERCOPEs active
    PCI isdn cards Champ, Ergo and Metro. To enable support for this cards
    enable ISDN support in the kernel config and support for HYSDN cards in
-   the active cards submenu. The driver may only be compiled and used if 
+   the active cards submenu. The driver may only be compiled and used if
    support for loadable modules and the process filesystem have been enabled.
 
    These cards provide two different interfaces to the kernel. Without the
@@ -52,22 +55,23 @@ Table of contents
    handlers for various protocols like ppp and others as well as config info
    and firmware may be fetched from Hypercopes WWW-Site www.hypercope.de.
 
-   With CAPI 2.0 support enabled, the card can also be used as a CAPI 2.0 
-   compliant devices with either CAPI 2.0 applications 
+   With CAPI 2.0 support enabled, the card can also be used as a CAPI 2.0
+   compliant devices with either CAPI 2.0 applications
    (check isdn4k-utils) or -using the capidrv module- as a regular
-   isdn4linux device. This is done via the same mechanism as with the 
+   isdn4linux device. This is done via the same mechanism as with the
    active AVM cards and in fact uses the same module.
-   
+
 
 2. Loading/Unloading the driver
+===============================
 
    The module has no command line parameters and auto detects up to 10 cards
    in the id-range 0-9.
    If a loaded driver shall be unloaded all open files in the /proc/net/hysdn
-   subdir need to be closed and all ethernet interfaces allocated by this 
+   subdir need to be closed and all ethernet interfaces allocated by this
    driver must be shut down. Otherwise the module counter will avoid a module
    unload.
-   
+
    If you are using the CAPI 2.0-interface, make sure to load/modprobe the
    kernelcapi-module first.
 
@@ -76,52 +80,57 @@ Table of contents
    any avm-specific modules).
 
 3. Entries in the /proc filesystem
+==================================
 
-   When the module has been loaded it adds the directory hysdn in the 
-   /proc/net tree. This directory contains exactly 2 file entries for each 
+   When the module has been loaded it adds the directory hysdn in the
+   /proc/net tree. This directory contains exactly 2 file entries for each
    card. One is called cardconfX and the other cardlogX, where X is the
-   card id number from 0 to 9. 
+   card id number from 0 to 9.
    The cards are numbered in the order found in the PCI config data.
 
 4. The /proc/net/hysdn/cardconfX file
+=====================================
 
-   This file may be read to get by everyone to get info about the cards type, 
+   This file may be read to get by everyone to get info about the cards type,
    actual state, available features and used resources.
    The first 3 entries (id, bus and slot) are PCI info fields, the following
    type field gives the information about the cards type:
 
-   4 -> Ergo card (server card with 2 b-chans)
-   5 -> Metro card (server card with 4 or 8 b-chans)
-   6 -> Champ card (client card with 2 b-chans)   
+   - 4 -> Ergo card (server card with 2 b-chans)
+   - 5 -> Metro card (server card with 4 or 8 b-chans)
+   - 6 -> Champ card (client card with 2 b-chans)
 
    The following 3 fields show the hardware assignments for irq, iobase and the
    dual ported memory (dp-mem).
+
    The fields b-chans and fax-chans announce the available card resources of
    this types for the user.
+
    The state variable indicates the actual drivers state for this card with the
    following assignments.
 
-   0 -> card has not been booted since driver load
-   1 -> card booting is actually in progess
-   2 -> card is in an error state due to a previous boot failure
-   3 -> card is booted and active
+   - 0 -> card has not been booted since driver load
+   - 1 -> card booting is actually in progess
+   - 2 -> card is in an error state due to a previous boot failure
+   - 3 -> card is booted and active
 
    And the last field (device) shows the name of the ethernet device assigned
    to this card. Up to the first successful boot this field only shows a -
    to tell that no net device has been allocated up to now. Once a net device
    has been allocated it remains assigned to this card, even if a card is
-   rebooted and an boot error occurs. 
+   rebooted and an boot error occurs.
 
-   Writing to the cardconfX file boots the card or transfers config lines to 
-   the cards firmware. The type of data is automatically detected when the 
+   Writing to the cardconfX file boots the card or transfers config lines to
+   the cards firmware. The type of data is automatically detected when the
    first data is written. Only root has write access to this file.
    The firmware boot files are normally called hyclient.pof for client cards
    and hyserver.pof for server cards.
    After successfully writing the boot file, complete config files or single
    config lines may be copied to this file.
-   If an error occurs the return value given to the writing process has the 
+   If an error occurs the return value given to the writing process has the
    following additional codes (decimal):
 
+   ==== ============================================
    1000 Another process is currently bootng the card
    1001 Invalid firmware header
    1002 Boards dual-port RAM test failed
@@ -131,34 +140,39 @@ Table of contents
    1006 Second boot stage failure
    1007 Timeout waiting for card ready during boot
    1008 Operation only allowed in booted state
-   1009 Config line too long 
-   1010 Invalid channel number 
+   1009 Config line too long
+   1010 Invalid channel number
    1011 Timeout sending config data
+   ==== ============================================
 
-   Additional info about error reasons may be fetched from the log output. 
+   Additional info about error reasons may be fetched from the log output.
 
 5. The /proc/net/hysdn/cardlogX file
-   	  
-   The cardlogX file entry may be opened multiple for reading by everyone to 
+====================================
+
+   The cardlogX file entry may be opened multiple for reading by everyone to
    get the cards and drivers log data. Card messages always start with the
-   keyword LOG. All other lines are output from the driver. 
-   The driver log data may be redirected to the syslog by selecting the 
+   keyword LOG. All other lines are output from the driver.
+   The driver log data may be redirected to the syslog by selecting the
    appropriate bitmask. The cards log messages will always be send to this
    interface but never to the syslog.
 
    A root user may write a decimal or hex (with 0x) value t this file to select
-   desired output options. As mentioned above the cards log dat is always 
+   desired output options. As mentioned above the cards log dat is always
    written to the cardlog file independent of the following options only used
    to check and debug the driver itself:
 
-   For example: 
-   echo "0x34560078" > /proc/net/hysdn/cardlog0
+   For example::
+
+	echo "0x34560078" > /proc/net/hysdn/cardlog0
+
    to output the hex log mask 34560078 for card 0.
- 
-   The written value is regarded as an unsigned 32-Bit value, bit ored for 
+
+   The written value is regarded as an unsigned 32-Bit value, bit ored for
    desired output. The following bits are already assigned:
 
-   0x80000000   All driver log data is alternatively via syslog 
+   ==========   ============================================================
+   0x80000000   All driver log data is alternatively via syslog
    0x00000001   Log memory allocation errors
    0x00000010   Firmware load start and close are logged
    0x00000020   Log firmware record parser
@@ -171,25 +185,12 @@ Table of contents
    0x00100000   Log all open and close actions to /proc/net/hysdn/card files
    0x00200000   Log all actions from /proc file entries
    0x00010000   Log network interface init and deinit
-   
+   ==========   ============================================================
+
 6. Where to get additional info and help
+========================================
 
-   If you have any problems concerning the driver or configuration contact 
+   If you have any problems concerning the driver or configuration contact
    the Hypercope support team (support@hypercope.de) and or the authors
    Werner Cornelius (werner@isdn4linux or cornelius@titro.de) or
    Ulrich Albrecht (ualbrecht@hypercope.de).
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
diff --git a/Documentation/isdn/index.rst b/Documentation/isdn/index.rst
new file mode 100644
index 000000000000..407e74b78372
--- /dev/null
+++ b/Documentation/isdn/index.rst
@@ -0,0 +1,24 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====
+ISDN
+====
+
+.. toctree::
+   :maxdepth: 2
+
+   interface_capi
+
+   avmb1
+   gigaset
+   hysdn
+   m_isdn
+
+   credits
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/isdn/INTERFACE.CAPI b/Documentation/isdn/interface_capi.rst
similarity index 75%
rename from Documentation/isdn/INTERFACE.CAPI
rename to Documentation/isdn/interface_capi.rst
index 021aa9cf139d..01a4b5ade9a4 100644
--- a/Documentation/isdn/INTERFACE.CAPI
+++ b/Documentation/isdn/interface_capi.rst
@@ -1,7 +1,9 @@
+=========================================
 Kernel CAPI Interface to Hardware Drivers
------------------------------------------
+=========================================
 
 1. Overview
+===========
 
 From the CAPI 2.0 specification:
 COMMON-ISDN-API (CAPI) is an application programming interface standard used
@@ -22,6 +24,7 @@ This standard is freely available from https://www.capi.org.
 
 
 2. Driver and Device Registration
+=================================
 
 CAPI drivers optionally register themselves with Kernel CAPI by calling the
 Kernel CAPI function register_capi_driver() with a pointer to a struct
@@ -50,6 +53,7 @@ callback functions by Kernel CAPI.
 
 
 3. Application Registration and Communication
+=============================================
 
 Kernel CAPI forwards registration requests from applications (calls to CAPI
 operation CAPI_REGISTER) to an appropriate hardware driver by calling its
@@ -71,23 +75,26 @@ messages for that application may be passed to or from the device anymore.
 
 
 4. Data Structures
+==================
 
 4.1 struct capi_driver
+----------------------
 
 This structure describes a Kernel CAPI driver itself. It is used in the
 register_capi_driver() and unregister_capi_driver() functions, and contains
 the following non-private fields, all to be set by the driver before calling
 register_capi_driver():
 
-char name[32]
+``char name[32]``
 	the name of the driver, as a zero-terminated ASCII string
-char revision[32]
+``char revision[32]``
 	the revision number of the driver, as a zero-terminated ASCII string
-int (*add_card)(struct capi_driver *driver, capicardparams *data)
+``int (*add_card)(struct capi_driver *driver, capicardparams *data)``
 	a callback function pointer (may be NULL)
 
 
 4.2 struct capi_ctr
+-------------------
 
 This structure describes an ISDN device (controller) handled by a Kernel CAPI
 driver. After registration via the attach_capi_ctr() function it is passed to
@@ -96,88 +103,109 @@ identify the controller to operate on.
 
 It contains the following non-private fields:
 
-- to be set by the driver before calling attach_capi_ctr():
+to be set by the driver before calling attach_capi_ctr():
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-struct module *owner
+``struct module *owner``
 	pointer to the driver module owning the device
 
-void *driverdata
+``void *driverdata``
 	an opaque pointer to driver specific data, not touched by Kernel CAPI
 
-char name[32]
+``char name[32]``
 	the name of the controller, as a zero-terminated ASCII string
 
-char *driver_name
+``char *driver_name``
 	the name of the driver, as a zero-terminated ASCII string
 
-int (*load_firmware)(struct capi_ctr *ctrlr, capiloaddata *ldata)
+``int (*load_firmware)(struct capi_ctr *ctrlr, capiloaddata *ldata)``
 	(optional) pointer to a callback function for sending firmware and
 	configuration data to the device
+
 	The function may return before the operation has completed.
+
 	Completion must be signalled by a call to capi_ctr_ready().
+
 	Return value: 0 on success, error code on error
 	Called in process context.
 
-void (*reset_ctr)(struct capi_ctr *ctrlr)
+``void (*reset_ctr)(struct capi_ctr *ctrlr)``
 	(optional) pointer to a callback function for stopping the device,
 	releasing all registered applications
+
 	The function may return before the operation has completed.
+
 	Completion must be signalled by a call to capi_ctr_down().
+
 	Called in process context.
 
-void (*register_appl)(struct capi_ctr *ctrlr, u16 applid,
-			capi_register_params *rparam)
-void (*release_appl)(struct capi_ctr *ctrlr, u16 applid)
-	pointers to callback functions for registration and deregistration of
+``void (*register_appl)(struct capi_ctr *ctrlr, u16 applid, capi_register_params *rparam)``
+	pointers to callback function for registration of
 	applications with the device
+
+	Calls to these functions are serialized by Kernel CAPI so that only
+	one call to any of them is active at any time.
+
+``void (*release_appl)(struct capi_ctr *ctrlr, u16 applid)``
+	pointers to callback functions deregistration of
+	applications with the device
+
 	Calls to these functions are serialized by Kernel CAPI so that only
 	one call to any of them is active at any time.
 
-u16  (*send_message)(struct capi_ctr *ctrlr, struct sk_buff *skb)
+``u16  (*send_message)(struct capi_ctr *ctrlr, struct sk_buff *skb)``
 	pointer to a callback function for sending a CAPI message to the
 	device
+
 	Return value: CAPI error code
+
 	If the method returns 0 (CAPI_NOERROR) the driver has taken ownership
 	of the skb and the caller may no longer access it. If it returns a
 	non-zero (error) value then ownership of the skb returns to the caller
 	who may reuse or free it.
+
 	The return value should only be used to signal problems with respect
 	to accepting or queueing the message. Errors occurring during the
 	actual processing of the message should be signaled with an
 	appropriate reply message.
+
 	May be called in process or interrupt context.
+
 	Calls to this function are not serialized by Kernel CAPI, ie. it must
 	be prepared to be re-entered.
 
-char *(*procinfo)(struct capi_ctr *ctrlr)
+``char *(*procinfo)(struct capi_ctr *ctrlr)``
 	pointer to a callback function returning the entry for the device in
 	the CAPI controller info table, /proc/capi/controller
 
-const struct file_operations *proc_fops
+``const struct file_operations *proc_fops``
 	pointers to callback functions for the device's proc file
 	system entry, /proc/capi/controllers/<n>; pointer to the device's
 	capi_ctr structure is available from struct proc_dir_entry::data
 	which is available from struct inode.
 
-Note: Callback functions except send_message() are never called in interrupt
-context.
+Note:
+  Callback functions except send_message() are never called in interrupt
+  context.
 
-- to be filled in before calling capi_ctr_ready():
+to be filled in before calling capi_ctr_ready():
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-u8 manu[CAPI_MANUFACTURER_LEN]
+``u8 manu[CAPI_MANUFACTURER_LEN]``
 	value to return for CAPI_GET_MANUFACTURER
 
-capi_version version
+``capi_version version``
 	value to return for CAPI_GET_VERSION
 
-capi_profile profile
+``capi_profile profile``
 	value to return for CAPI_GET_PROFILE
 
-u8 serial[CAPI_SERIAL_LEN]
+``u8 serial[CAPI_SERIAL_LEN]``
 	value to return for CAPI_GET_SERIAL
 
 
 4.3 SKBs
+--------
 
 CAPI messages are passed between Kernel CAPI and the driver via send_message()
 and capi_ctr_handle_message(), stored in the data portion of a socket buffer
@@ -192,6 +220,7 @@ instead of 30.
 
 
 4.4 The _cmsg Structure
+-----------------------
 
 (declared in <linux/isdn/capiutil.h>)
 
@@ -216,6 +245,7 @@ Members are named after the CAPI 2.0 standard names of the parameters they
 represent. See <linux/isdn/capiutil.h> for the exact spelling. Member data
 types are:
 
+=========== =================================================================
 u8          for CAPI parameters of type 'byte'
 
 u16         for CAPI parameters of type 'word'
@@ -235,6 +265,7 @@ _cmstruct   alternative representation for CAPI parameters of type 'struct'
 	    CAPI_COMPOSE: The parameter is present.
 	    Subparameter values are stored individually in the corresponding
 	    _cmsg structure members.
+=========== =================================================================
 
 Functions capi_cmsg2message() and capi_message2cmsg() are provided to convert
 messages between their transport encoding described in the CAPI 2.0 standard
@@ -244,51 +275,71 @@ sure it is big enough to accommodate the resulting CAPI message.
 
 
 5. Lower Layer Interface Functions
+==================================
 
 (declared in <linux/isdn/capilli.h>)
 
-void register_capi_driver(struct capi_driver *drvr)
-void unregister_capi_driver(struct capi_driver *drvr)
-	register/unregister a driver with Kernel CAPI
-
-int attach_capi_ctr(struct capi_ctr *ctrlr)
-int detach_capi_ctr(struct capi_ctr *ctrlr)
-	register/unregister a device (controller) with Kernel CAPI
-
-void capi_ctr_ready(struct capi_ctr *ctrlr)
-void capi_ctr_down(struct capi_ctr *ctrlr)
-	signal controller ready/not ready
-
-void capi_ctr_suspend_output(struct capi_ctr *ctrlr)
-void capi_ctr_resume_output(struct capi_ctr *ctrlr)
-	signal suspend/resume
-
-void capi_ctr_handle_message(struct capi_ctr * ctrlr, u16 applid,
-				struct sk_buff *skb)
-	pass a received CAPI message to Kernel CAPI
-	for forwarding to the specified application
+::
+
+  void register_capi_driver(struct capi_driver *drvr)
+  void unregister_capi_driver(struct capi_driver *drvr)
+
+register/unregister a driver with Kernel CAPI
+
+::
+
+  int attach_capi_ctr(struct capi_ctr *ctrlr)
+  int detach_capi_ctr(struct capi_ctr *ctrlr)
+
+register/unregister a device (controller) with Kernel CAPI
+
+::
+
+  void capi_ctr_ready(struct capi_ctr *ctrlr)
+  void capi_ctr_down(struct capi_ctr *ctrlr)
+
+signal controller ready/not ready
+
+::
+
+  void capi_ctr_suspend_output(struct capi_ctr *ctrlr)
+  void capi_ctr_resume_output(struct capi_ctr *ctrlr)
+
+signal suspend/resume
+
+::
+
+  void capi_ctr_handle_message(struct capi_ctr * ctrlr, u16 applid,
+			       struct sk_buff *skb)
+
+pass a received CAPI message to Kernel CAPI
+for forwarding to the specified application
 
 
 6. Helper Functions and Macros
+==============================
 
 Library functions (from <linux/isdn/capilli.h>):
 
-void capilib_new_ncci(struct list_head *head, u16 applid,
+::
+
+  void capilib_new_ncci(struct list_head *head, u16 applid,
 			u32 ncci, u32 winsize)
-void capilib_free_ncci(struct list_head *head, u16 applid, u32 ncci)
-void capilib_release_appl(struct list_head *head, u16 applid)
-void capilib_release(struct list_head *head)
-void capilib_data_b3_conf(struct list_head *head, u16 applid,
+  void capilib_free_ncci(struct list_head *head, u16 applid, u32 ncci)
+  void capilib_release_appl(struct list_head *head, u16 applid)
+  void capilib_release(struct list_head *head)
+  void capilib_data_b3_conf(struct list_head *head, u16 applid,
 			u32 ncci, u16 msgid)
-u16  capilib_data_b3_req(struct list_head *head, u16 applid,
+  u16  capilib_data_b3_req(struct list_head *head, u16 applid,
 			u32 ncci, u16 msgid)
 
 
 Macros to extract/set element values from/in a CAPI message header
 (from <linux/isdn/capiutil.h>):
 
+======================  =============================   ====================
 Get Macro		Set Macro			Element (Type)
-
+======================  =============================   ====================
 CAPIMSG_LEN(m)		CAPIMSG_SETLEN(m, len)		Total Length (u16)
 CAPIMSG_APPID(m)	CAPIMSG_SETAPPID(m, applid)	ApplID (u16)
 CAPIMSG_COMMAND(m)	CAPIMSG_SETCOMMAND(m,cmd)	Command (u8)
@@ -300,31 +351,31 @@ CAPIMSG_MSGID(m)	CAPIMSG_SETMSGID(m, msgid)	Message Number (u16)
 CAPIMSG_CONTROL(m)	CAPIMSG_SETCONTROL(m, contr)	Controller/PLCI/NCCI
 							(u32)
 CAPIMSG_DATALEN(m)	CAPIMSG_SETDATALEN(m, len)	Data Length (u16)
+======================  =============================   ====================
 
 
 Library functions for working with _cmsg structures
 (from <linux/isdn/capiutil.h>):
 
-unsigned capi_cmsg2message(_cmsg *cmsg, u8 *msg)
-	Assembles a CAPI 2.0 message from the parameters in *cmsg, storing the
-	result in *msg.
+``unsigned capi_cmsg2message(_cmsg *cmsg, u8 *msg)``
+	Assembles a CAPI 2.0 message from the parameters in ``*cmsg``,
+	storing the result in ``*msg``.
 
-unsigned capi_message2cmsg(_cmsg *cmsg, u8 *msg)
-	Disassembles the CAPI 2.0 message in *msg, storing the parameters in
-	*cmsg.
+``unsigned capi_message2cmsg(_cmsg *cmsg, u8 *msg)``
+	Disassembles the CAPI 2.0 message in ``*msg``, storing the parameters
+	in ``*cmsg``.
 
-unsigned capi_cmsg_header(_cmsg *cmsg, u16 ApplId, u8 Command, u8 Subcommand,
-			  u16 Messagenumber, u32 Controller)
-	Fills the header part and address field of the _cmsg structure *cmsg
+``unsigned capi_cmsg_header(_cmsg *cmsg, u16 ApplId, u8 Command, u8 Subcommand, u16 Messagenumber, u32 Controller)``
+	Fills the header part and address field of the _cmsg structure ``*cmsg``
 	with the given values, zeroing the remainder of the structure so only
 	parameters with non-default values need to be changed before sending
 	the message.
 
-void capi_cmsg_answer(_cmsg *cmsg)
-	Sets the low bit of the Subcommand field in *cmsg, thereby converting
-	_REQ to _CONF and _IND to _RESP.
+``void capi_cmsg_answer(_cmsg *cmsg)``
+	Sets the low bit of the Subcommand field in ``*cmsg``, thereby
+	converting ``_REQ`` to ``_CONF`` and ``_IND`` to ``_RESP``.
 
-char *capi_cmd2str(u8 Command, u8 Subcommand)
+``char *capi_cmd2str(u8 Command, u8 Subcommand)``
 	Returns the CAPI 2.0 message name corresponding to the given command
 	and subcommand values, as a static ASCII string. The return value may
 	be NULL if the command/subcommand is not one of those defined in the
@@ -332,6 +383,7 @@ char *capi_cmd2str(u8 Command, u8 Subcommand)
 
 
 7. Debugging
+============
 
 The module kernelcapi has a module parameter showcapimsgs controlling some
 debugging output produced by the module. It can only be set when the module is
diff --git a/Documentation/isdn/README.mISDN b/Documentation/isdn/m_isdn.rst
similarity index 89%
rename from Documentation/isdn/README.mISDN
rename to Documentation/isdn/m_isdn.rst
index cd8bf920e77b..9957de349e69 100644
--- a/Documentation/isdn/README.mISDN
+++ b/Documentation/isdn/m_isdn.rst
@@ -1,6 +1,9 @@
+============
+mISDN Driver
+============
+
 mISDN is a new modular ISDN driver, in the long term it should replace
 the old I4L driver architecture for passiv ISDN cards.
 It was designed to allow a broad range of applications and interfaces
 but only have the basic function in kernel, the interface to the user
 space is based on sockets with a own address family AF_ISDN.
-
diff --git a/drivers/staging/isdn/hysdn/Kconfig b/drivers/staging/isdn/hysdn/Kconfig
index 1971ef850c9a..4c8a9283b9dd 100644
--- a/drivers/staging/isdn/hysdn/Kconfig
+++ b/drivers/staging/isdn/hysdn/Kconfig
@@ -5,7 +5,7 @@ config HYSDN
 	help
 	  Say Y here if you have one of Hypercope's active PCI ISDN cards
 	  Champ, Ergo and Metro. You will then get a module called hysdn.
-	  Please read the file <file:Documentation/isdn/README.hysdn> for more
+	  Please read the file <file:Documentation/isdn/hysdn.rst> for more
 	  information.
 
 config HYSDN_CAPI
-- 
2.21.0

