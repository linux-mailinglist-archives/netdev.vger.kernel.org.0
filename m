Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8075615477E
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBFPSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38072 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=v+PzJtydJRO9Tk5W91RNpUCemT4QtYTSBwQ8mRUkMZw=; b=bAVQIcv3Kigh8UjI0x/LtERSBr
        2CKE6O9xDa2OcwHLEr7oRJfPiySCp6D8xVDq+HuziLaiacnLSxpHfrdLPax6INp9x5livASgBqCZj
        pdX1oKtw+nSK2g5Y1LrCyjo75f38vp6l4X5MT6hux300xUXkRFiUtnOMDq8sAhsnA0rP3f4PJtRTF
        Z/qzzUErCMM4NplcsA+1wPWCMZaf01UDFkKFLJc1k5/yZ28pWnTJS9UwwqLDjixhwLhjk+WSPxB3d
        ZXPVYzO4JQ8smKjiItbMpI8RDRt362DhBHj76BVRVKK6kPvjKX0csXG9Matn39vtBVncxxAUTaKFT
        4Z6NdoWQ==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziuk-0005jC-VQ; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVV-8G; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 12/28] docs: networking: convert cops.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:32 +0100
Message-Id: <d935b712ee6a192fd6b535d9ddb67fda5e876922.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.


Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/cops.rst  | 80 ++++++++++++++++++++++++++++++
 Documentation/networking/cops.txt  | 63 -----------------------
 Documentation/networking/index.rst |  1 +
 3 files changed, 81 insertions(+), 63 deletions(-)
 create mode 100644 Documentation/networking/cops.rst
 delete mode 100644 Documentation/networking/cops.txt

