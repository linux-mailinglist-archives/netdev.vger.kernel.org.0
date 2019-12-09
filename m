Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4471311700D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 16:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfLIPNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 10:13:24 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:59003 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLIPNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 10:13:22 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MsI0K-1hkrko1pne-00tmSX; Mon, 09 Dec 2019 16:13:04 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        linux-x25@vger.kernel.org, Kevin Curtis <kevin.curtis@farsite.com>,
        "R.J.Dunlop" <bob.dunlop@farsite.com>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com,
        syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
Subject: [PATCH 4/4] [RFC] staging/net: move AF_X25 into drivers/staging
Date:   Mon,  9 Dec 2019 16:12:56 +0100
Message-Id: <20191209151256.2497534-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191209151256.2497534-1-arnd@arndb.de>
References: <20191209151256.2497534-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:axqQdPSgl83A4LQAeLmE7KNfPfPliwry7FdaQPchJD58gpeh1U3
 6A9wUy/UB95zkMQKB6U6a0D0fDHQmgCPZGdf7wllVR0ZZ75pvVxWAGXAgUBeTjOhFcqhO53
 fjn81/AswbI32ZP2V7kAnyimkYqoNlHGHyc6TFghgfAS0vSS+R5IudprdlowFmBfXjwD62u
 ekn4hihPiYJMmKLeW1xdA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aPRwnT+S5Ik=:fbrPcaDEFeOzu3kQC9V6Pm
 wGEnsFVpdz9CcV8ZS/cDjjEAzk9lP4ZmqlQ0urXEBwuE4e3IGGp5IxGEytVqI38mGyDQamO38
 2lq3dwt8yyAz6MA52q5OzXuVhX9VlPyoFuDcKy58ipo3liJ+kFkN740yh3qXoiJQt+Pc0cYFi
 bjRfDeVMy1k6f5nEipu3jb30PBONml5DaRSqFDc3T0dB2cwa97JdbvSNtTKW5stSlwrbFsQKV
 kV856sNOee4jTwTdchcUqzLjohQ66XZVhjX+qO+muyVrUEbR5jrreqlRCTx9HY7JB+05aaXBN
 uKVkwFaRCYq/TktU9mm6BfB8xM/bmqN6EfZd15WzUOpBHrhX/RbYSQIQ3noSlVgbSJGjL35U4
 0+fW6wNdy1ojAfeTp60psFMzyaodE6oDu0oE10rKLyw9/OpOWhg7Tvnkb9MhYXzYqRUEYwr/n
 IFeLjm4+FMHuZajzf3pCjxmsx+RaAk9MuAsg9iX5w8Gn1kWoN1NxzR/ppAYV1SHKh8F7gqc2g
 1T6heSIWIDjdcDXj7h8iq4orGw+pOtpRgapiVA2GbUdj8hwqE3URNHOcMuaDlfLlQv5aDJWWa
 OayDfUEahq/gIIGD9Mz5x46POdB5KfQuw5J7YvbQyFCGLOx3xTFKM+grxmNbSZdd9biF2F9/s
 krTTIjuJg3FT+pEPKo3MZLuKuY/th3luETI89e3cinuTytjMjExbfVTTPu1/vr6EiF+OBai54
 BCwstXkK4+yAqfSDLfUdU9JrarEi8MBI6AF6rRDEXkMjdW/Q+sDcmvk8HydbgL7CS+Cfx5x+1
 GqaBNuAWFOaWihI3wSLafI4BGXLZjEoGfREv6wLkBLB535NRnyR7iuMvpgRB8Wg5xdrjD46FY
 IaeEdzPxfNHqqqEiScjQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot keeps finding issues in the X.25 implementation that nobody is
interested in fixing.  Given that all the x25 patches of the past years
that are not global cleanups tend to fix user-triggered oopses, is it
time to just retire the subsystem?

I looked a bit closer and found:

- we used to support x25 hardware in linux, but with WAN_ROUTER
  removed in linux-3.9 and isdn4linux removed in 5.3, there is only hdlc,
  ethernet and the N_X25 tty ldisc left. Out of these, only HDLC_X25 made
  it beyond the experimental stage, so this is probably what everyone
  uses if there are users at all.

- The most common hdlc hardware that people seem to be using are
  the "farsync" PCIe and USB adapters. Linux only has drivers for the
  older PCI devices from that series, but no hardware that works on
  modern systems.

- The manufacturer still updates their own kernel drivers and provides
  support, but ships that with a fork or rewrite of the subsystem
  code now.  Kevin Curtis is also listed as maintainer, but appears to
  have given up in 2013 after [1].

- The most popular software implementation appears to be X25 over TCP
  (XOT), which is supported by Farsite and other out-of-tree stacks but
  never had an implementation in mainline.

- Most other supported HDLC hardware that we supoprt is for the ISA or
  PCI buses. There are newer PCIe or USB devices, but those all require
  a custom device driver and often a custom subsystem, none of which got
  submitted for mainline inclusion. This includes hardware from Microgate
  (SyncLink), Comtrol (RocketPort Express) and Sealevel (SeaMAC).

- The X.25 subsystem is listed as "odd fixes", but the last reply on
  the netdev mailing list from the maintainer was also in 2013[2].

