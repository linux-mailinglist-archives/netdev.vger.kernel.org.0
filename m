Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C4B1547C2
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgBFPTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=3U2jOuPo2uetl5hCcVnDDEibOIXkIZxyqnB2Z+N+1fM=; b=DzfQZCl5I6Dp3nm34Ctmfbd/bv
        b6Ryxr2s6uYuVZ9o94z1LLsZYXBjoSHLTp6t66sljuVWKyVQ23nAK+01dba8PuatJ+oskFkRKKM1N
        3Qxg4dORbRb3WC2Y0QnWR0Ee0Awfs582pKMdY+imNq2lOICQy+l2D675LIXXVsGfQVManDWbgLN47
        CNVK0KjyVDc+0C3Sb6ICXI9k8gfSkEz8NwMqudLDunHQTxlcz8JQSCzT8tflHt1tr9u1tKQFbWd4P
        DPaqi+CMTlplw1k694mxePS9nmf5xxRpBn7aZFoZCD3AFqt7EwF1MKedY4PvM++y0Pwzis01qMFZf
        6lU3woKg==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jG-38; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oWO-Tz; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 25/28] docs: networking: convert generic-hdlc.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:45 +0100
Message-Id: <cd18b3d0ff03b8163784e69d80599798d9a6c897.1581002063.git.mchehab+huawei@kernel.org>
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
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../{generic-hdlc.txt => generic-hdlc.rst}    | 86 +++++++++++++------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 63 insertions(+), 24 deletions(-)
 rename Documentation/networking/{generic-hdlc.txt => generic-hdlc.rst} (75%)

diff --git a/Documentation/networking/generic-hdlc.txt b/Documentation/networking/generic-hdlc.rst
similarity index 75%
rename from Documentation/networking/generic-hdlc.txt
rename to Documentation/networking/generic-hdlc.rst
index 4eb3cc40b702..1c3bb5cb98d4 100644
--- a/Documentation/networking/generic-hdlc.txt
+++ b/Documentation/networking/generic-hdlc.rst
@@ -1,14 +1,22 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================
 Generic HDLC layer
+==================
+
 Krzysztof Halasa <khc@pm.waw.pl>
 
 
 Generic HDLC layer currently supports:
+
 1. Frame Relay (ANSI, CCITT, Cisco and no LMI)
+
    - Normal (routed) and Ethernet-bridged (Ethernet device emulation)
      interfaces can share a single PVC.
    - ARP support (no InARP support in the kernel - there is an
      experimental InARP user-space daemon available on:
      http://www.kernel.org/pub/linux/utils/net/hdlc/).
+
 2. raw HDLC - either IP (IPv4) interface or Ethernet device emulation
 3. Cisco HDLC
 4. PPP
@@ -24,19 +32,24 @@ with IEEE 802.1Q (VLANs) and 802.1D (Ethernet bridging).
 Make sure the hdlc.o and the hardware driver are loaded. It should
 create a number of "hdlc" (hdlc0 etc) network devices, one for each
 WAN port. You'll need the "sethdlc" utility, get it from:
+
 	http://www.kernel.org/pub/linux/utils/net/hdlc/
 
-Compile sethdlc.c utility:
+Compile sethdlc.c utility::
+
 	gcc -O2 -Wall -o sethdlc sethdlc.c
+
 Make sure you're using a correct version of sethdlc for your kernel.
 
 Use sethdlc to set physical interface, clock rate, HDLC mode used,
 and add any required PVCs if using Frame Relay.
-Usually you want something like:
+Usually you want something like::
 
 	sethdlc hdlc0 clock int rate 128000
 	sethdlc hdlc0 cisco interval 10 timeout 25
-or
+
+or::
+
 	sethdlc hdlc0 rs232 clock ext
 	sethdlc hdlc0 fr lmi ansi
 	sethdlc hdlc0 create 99
@@ -49,46 +62,63 @@ any IP address to it) before using pvc devices.
 
 Setting interface:
 