diff --git a/Documentation/networking/cops.rst b/Documentation/networking/cops.rst
new file mode 100644
index 000000000000..964ba80599a9
--- /dev/null
+++ b/Documentation/networking/cops.rst
@@ -0,0 +1,80 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================================
+The COPS LocalTalk Linux driver (cops.c)
+========================================
+
+By Jay Schulist <jschlst@samba.org>
+
+This driver has two modes and they are: Dayna mode and Tangent mode.
+Each mode corresponds with the type of card. It has been found
+that there are 2 main types of cards and all other cards are
+the same and just have different names or only have minor differences
+such as more IO ports. As this driver is tested it will
+become more clear exactly what cards are supported.
+
+Right now these cards are known to work with the COPS driver. The
+LT-200 cards work in a somewhat more limited capacity than the
+DL200 cards, which work very well and are in use by many people.
+
+TANGENT driver mode:
+	- Tangent ATB-II, Novell NL-1000, Daystar Digital LT-200
+
+DAYNA driver mode:
+	- Dayna DL2000/DaynaTalk PC (Half Length), COPS LT-95,
+	- Farallon PhoneNET PC III, Farallon PhoneNET PC II
+
+Other cards possibly supported mode unknown though:
+	- Dayna DL2000 (Full length)
+
+The COPS driver defaults to using Dayna mode. To change the driver's
+mode if you built a driver with dual support use board_type=1 or
+board_type=2 for Dayna or Tangent with insmod.
+
+Operation/loading of the driver
+===============================
+
+Use modprobe like this:	/sbin/modprobe cops.o (IO #) (IRQ #)
+If you do not specify any options the driver will try and use the IO = 0x240,
+IRQ = 5. As of right now I would only use IRQ 5 for the card, if autoprobing.
+
+To load multiple COPS driver Localtalk cards you can do one of the following::
+
+	insmod cops io=0x240 irq=5
+	insmod -o cops2 cops io=0x260 irq=3
+
+Or in lilo.conf put something like this::
+
+	append="ether=5,0x240,lt0 ether=3,0x260,lt1"
+
+Then bring up the interface with ifconfig. It will look something like this::
+
+  lt0       Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-F7-00-00-00-00-00-00-00-00
+	    inet addr:192.168.1.2  Bcast:192.168.1.255  Mask:255.255.255.0
+	    UP BROADCAST RUNNING NOARP MULTICAST  MTU:600  Metric:1
+	    RX packets:0 errors:0 dropped:0 overruns:0 frame:0
+	    TX packets:0 errors:0 dropped:0 overruns:0 carrier:0 coll:0
+
+Netatalk Configuration
+======================
+
+You will need to configure atalkd with something like the following to make
+it work with the cops.c driver.
+
+* For single LTalk card use::
+
+    dummy -seed -phase 2 -net 2000 -addr 2000.10 -zone "1033"
+    lt0 -seed -phase 1 -net 1000 -addr 1000.50 -zone "1033"
+
+* For multiple cards, Ethernet and LocalTalk::
+
+    eth0 -seed -phase 2 -net 3000 -addr 3000.20 -zone "1033"
+    lt0 -seed -phase 1 -net 1000 -addr 1000.50 -zone "1033"
+
+* For multiple LocalTalk cards, and an Ethernet card.
+
+* Order seems to matter here, Ethernet last::
+
+    lt0 -seed -phase 1 -net 1000 -addr 1000.10 -zone "LocalTalk1"
+    lt1 -seed -phase 1 -net 2000 -addr 2000.20 -zone "LocalTalk2"
+    eth0 -seed -phase 2 -net 3000 -addr 3000.30 -zone "EtherTalk"
diff --git a/Documentation/networking/cops.txt b/Documentation/networking/cops.txt
deleted file mode 100644
index 3e344b448e07..000000000000
--- a/Documentation/networking/cops.txt
+++ /dev/null
@@ -1,63 +0,0 @@
-Text File for the COPS LocalTalk Linux driver (cops.c).
-	By Jay Schulist <jschlst@samba.org>
-
-This driver has two modes and they are: Dayna mode and Tangent mode.
-Each mode corresponds with the type of card. It has been found
-that there are 2 main types of cards and all other cards are
-the same and just have different names or only have minor differences
-such as more IO ports. As this driver is tested it will
-become more clear exactly what cards are supported. 
-
-Right now these cards are known to work with the COPS driver. The
-LT-200 cards work in a somewhat more limited capacity than the
-DL200 cards, which work very well and are in use by many people.
-
-TANGENT driver mode:
-	Tangent ATB-II, Novell NL-1000, Daystar Digital LT-200
-DAYNA driver mode:
-	Dayna DL2000/DaynaTalk PC (Half Length), COPS LT-95,
-	Farallon PhoneNET PC III, Farallon PhoneNET PC II
-Other cards possibly supported mode unknown though:
-	Dayna DL2000 (Full length)
-
-The COPS driver defaults to using Dayna mode. To change the driver's 
-mode if you built a driver with dual support use board_type=1 or
-board_type=2 for Dayna or Tangent with insmod.
-
-** Operation/loading of the driver.
-Use modprobe like this:	/sbin/modprobe cops.o (IO #) (IRQ #)
-If you do not specify any options the driver will try and use the IO = 0x240,
-IRQ = 5. As of right now I would only use IRQ 5 for the card, if autoprobing.
-
-To load multiple COPS driver Localtalk cards you can do one of the following.
-
-insmod cops io=0x240 irq=5
-insmod -o cops2 cops io=0x260 irq=3
-
-Or in lilo.conf put something like this:
-	append="ether=5,0x240,lt0 ether=3,0x260,lt1"
-
-Then bring up the interface with ifconfig. It will look something like this:
-lt0       Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-F7-00-00-00-00-00-00-00-00
-          inet addr:192.168.1.2  Bcast:192.168.1.255  Mask:255.255.255.0
-          UP BROADCAST RUNNING NOARP MULTICAST  MTU:600  Metric:1
-          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
-          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0 coll:0
-
-** Netatalk Configuration
-You will need to configure atalkd with something like the following to make
-it work with the cops.c driver.
-
-* For single LTalk card use.
-dummy -seed -phase 2 -net 2000 -addr 2000.10 -zone "1033"
-lt0 -seed -phase 1 -net 1000 -addr 1000.50 -zone "1033"
-
-* For multiple cards, Ethernet and LocalTalk.
-eth0 -seed -phase 2 -net 3000 -addr 3000.20 -zone "1033"
-lt0 -seed -phase 1 -net 1000 -addr 1000.50 -zone "1033"
-
-* For multiple LocalTalk cards, and an Ethernet card.
-* Order seems to matter here, Ethernet last.
-lt0 -seed -phase 1 -net 1000 -addr 1000.10 -zone "LocalTalk1"
-lt1 -seed -phase 1 -net 2000 -addr 2000.20 -zone "LocalTalk2"
-eth0 -seed -phase 2 -net 3000 -addr 3000.30 -zone "EtherTalk"
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index ef13fa26b4df..2201f848d8f7 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -44,6 +44,7 @@ Contents:
    baycom
    bonding
    cdc_mbim
+   cops
 
 .. only::  subproject and html
 
-- 
2.24.1