- The HDLC subsystem itself is listed as maintained by Krzysztof Halasa,
  and there were new drivers merged for SoC based devices as late as
  2016 by Zhao Qiang: Freescale/NXP QUICC Engine and Maxim ds26522.
  There has not been much work on HDLC or drivers/net/wan recently,
  but both developers are still responsive on the mailing list and
  work on other parts of the kernel.

Based on the above, I would conclude that X.25 can probably get moved
to staging as keeping it in the kernel seems to do more harm than good,
but HDLC below it should probably stay as there it seems there are still
users of a small subset of the mainline drivers.

Move all of X.25 into drivers/staging for now, with a projected removal
date set for Linux-5.8.

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Cc: linux-x25@vger.kernel.org
Cc: Kevin Curtis <kevin.curtis@farsite.com>
Cc: "R.J.Dunlop" <bob.dunlop@farsite.com>
Cc: Zhao Qiang <qiang.zhao@nxp.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Reported-by: syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com
Reported-by: syzbot+eec0c87f31a7c3b66f7b@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=5b0ecf0386f56be7fe7210a14d0f62df765c0c39
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
----

If anyone has different views or additional information, let us know.

If you agree with the above, please Ack.
---
 MAINTAINERS                                   |  8 +-
 drivers/net/wan/Kconfig                       | 43 --------
 drivers/net/wan/Makefile                      |  3 -
 drivers/staging/Kconfig                       |  2 +
 drivers/staging/Makefile                      |  2 +
 .../x25/Documentation}/lapb-module.txt        |  0
 .../staging/x25/Documentation}/x25-iface.txt  |  0
 .../staging/x25/Documentation}/x25.txt        |  0
 drivers/staging/x25/Kconfig                   | 97 +++++++++++++++++++
 {net => drivers/staging}/x25/Makefile         |  8 ++
 drivers/staging/x25/TODO                      | 15 +++
 {net => drivers/staging}/x25/af_x25.c         |  2 +-
 drivers/{net/wan => staging/x25}/hdlc_x25.c   |  2 +-
 {include/net => drivers/staging/x25}/lapb.h   |  2 +-
 .../lapb => drivers/staging/x25}/lapb_iface.c |  2 +-
 {net/lapb => drivers/staging/x25}/lapb_in.c   |  2 +-
 {net/lapb => drivers/staging/x25}/lapb_out.c  |  2 +-
 {net/lapb => drivers/staging/x25}/lapb_subr.c |  2 +-
 .../lapb => drivers/staging/x25}/lapb_timer.c |  2 +-
 drivers/{net/wan => staging/x25}/lapbether.c  |  2 +-
 .../staging/x25/linux-lapb.h                  |  0
 {net => drivers/staging}/x25/sysctl_net_x25.c |  2 +-
 .../x25.h => drivers/staging/x25/uapi-x25.h   |  0
 {include/net => drivers/staging/x25}/x25.h    |  2 +-
 drivers/{net/wan => staging/x25}/x25_asy.c    |  2 +-
 drivers/{net/wan => staging/x25}/x25_asy.h    |  0
 {net => drivers/staging}/x25/x25_dev.c        |  2 +-
 {net => drivers/staging}/x25/x25_facilities.c |  2 +-
 {net => drivers/staging}/x25/x25_forward.c    |  2 +-
 {net => drivers/staging}/x25/x25_in.c         |  2 +-
 {net => drivers/staging}/x25/x25_link.c       |  2 +-
 {net => drivers/staging}/x25/x25_out.c        |  2 +-
 {net => drivers/staging}/x25/x25_proc.c       |  2 +-
 {net => drivers/staging}/x25/x25_route.c      |  2 +-
 {net => drivers/staging}/x25/x25_subr.c       |  2 +-
 {net => drivers/staging}/x25/x25_timer.c      |  2 +-
 include/Kbuild                                |  2 -
 net/Kconfig                                   |  2 -
 net/Makefile                                  |  2 -
 net/lapb/Kconfig                              | 22 -----
 net/lapb/Makefile                             |  8 --
 net/x25/Kconfig                               | 34 -------
 42 files changed, 148 insertions(+), 144 deletions(-)
 rename {Documentation/networking => drivers/staging/x25/Documentation}/lapb-module.txt (100%)
 rename {Documentation/networking => drivers/staging/x25/Documentation}/x25-iface.txt (100%)
 rename {Documentation/networking => drivers/staging/x25/Documentation}/x25.txt (100%)
 create mode 100644 drivers/staging/x25/Kconfig
 rename {net => drivers/staging}/x25/Makefile (58%)
 create mode 100644 drivers/staging/x25/TODO
 rename {net => drivers/staging}/x25/af_x25.c (99%)
 rename drivers/{net/wan => staging/x25}/hdlc_x25.c (99%)
 rename {include/net => drivers/staging/x25}/lapb.h (99%)
 rename {net/lapb => drivers/staging/x25}/lapb_iface.c (99%)
 rename {net/lapb => drivers/staging/x25}/lapb_in.c (99%)
 rename {net/lapb => drivers/staging/x25}/lapb_out.c (99%)
 rename {net/lapb => drivers/staging/x25}/lapb_subr.c (99%)
 rename {net/lapb => drivers/staging/x25}/lapb_timer.c (99%)
 rename drivers/{net/wan => staging/x25}/lapbether.c (99%)
 rename include/linux/lapb.h => drivers/staging/x25/linux-lapb.h (100%)
 rename {net => drivers/staging}/x25/sysctl_net_x25.c (98%)
 rename include/uapi/linux/x25.h => drivers/staging/x25/uapi-x25.h (100%)
 rename {include/net => drivers/staging/x25}/x25.h (99%)
 rename drivers/{net/wan => staging/x25}/x25_asy.c (99%)
 rename drivers/{net/wan => staging/x25}/x25_asy.h (100%)
 rename {net => drivers/staging}/x25/x25_dev.c (99%)
 rename {net => drivers/staging}/x25/x25_facilities.c (99%)
 rename {net => drivers/staging}/x25/x25_forward.c (99%)
 rename {net => drivers/staging}/x25/x25_in.c (99%)
 rename {net => drivers/staging}/x25/x25_link.c (99%)
 rename {net => drivers/staging}/x25/x25_out.c (99%)
 rename {net => drivers/staging}/x25/x25_proc.c (99%)
 rename {net => drivers/staging}/x25/x25_route.c (99%)
 rename {net => drivers/staging}/x25/x25_subr.c (99%)
 rename {net => drivers/staging}/x25/x25_timer.c (99%)
 delete mode 100644 net/lapb/Kconfig
 delete mode 100644 net/lapb/Makefile
 delete mode 100644 net/x25/Kconfig