-* v35 | rs232 | x21 | t1 | e1 - sets physical interface for a given port
-                                if the card has software-selectable interfaces
-  loopback - activate hardware loopback (for testing only)
-* clock ext - both RX clock and TX clock external
-* clock int - both RX clock and TX clock internal
-* clock txint - RX clock external, TX clock internal
-* clock txfromrx - RX clock external, TX clock derived from RX clock
-* rate - sets clock rate in bps (for "int" or "txint" clock only)
+* v35 | rs232 | x21 | t1 | e1
+    - sets physical interface for a given port
+      if the card has software-selectable interfaces
+  loopback
+    - activate hardware loopback (for testing only)
+* clock ext
+    - both RX clock and TX clock external
+* clock int
+    - both RX clock and TX clock internal
+* clock txint
+    - RX clock external, TX clock internal
+* clock txfromrx
+    - RX clock external, TX clock derived from RX clock
+* rate
+    - sets clock rate in bps (for "int" or "txint" clock only)
 
 
 Setting protocol:
 
 * hdlc - sets raw HDLC (IP-only) mode
+
   nrz / nrzi / fm-mark / fm-space / manchester - sets transmission code
+
   no-parity / crc16 / crc16-pr0 (CRC16 with preset zeros) / crc32-itu
+
   crc16-itu (CRC16 with ITU-T polynomial) / crc16-itu-pr0 - sets parity
 
 * hdlc-eth - Ethernet device emulation using HDLC. Parity and encoding
   as above.
 
 * cisco - sets Cisco HDLC mode (IP, IPv6 and IPX supported)
+
   interval - time in seconds between keepalive packets
+
   timeout - time in seconds after last received keepalive packet before
-            we assume the link is down
+	    we assume the link is down
 
 * ppp - sets synchronous PPP mode
 
 * x25 - sets X.25 mode
 
 * fr - Frame Relay mode
+
   lmi ansi / ccitt / cisco / none - LMI (link management) type
+
   dce - Frame Relay DCE (network) side LMI instead of default DTE (user).
+
   It has nothing to do with clocks!
-  t391 - link integrity verification polling timer (in seconds) - user
-  t392 - polling verification timer (in seconds) - network
-  n391 - full status polling counter - user
-  n392 - error threshold - both user and network
-  n393 - monitored events count - both user and network
+
+  - t391 - link integrity verification polling timer (in seconds) - user
+  - t392 - polling verification timer (in seconds) - network
+  - n391 - full status polling counter - user
+  - n392 - error threshold - both user and network
+  - n393 - monitored events count - both user and network
 
 Frame-Relay only:
+
 * create n | delete n - adds / deletes PVC interface with DLCI #n.
   Newly created interface will be named pvc0, pvc1 etc.
 
@@ -101,26 +131,34 @@ Frame-Relay only:
 Board-specific issues
 ---------------------
 
-n2.o and c101.o need parameters to work:
+n2.o and c101.o need parameters to work::
 
 	insmod n2 hw=io,irq,ram,ports[:io,irq,...]
-example:
+
+example::
+
 	insmod n2 hw=0x300,10,0xD0000,01
 
-or
+or::
+
 	insmod c101 hw=irq,ram[:irq,...]
-example:
+
+example::
+
 	insmod c101 hw=9,0xdc000
 
-If built into the kernel, these drivers need kernel (command line) parameters:
+If built into the kernel, these drivers need kernel (command line) parameters::
+
 	n2.hw=io,irq,ram,ports:...
-or
+
+or::
+
 	c101.hw=irq,ram:...
 
 
 
 If you have a problem with N2, C101 or PLX200SYN card, you can issue the
-"private" command to see port's packet descriptor rings (in kernel logs):
+"private" command to see port's packet descriptor rings (in kernel logs)::
 
 	sethdlc hdlc0 private
 
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 538b9d3e838e..1f47d74fd33e 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -57,6 +57,7 @@ Contents:
    filter
    fore200e
    framerelay
+   generic-hdlc
 
 .. only::  subproject and html
 
-- 
2.24.1