diff --git a/MAINTAINERS b/MAINTAINERS
index 32fab6fbd301..5f0786bd8e22 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9155,9 +9155,7 @@ F:	drivers/soc/lantiq
 LAPB module
 L:	linux-x25@vger.kernel.org
 S:	Orphan
-F:	Documentation/networking/lapb-module.txt
-F:	include/*/lapb.h
-F:	net/lapb/
+F:	drivers/staging/x25/
 
 LASI 53c700 driver for PARISC
 M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
@@ -17645,9 +17643,7 @@ X.25 NETWORK LAYER
 M:	Andrew Hendry <andrew.hendry@gmail.com>
 L:	linux-x25@vger.kernel.org
 S:	Odd Fixes
-F:	Documentation/networking/x25*
-F:	include/net/x25*
-F:	net/x25/
+F:	drivers/staging/x25/
 
 X86 ARCHITECTURE (32-BIT AND 64-BIT)
 M:	Thomas Gleixner <tglx@linutronix.de>
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 74f2bd639b07..931457129b3b 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -156,17 +156,6 @@ config HDLC_PPP
 
 	  If unsure, say N.
 
-config HDLC_X25
-	tristate "X.25 protocol support"
-	depends on HDLC && (LAPB=m && HDLC=m || LAPB=y)
-	help
-	  Generic HDLC driver supporting X.25 over WAN connections.
-
-	  If unsure, say N.
-
-comment "X.25/LAPB support is disabled"
-	depends on HDLC && (LAPB!=m || HDLC!=m) && LAPB!=y
-
 config PCI200SYN
 	tristate "Goramo PCI200SYN support"
 	depends on HDLC && PCI
@@ -297,36 +286,4 @@ config IXP4XX_HSS
 	  Say Y here if you want to use built-in HSS ports
 	  on IXP4xx processor.
 
-# X.25 network drivers
-config LAPBETHER
-	tristate "LAPB over Ethernet driver"
-	depends on LAPB && X25
-	---help---
-	  Driver for a pseudo device (typically called /dev/lapb0) which allows
-	  you to open an LAPB point-to-point connection to some other computer
-	  on your Ethernet network.
-
-	  In order to do this, you need to say Y or M to the driver for your
-	  Ethernet card as well as to "LAPB Data Link Driver".
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called lapbether.
-
-	  If unsure, say N.
-
-config X25_ASY
-	tristate "X.25 async driver"
-	depends on LAPB && X25 && TTY
-	---help---
-	  Send and receive X.25 frames over regular asynchronous serial
-	  lines such as telephone lines equipped with ordinary modems.
-
-	  Experts should note that this driver doesn't currently comply with
-	  the asynchronous HDLS framing protocols in CCITT recommendation X.25.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called x25_asy.
-
-	  If unsure, say N.
-
 endif # WAN
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 4438a0c4a272..1eb30941a445 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -12,17 +12,14 @@ obj-$(CONFIG_HDLC_RAW_ETH)	+= hdlc_raw_eth.o
 obj-$(CONFIG_HDLC_CISCO)	+= hdlc_cisco.o
 obj-$(CONFIG_HDLC_FR)		+= hdlc_fr.o
 obj-$(CONFIG_HDLC_PPP)		+= hdlc_ppp.o
-obj-$(CONFIG_HDLC_X25)		+= hdlc_x25.o
 
 obj-$(CONFIG_HOSTESS_SV11)	+= z85230.o	hostess_sv11.o
 obj-$(CONFIG_SEALEVEL_4021)	+= z85230.o	sealevel.o
 obj-$(CONFIG_COSA)		+= cosa.o
 obj-$(CONFIG_FARSYNC)		+= farsync.o
-obj-$(CONFIG_X25_ASY)		+= x25_asy.o
 
 obj-$(CONFIG_LANMEDIA)		+= lmc/
 
-obj-$(CONFIG_LAPBETHER)		+= lapbether.o
 obj-$(CONFIG_N2)		+= n2.o
 obj-$(CONFIG_C101)		+= c101.o
 obj-$(CONFIG_WANXL)		+= wanxl.o
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index ab83326f4b7e..e2edb29ccb42 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -123,4 +123,6 @@ source "drivers/staging/exfat/Kconfig"
 
 source "drivers/staging/qlge/Kconfig"
 
+source "drivers/staging/x25/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index dfddb9864b2e..0576784f1f11 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -52,3 +52,5 @@ obj-$(CONFIG_UWB)		+= uwb/
 obj-$(CONFIG_USB_WUSB)		+= wusbcore/
 obj-$(CONFIG_EXFAT_FS)		+= exfat/
 obj-$(CONFIG_QLGE)		+= qlge/
+obj-$(CONFIG_X25)		+= x25/
+obj-$(CONFIG_LAPB)		+= x25/
diff --git a/Documentation/networking/lapb-module.txt b/drivers/staging/x25/Documentation/lapb-module.txt
similarity index 100%
rename from Documentation/networking/lapb-module.txt
rename to drivers/staging/x25/Documentation/lapb-module.txt
diff --git a/Documentation/networking/x25-iface.txt b/drivers/staging/x25/Documentation/x25-iface.txt
similarity index 100%
rename from Documentation/networking/x25-iface.txt
rename to drivers/staging/x25/Documentation/x25-iface.txt
diff --git a/Documentation/networking/x25.txt b/drivers/staging/x25/Documentation/x25.txt
similarity index 100%
rename from Documentation/networking/x25.txt
rename to drivers/staging/x25/Documentation/x25.txt
diff --git a/drivers/staging/x25/Kconfig b/drivers/staging/x25/Kconfig
new file mode 100644
index 000000000000..18724b747a9e
--- /dev/null
+++ b/drivers/staging/x25/Kconfig
@@ -0,0 +1,97 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# CCITT X.25 Packet Layer
+#
+
+config X25
+	tristate "CCITT X.25 Packet Layer"
+	depends on NET
+	---help---
+	  X.25 is a set of standardized network protocols, similar in scope to
+	  frame relay; the one physical line from your box to the X.25 network
+	  entry point can carry several logical point-to-point connections
+	  (called "virtual circuits") to other computers connected to the X.25
+	  network. Governments, banks, and other organizations tend to use it
+	  to connect to each other or to form Wide Area Networks (WANs). Many
+	  countries have public X.25 networks. X.25 consists of two
+	  protocols: the higher level Packet Layer Protocol (PLP) (say Y here
+	  if you want that) and the lower level data link layer protocol LAPB
+	  (say Y to "LAPB Data Link Driver" below if you want that).
+
+	  You can read more about X.25 at <http://www.sangoma.com/tutorials/x25/> and
+	  <http://docwiki.cisco.com/wiki/X.25>.
+	  Information about X.25 for Linux is contained in the files
+	  <file:Documentation/networking/x25.txt> and
+	  <file:Documentation/networking/x25-iface.txt>.
+
+	  One connects to an X.25 network either with a dedicated network card
+	  using the X.21 protocol (not yet supported by Linux) or one can do
+	  X.25 over a standard telephone line using an ordinary modem (say Y
+	  to "X.25 async driver" below) or over Ethernet using an ordinary
+	  Ethernet card and the LAPB over Ethernet (say Y to "LAPB Data Link
+	  Driver" and "LAPB over Ethernet driver" below).
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called x25. If unsure, say N.
+
+config LAPB
+	tristate "LAPB  Data Link Driver"
+	depends on NET
+	---help---
+	  Link Access Procedure, Balanced (LAPB) is the data link layer (i.e.
+	  the lower) part of the X.25 protocol. It offers a reliable
+	  connection service to exchange data frames with one other host, and
+	  it is used to transport higher level protocols (mostly X.25 Packet
+	  Layer, the higher part of X.25, but others are possible as well).
+	  Usually, LAPB is used with specialized X.21 network cards, but Linux
+	  currently supports LAPB only over Ethernet connections. If you want
+	  to use LAPB connections over Ethernet, say Y here and to "LAPB over
+	  Ethernet driver" below. Read
+	  <file:Documentation/networking/lapb-module.txt> for technical
+	  details.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called lapb.  If unsure, say N.
+
+config HDLC_X25
+	tristate "X.25 protocol support"
+	depends on HDLC && (LAPB=m && HDLC=m || LAPB=y)
+	help
+	  Generic HDLC driver supporting X.25 over WAN connections.
+
+	  If unsure, say N.
+
+comment "X.25/LAPB support is disabled"
+	depends on HDLC && (LAPB!=m || HDLC!=m) && LAPB!=y
+
+# X.25 network drivers
+config LAPBETHER
+	tristate "LAPB over Ethernet driver"
+	depends on LAPB && X25
+	---help---
+	  Driver for a pseudo device (typically called /dev/lapb0) which allows
+	  you to open an LAPB point-to-point connection to some other computer
+	  on your Ethernet network.
+
+	  In order to do this, you need to say Y or M to the driver for your
+	  Ethernet card as well as to "LAPB Data Link Driver".
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called lapbether.
+
+	  If unsure, say N.
+
+config X25_ASY
+	tristate "X.25 async driver"
+	depends on LAPB && X25 && TTY
+	---help---
+	  Send and receive X.25 frames over regular asynchronous serial
+	  lines such as telephone lines equipped with ordinary modems.
+
+	  Experts should note that this driver doesn't currently comply with
+	  the asynchronous HDLS framing protocols in CCITT recommendation X.25.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called x25_asy.
+
+	  If unsure, say N.
diff --git a/net/x25/Makefile b/drivers/staging/x25/Makefile
similarity index 58%
rename from net/x25/Makefile
rename to drivers/staging/x25/Makefile
index 5dd544a231f2..d8235ac6b015 100644
--- a/net/x25/Makefile
+++ b/drivers/staging/x25/Makefile
@@ -9,3 +9,11 @@ x25-y			:= af_x25.o x25_dev.o x25_facilities.o x25_in.o \
 			   x25_link.o x25_out.o x25_route.o x25_subr.o \
 			   x25_timer.o x25_proc.o x25_forward.o
 x25-$(CONFIG_SYSCTL)	+= sysctl_net_x25.o
+
+obj-$(CONFIG_LAPB) += lapb.o
+
+lapb-y := lapb_in.o lapb_out.o lapb_subr.o lapb_timer.o lapb_iface.o
+
+obj-$(CONFIG_HDLC_X25)		+= hdlc_x25.o
+obj-$(CONFIG_X25_ASY)		+= x25_asy.o
+obj-$(CONFIG_LAPBETHER)		+= lapbether.o
diff --git a/drivers/staging/x25/TODO b/drivers/staging/x25/TODO
new file mode 100644
index 000000000000..bb42cf474ca1
--- /dev/null
+++ b/drivers/staging/x25/TODO
@@ -0,0 +1,15 @@
+Staging out of X.25
+===================
+
+It appears that the X.25 socket family is not used any more with the
+mainline kernel, and the git log shows a series of user-triggerable
+Oopses.
+
+https://www.farsite.com/ still makes hardware that is being used in the
+field, but that uses a custom out of tree protocol stack in place of
+the kernel's AF_X25.
+
+If there are remaining users of this code that I missed, it can be moved
+out back out of staging, otherwise it will be removed in linux-5.8.
+
+    Arnd Bergmann <arnd@arndb.de>
diff --git a/net/x25/af_x25.c b/drivers/staging/x25/af_x25.c
similarity index 99%
rename from net/x25/af_x25.c
rename to drivers/staging/x25/af_x25.c
index 6aee9f5e8e71..be950682209d 100644
--- a/net/x25/af_x25.c
+++ b/drivers/staging/x25/af_x25.c
@@ -54,7 +54,7 @@
 #include <linux/compat.h>
 #include <linux/ctype.h>
 
-#include <net/x25.h>
+#include "x25.h"
 #include <net/compat.h>
 
 int sysctl_x25_restart_request_timeout = X25_DEFAULT_T20;
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/staging/x25/hdlc_x25.c
similarity index 99%
rename from drivers/net/wan/hdlc_x25.c
rename to drivers/staging/x25/hdlc_x25.c
index 5643675ff724..32ccf0c8e040 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/staging/x25/hdlc_x25.c
@@ -13,7 +13,7 @@
 #include <linux/inetdevice.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/lapb.h>
+#include "linux-lapb.h"
 #include <linux/module.h>
 #include <linux/pkt_sched.h>
 #include <linux/poll.h>
diff --git a/include/net/lapb.h b/drivers/staging/x25/lapb.h
similarity index 99%
rename from include/net/lapb.h
rename to drivers/staging/x25/lapb.h
index ccc3d1f020b0..2abab6266caf 100644
--- a/include/net/lapb.h
+++ b/drivers/staging/x25/lapb.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LAPB_H
 #define _LAPB_H 
-#include <linux/lapb.h>
 #include <linux/refcount.h>
+#include "linux-lapb.h"
 
 #define	LAPB_HEADER_LEN	20		/* LAPB over Ethernet + a bit more */
 
diff --git a/net/lapb/lapb_iface.c b/drivers/staging/x25/lapb_iface.c
similarity index 99%
rename from net/lapb/lapb_iface.c
rename to drivers/staging/x25/lapb_iface.c
index 3c03f6512c5f..1231ae28ec64 100644
--- a/net/lapb/lapb_iface.c
+++ b/drivers/staging/x25/lapb_iface.c
@@ -34,7 +34,7 @@
 #include <linux/interrupt.h>
 #include <linux/stat.h>
 #include <linux/init.h>
-#include <net/lapb.h>
+#include "lapb.h"
 
 static LIST_HEAD(lapb_list);
 static DEFINE_RWLOCK(lapb_list_lock);
diff --git a/net/lapb/lapb_in.c b/drivers/staging/x25/lapb_in.c
similarity index 99%
rename from net/lapb/lapb_in.c
rename to drivers/staging/x25/lapb_in.c
index 38ae23c09e83..210f8c743b39 100644
--- a/net/lapb/lapb_in.c
+++ b/drivers/staging/x25/lapb_in.c
@@ -30,7 +30,7 @@
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <net/lapb.h>
+#include "lapb.h"
 
 /*
  *	State machine for state 0, Disconnected State.
diff --git a/net/lapb/lapb_out.c b/drivers/staging/x25/lapb_out.c
similarity index 99%
rename from net/lapb/lapb_out.c
rename to drivers/staging/x25/lapb_out.c
index 7a4d0715d1c3..d4ba7a5ebd33 100644
--- a/net/lapb/lapb_out.c
+++ b/drivers/staging/x25/lapb_out.c
@@ -28,7 +28,7 @@
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <net/lapb.h>
+#include "lapb.h"
 
 /*
  *  This procedure is passed a buffer descriptor for an iframe. It builds
diff --git a/net/lapb/lapb_subr.c b/drivers/staging/x25/lapb_subr.c
similarity index 99%
rename from net/lapb/lapb_subr.c
rename to drivers/staging/x25/lapb_subr.c
index 592a22d86a97..f5ec7868c5a4 100644
--- a/net/lapb/lapb_subr.c
+++ b/drivers/staging/x25/lapb_subr.c
@@ -27,7 +27,7 @@
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <net/lapb.h>
+#include "lapb.h"
 
 /*
  *	This routine purges all the queues of frames.
diff --git a/net/lapb/lapb_timer.c b/drivers/staging/x25/lapb_timer.c
similarity index 99%
rename from net/lapb/lapb_timer.c
rename to drivers/staging/x25/lapb_timer.c
index 8f5b17001a07..0b46163593e5 100644
--- a/net/lapb/lapb_timer.c
+++ b/drivers/staging/x25/lapb_timer.c
@@ -28,7 +28,7 @@
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
-#include <net/lapb.h>
+#include "lapb.h"
 
 static void lapb_t1timer_expiry(struct timer_list *);
 static void lapb_t2timer_expiry(struct timer_list *);
diff --git a/drivers/net/wan/lapbether.c b/drivers/staging/x25/lapbether.c
similarity index 99%
rename from drivers/net/wan/lapbether.c
rename to drivers/staging/x25/lapbether.c
index 0f1217b506ad..6ff971705dca 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/staging/x25/lapbether.c
@@ -36,7 +36,7 @@
 #include <linux/notifier.h>
 #include <linux/stat.h>
 #include <linux/module.h>
-#include <linux/lapb.h>
+#include "linux-lapb.h"
 #include <linux/init.h>
 
 #include <net/x25device.h>
diff --git a/include/linux/lapb.h b/drivers/staging/x25/linux-lapb.h
similarity index 100%
rename from include/linux/lapb.h
rename to drivers/staging/x25/linux-lapb.h
diff --git a/net/x25/sysctl_net_x25.c b/drivers/staging/x25/sysctl_net_x25.c
similarity index 98%
rename from net/x25/sysctl_net_x25.c
rename to drivers/staging/x25/sysctl_net_x25.c
index e9802afa43d0..e8530a4e4856 100644
--- a/net/x25/sysctl_net_x25.c
+++ b/drivers/staging/x25/sysctl_net_x25.c
@@ -11,7 +11,7 @@
 #include <linux/socket.h>
 #include <linux/netdevice.h>
 #include <linux/init.h>
-#include <net/x25.h>
+#include "x25.h"
 
 static int min_timer[] = {   1 * HZ };
 static int max_timer[] = { 300 * HZ };
diff --git a/include/uapi/linux/x25.h b/drivers/staging/x25/uapi-x25.h
similarity index 100%
rename from include/uapi/linux/x25.h
rename to drivers/staging/x25/uapi-x25.h
diff --git a/include/net/x25.h b/drivers/staging/x25/x25.h
similarity index 99%
rename from include/net/x25.h
rename to drivers/staging/x25/x25.h
index ed1acc3044ac..dfbc0188e47d 100644
--- a/include/net/x25.h
+++ b/drivers/staging/x25/x25.h
@@ -10,10 +10,10 @@
 
 #ifndef _X25_H
 #define _X25_H 
-#include <linux/x25.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
 #include <net/sock.h>
+#include "uapi-x25.h"
 
 #define	X25_ADDR_LEN			16
 
diff --git a/drivers/net/wan/x25_asy.c b/drivers/staging/x25/x25_asy.c
similarity index 99%
rename from drivers/net/wan/x25_asy.c
rename to drivers/staging/x25/x25_asy.c
index 914be5847386..3986a1160fc1 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/staging/x25/x25_asy.c
@@ -31,7 +31,7 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
-#include <linux/lapb.h>
+#include "linux-lapb.h"
 #include <linux/init.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
diff --git a/drivers/net/wan/x25_asy.h b/drivers/staging/x25/x25_asy.h
similarity index 100%
rename from drivers/net/wan/x25_asy.h
rename to drivers/staging/x25/x25_asy.h
diff --git a/net/x25/x25_dev.c b/drivers/staging/x25/x25_dev.c
similarity index 99%
rename from net/x25/x25_dev.c
rename to drivers/staging/x25/x25_dev.c
index 00e782335cb0..dbdce9c62abd 100644
--- a/net/x25/x25_dev.c
+++ b/drivers/staging/x25/x25_dev.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <linux/if_arp.h>
-#include <net/x25.h>
+#include "x25.h"
 #include <net/x25device.h>
 
 static int x25_receive_data(struct sk_buff *skb, struct x25_neigh *nb)
diff --git a/net/x25/x25_facilities.c b/drivers/staging/x25/x25_facilities.c
similarity index 99%
rename from net/x25/x25_facilities.c
rename to drivers/staging/x25/x25_facilities.c
index 7fb327632272..17e41049cb2b 100644
--- a/net/x25/x25_facilities.c
+++ b/drivers/staging/x25/x25_facilities.c
@@ -22,7 +22,7 @@
 #include <linux/string.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <net/x25.h>
+#include "x25.h"
 
 /**
  * x25_parse_facilities - Parse facilities from skb into the facilities structs
diff --git a/net/x25/x25_forward.c b/drivers/staging/x25/x25_forward.c
similarity index 99%
rename from net/x25/x25_forward.c
rename to drivers/staging/x25/x25_forward.c
index c82999941d3f..4328f0e31482 100644
--- a/net/x25/x25_forward.c
+++ b/drivers/staging/x25/x25_forward.c
@@ -9,7 +9,7 @@
 #include <linux/if_arp.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <net/x25.h>
+#include "x25.h"
 
 LIST_HEAD(x25_forward_list);
 DEFINE_RWLOCK(x25_forward_list_lock);
diff --git a/net/x25/x25_in.c b/drivers/staging/x25/x25_in.c
similarity index 99%
rename from net/x25/x25_in.c
rename to drivers/staging/x25/x25_in.c
index f97c43344e95..e0c1f1484d8c 100644
--- a/net/x25/x25_in.c
+++ b/drivers/staging/x25/x25_in.c
@@ -27,7 +27,7 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <net/x25.h>
+#include "x25.h"
 
 static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 {
diff --git a/net/x25/x25_link.c b/drivers/staging/x25/x25_link.c
similarity index 99%
rename from net/x25/x25_link.c
rename to drivers/staging/x25/x25_link.c
index 7d02532aad0d..5c07143e557d 100644
--- a/net/x25/x25_link.c
+++ b/drivers/staging/x25/x25_link.c
@@ -26,7 +26,7 @@
 #include <linux/skbuff.h>
 #include <linux/uaccess.h>
 #include <linux/init.h>
-#include <net/x25.h>
+#include "x25.h"
 
 LIST_HEAD(x25_neigh_list);
 DEFINE_RWLOCK(x25_neigh_list_lock);
diff --git a/net/x25/x25_out.c b/drivers/staging/x25/x25_out.c
similarity index 99%
rename from net/x25/x25_out.c
rename to drivers/staging/x25/x25_out.c
index dbc0940bf35f..8f4d55e378ee 100644
--- a/net/x25/x25_out.c
+++ b/drivers/staging/x25/x25_out.c
@@ -23,7 +23,7 @@
 #include <linux/string.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <net/x25.h>
+#include "x25.h"
 
 static int x25_pacsize_to_bytes(unsigned int pacsize)
 {
diff --git a/net/x25/x25_proc.c b/drivers/staging/x25/x25_proc.c
similarity index 99%
rename from net/x25/x25_proc.c
rename to drivers/staging/x25/x25_proc.c
index 3bddcbdf2e40..4c36e64a719a 100644
--- a/net/x25/x25_proc.c
+++ b/drivers/staging/x25/x25_proc.c
@@ -18,7 +18,7 @@
 #include <linux/export.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
-#include <net/x25.h>
+#include "x25.h"
 
 #ifdef CONFIG_PROC_FS
 
diff --git a/net/x25/x25_route.c b/drivers/staging/x25/x25_route.c
similarity index 99%
rename from net/x25/x25_route.c
rename to drivers/staging/x25/x25_route.c
index b8e94d58d0f1..60f18964be0f 100644
--- a/net/x25/x25_route.c
+++ b/drivers/staging/x25/x25_route.c
@@ -15,7 +15,7 @@
 #include <linux/if_arp.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <net/x25.h>
+#include "x25.h"
 
 LIST_HEAD(x25_route_list);
 DEFINE_RWLOCK(x25_route_list_lock);
diff --git a/net/x25/x25_subr.c b/drivers/staging/x25/x25_subr.c
similarity index 99%
rename from net/x25/x25_subr.c
rename to drivers/staging/x25/x25_subr.c
index 8aa415a38814..7004ee53a6b0 100644
--- a/net/x25/x25_subr.c
+++ b/drivers/staging/x25/x25_subr.c
@@ -26,7 +26,7 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <net/x25.h>
+#include "x25.h"
 
 /*
  *	This routine purges all of the queues of frames.
diff --git a/net/x25/x25_timer.c b/drivers/staging/x25/x25_timer.c
similarity index 99%
rename from net/x25/x25_timer.c
rename to drivers/staging/x25/x25_timer.c
index 9376365cdcc9..3edcae15f897 100644
--- a/net/x25/x25_timer.c
+++ b/drivers/staging/x25/x25_timer.c
@@ -19,7 +19,7 @@
 #include <linux/timer.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <net/x25.h>
+#include "x25.h"
 
 static void x25_heartbeat_expiry(struct timer_list *t);
 static void x25_timer_expiry(struct timer_list *t);
diff --git a/include/Kbuild b/include/Kbuild
index 64ab3aac7379..e26750d6ec96 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -276,7 +276,6 @@ header-test-			+= linux/kvm_host.h
 header-test-			+= linux/kvm_irqfd.h
 header-test-			+= linux/kvm_para.h
 header-test-			+= linux/lantiq.h
-header-test-			+= linux/lapb.h
 header-test-			+= linux/latencytop.h
 header-test-			+= linux/led-lm3530.h
 header-test-			+= linux/leds-bd2802.h
@@ -835,7 +834,6 @@ header-test-			+= net/ipcomp.h
 header-test-			+= net/ipconfig.h
 header-test-			+= net/iucv/af_iucv.h
 header-test-			+= net/iucv/iucv.h
-header-test-			+= net/lapb.h
 header-test-			+= net/llc_c_ac.h
 header-test-			+= net/llc_c_st.h
 header-test-			+= net/llc_s_ac.h
diff --git a/net/Kconfig b/net/Kconfig
index 3101bfcbdd7a..50681046ec03 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -220,8 +220,6 @@ source "net/8021q/Kconfig"
 source "net/decnet/Kconfig"
 source "net/llc/Kconfig"
 source "drivers/net/appletalk/Kconfig"
-source "net/x25/Kconfig"
-source "net/lapb/Kconfig"
 source "net/phonet/Kconfig"
 source "net/6lowpan/Kconfig"
 source "net/ieee802154/Kconfig"
diff --git a/net/Makefile b/net/Makefile
index 449fc0b221f8..3473e68e7abe 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -26,8 +26,6 @@ obj-$(CONFIG_NET_KEY)		+= key/
 obj-$(CONFIG_BRIDGE)		+= bridge/
 obj-$(CONFIG_NET_DSA)		+= dsa/
 obj-$(CONFIG_ATALK)		+= appletalk/
-obj-$(CONFIG_X25)		+= x25/
-obj-$(CONFIG_LAPB)		+= lapb/
 obj-$(CONFIG_NETROM)		+= netrom/
 obj-$(CONFIG_ROSE)		+= rose/
 obj-$(CONFIG_AX25)		+= ax25/
diff --git a/net/lapb/Kconfig b/net/lapb/Kconfig
deleted file mode 100644
index 6acfc999c952..000000000000
--- a/net/lapb/Kconfig
+++ /dev/null
@@ -1,22 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-#
-# LAPB Data Link Drive
-#
-
-config LAPB
-	tristate "LAPB Data Link Driver"
-	---help---
-	  Link Access Procedure, Balanced (LAPB) is the data link layer (i.e.
-	  the lower) part of the X.25 protocol. It offers a reliable
-	  connection service to exchange data frames with one other host, and
-	  it is used to transport higher level protocols (mostly X.25 Packet
-	  Layer, the higher part of X.25, but others are possible as well).
-	  Usually, LAPB is used with specialized X.21 network cards, but Linux
-	  currently supports LAPB only over Ethernet connections. If you want
-	  to use LAPB connections over Ethernet, say Y here and to "LAPB over
-	  Ethernet driver" below. Read
-	  <file:Documentation/networking/lapb-module.txt> for technical
-	  details.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called lapb.  If unsure, say N.
diff --git a/net/lapb/Makefile b/net/lapb/Makefile
deleted file mode 100644
index 7be91b4c0ca0..000000000000
--- a/net/lapb/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-#
-# Makefile for the Linux LAPB layer.
-#
-
-obj-$(CONFIG_LAPB) += lapb.o
-
-lapb-y := lapb_in.o lapb_out.o lapb_subr.o lapb_timer.o lapb_iface.o
diff --git a/net/x25/Kconfig b/net/x25/Kconfig
deleted file mode 100644
index 2ecb2e5e241e..000000000000
--- a/net/x25/Kconfig
+++ /dev/null
@@ -1,34 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-#
-# CCITT X.25 Packet Layer
-#
-
-config X25
-	tristate "CCITT X.25 Packet Layer"
-	---help---
-	  X.25 is a set of standardized network protocols, similar in scope to
-	  frame relay; the one physical line from your box to the X.25 network
-	  entry point can carry several logical point-to-point connections
-	  (called "virtual circuits") to other computers connected to the X.25
-	  network. Governments, banks, and other organizations tend to use it
-	  to connect to each other or to form Wide Area Networks (WANs). Many
-	  countries have public X.25 networks. X.25 consists of two
-	  protocols: the higher level Packet Layer Protocol (PLP) (say Y here
-	  if you want that) and the lower level data link layer protocol LAPB
-	  (say Y to "LAPB Data Link Driver" below if you want that).
-
-	  You can read more about X.25 at <http://www.sangoma.com/tutorials/x25/> and
-	  <http://docwiki.cisco.com/wiki/X.25>.
-	  Information about X.25 for Linux is contained in the files
-	  <file:Documentation/networking/x25.txt> and
-	  <file:Documentation/networking/x25-iface.txt>.
-
-	  One connects to an X.25 network either with a dedicated network card
-	  using the X.21 protocol (not yet supported by Linux) or one can do
-	  X.25 over a standard telephone line using an ordinary modem (say Y
-	  to "X.25 async driver" below) or over Ethernet using an ordinary
-	  Ethernet card and the LAPB over Ethernet (say Y to "LAPB Data Link
-	  Driver" and "LAPB over Ethernet driver" below).
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called x25. If unsure, say N.
-- 
2.20.0

