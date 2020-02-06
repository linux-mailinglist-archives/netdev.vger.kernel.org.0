Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70AD81547B6
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgBFPSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727567AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=QgU2YXtK8JhIR8sXlz9vfHZraerok3TnGVbMXzCh8os=; b=TzbiuPkJqsGKqG8F7imLQjjC9B
        yVa4lGO0gd7dsYvu+807KcFSRv7rqyVQwSAskmsOCRBSJ0NPleA1uTB8CVxFlPzENQFy5mJ+4Rok8
        hhA1vgIbvXJ5VW9xenneNqdRhNrsBOfAk4ZmfOlAvDlwru3TXV09hqSENT9ow2IJCc31vNTiPT8lk
        UA7MiUq6loUfx2+PvnhJ6Sv6MaztRvqX1iCsm5mxJdjXt72C+FIpnkPthM3uUySI/ATbVavUwjLko
        19GEym0hL3C/ZwhJ2JKfu4TM+FLjYgzAtu2qODYzT4ZiFruljkrf9y43b/j9KJbsfautF/G2+X/UJ
        sPy5eJTQ==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziuk-0005jM-WC; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVR-6t; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 11/28] docs: networking: convert cdc_mbim.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:31 +0100
Message-Id: <f671aae2b28bd65a879e164d40fce9e52b96199a.1581002063.git.mchehab+huawei@kernel.org>
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
- mark code blocks and literals as such;
- use :field: markup;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{cdc_mbim.txt => cdc_mbim.rst} | 76 +++++++++++--------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 47 insertions(+), 30 deletions(-)
 rename Documentation/networking/{cdc_mbim.txt => cdc_mbim.rst} (88%)

diff --git a/Documentation/networking/cdc_mbim.txt b/Documentation/networking/cdc_mbim.rst
similarity index 88%
rename from Documentation/networking/cdc_mbim.txt
rename to Documentation/networking/cdc_mbim.rst
index 4e68f0bc5dba..0048409c06b4 100644
--- a/Documentation/networking/cdc_mbim.txt
+++ b/Documentation/networking/cdc_mbim.rst
@@ -1,5 +1,8 @@
-     cdc_mbim - Driver for CDC MBIM Mobile Broadband modems
-    ========================================================
+.. SPDX-License-Identifier: GPL-2.0
+
+======================================================
+cdc_mbim - Driver for CDC MBIM Mobile Broadband modems
+======================================================
 
 The cdc_mbim driver supports USB devices conforming to the "Universal
 Serial Bus Communications Class Subclass Specification for Mobile
@@ -19,9 +22,9 @@ by a cdc_ncm driver parameter:
 
 prefer_mbim
 -----------
-Type:          Boolean
-Valid Range:   N/Y (0-1)
-Default Value: Y (MBIM is preferred)
+:Type:          Boolean
+:Valid Range:   N/Y (0-1)
+:Default Value: Y (MBIM is preferred)
 
 This parameter sets the system policy for NCM/MBIM functions.  Such
 functions will be handled by either the cdc_ncm driver or the cdc_mbim
@@ -44,11 +47,13 @@ userspace MBIM management application always is required to enable a
 MBIM function.
 
 Such userspace applications includes, but are not limited to:
+
  - mbimcli (included with the libmbim [3] library), and
  - ModemManager [4]
 
 Establishing a MBIM IP session reequires at least these actions by the
 management application:
+
  - open the control channel
  - configure network connection settings
  - connect to network
@@ -76,7 +81,7 @@ complies with all the control channel requirements in [1].
 
 The cdc-wdmX device is created as a child of the MBIM control
 interface USB device.  The character device associated with a specific
-MBIM function can be looked up using sysfs.  For example:
+MBIM function can be looked up using sysfs.  For example::
 
  bjorn@nemi:~$ ls /sys/bus/usb/drivers/cdc_mbim/2-4:2.12/usbmisc
  cdc-wdm0
@@ -119,13 +124,15 @@ negotiated control message size.
 
 
 /dev/cdc-wdmX ioctl()
---------------------
+---------------------
 IOCTL_WDM_MAX_COMMAND: Get Maximum Command Size
 This ioctl returns the wMaxControlMessage field of the CDC MBIM
 functional descriptor for MBIM devices.  This is intended as a
 convenience, eliminating the need to parse the USB descriptors from
 userspace.
 
+::
+
 	#include <stdio.h>
 	#include <fcntl.h>
 	#include <sys/ioctl.h>
@@ -178,7 +185,7 @@ VLAN links prior to establishing MBIM IP sessions where the SessionId
 is greater than 0. These links can be added by using the normal VLAN
 kernel interfaces, either ioctl or netlink.
 
-For example, adding a link for a MBIM IP session with SessionId 3:
+For example, adding a link for a MBIM IP session with SessionId 3::
 
   ip link add link wwan0 name wwan0.3 type vlan id 3
 
@@ -207,6 +214,7 @@ the stream to the end user in an appropriate way for the stream type.
 The network device ABI requires a dummy ethernet header for every DSS
 data frame being transported.  The contents of this header is
 arbitrary, with the following exceptions:
+
  - TX frames using an IP protocol (0x0800 or 0x86dd) will be dropped
  - RX frames will have the protocol field set to ETH_P_802_3 (but will
    not be properly formatted 802.3 frames)
@@ -218,7 +226,7 @@ adding the dummy ethernet header on TX and stripping it on RX.
 
 This is a simple example using tools commonly available, exporting
 DssSessionId 5 as a pty character device pointed to by a /dev/nmea
-symlink:
+symlink::
 
   ip link add link wwan0 name wwan0.dss5 type vlan id 261
   ip link set dev wwan0.dss5 up
@@ -236,7 +244,7 @@ map frames to the correct DSS session and adding 18 byte VLAN ethernet
 headers with the appropriate tag on TX.  In this case using a socket
 filter is recommended, matching only the DSS VLAN subset. This avoid
 unnecessary copying of unrelated IP session data to userspace.  For
-example:
+example::
 
   static struct sock_filter dssfilter[] = {
 	/* use special negative offsets to get VLAN tag */
@@ -249,11 +257,11 @@ example:
 	BPF_JUMP(BPF_JMP|BPF_JGE|BPF_K, 512, 3, 0),	/* 511 is last DSS VLAN */
 
 	/* verify ethertype */
-        BPF_STMT(BPF_LD|BPF_H|BPF_ABS, 2 * ETH_ALEN),
-        BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, ETH_P_802_3, 0, 1),
+	BPF_STMT(BPF_LD|BPF_H|BPF_ABS, 2 * ETH_ALEN),
+	BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, ETH_P_802_3, 0, 1),
 
-        BPF_STMT(BPF_RET|BPF_K, (u_int)-1),	/* accept */
-        BPF_STMT(BPF_RET|BPF_K, 0),		/* ignore */
+	BPF_STMT(BPF_RET|BPF_K, (u_int)-1),	/* accept */
+	BPF_STMT(BPF_RET|BPF_K, 0),		/* ignore */
   };
 
 
@@ -266,6 +274,7 @@ network device.
 
 This mapping implies a few restrictions on multiplexed IPS and DSS
 sessions, which may not always be practical:
+
  - no IPS or DSS session can use a frame size greater than the MTU on
    IP session 0
  - no IPS or DSS session can be in the up state unless the network
@@ -280,7 +289,7 @@ device.
 
 Tip: It might be less confusing to the end user to name this VLAN
 subdevice after the MBIM SessionID instead of the VLAN ID.  For
-example:
+example::
 
   ip link add link wwan0 name wwan0.0 type vlan id 4094
 
@@ -290,7 +299,7 @@ VLAN mapping
 
 Summarizing the cdc_mbim driver mapping described above, we have this
 relationship between VLAN tags on the wwanY network device and MBIM
-sessions on the shared USB data channel:
+sessions on the shared USB data channel::
 
   VLAN ID       MBIM type   MBIM SessionID           Notes
   ---------------------------------------------------------
@@ -310,30 +319,37 @@ sessions on the shared USB data channel:
 References
 ==========
 
-[1] USB Implementers Forum, Inc. - "Universal Serial Bus
-      Communications Class Subclass Specification for Mobile Broadband
-      Interface Model", Revision 1.0 (Errata 1), May 1, 2013
+ 1) USB Implementers Forum, Inc. - "Universal Serial Bus
+    Communications Class Subclass Specification for Mobile Broadband
+    Interface Model", Revision 1.0 (Errata 1), May 1, 2013
+
       - http://www.usb.org/developers/docs/devclass_docs/
 
-[2] USB Implementers Forum, Inc. - "Universal Serial Bus
-      Communications Class Subclass Specifications for Network Control
-      Model Devices", Revision 1.0 (Errata 1), November 24, 2010
+ 2) USB Implementers Forum, Inc. - "Universal Serial Bus
+    Communications Class Subclass Specifications for Network Control
+    Model Devices", Revision 1.0 (Errata 1), November 24, 2010
+
       - http://www.usb.org/developers/docs/devclass_docs/
 
-[3] libmbim - "a glib-based library for talking to WWAN modems and
-      devices which speak the Mobile Interface Broadband Model (MBIM)
-      protocol"
+ 3) libmbim - "a glib-based library for talking to WWAN modems and
+    devices which speak the Mobile Interface Broadband Model (MBIM)
+    protocol"
+
       - http://www.freedesktop.org/wiki/Software/libmbim/
 
-[4] ModemManager - "a DBus-activated daemon which controls mobile
-      broadband (2G/3G/4G) devices and connections"
+ 4) ModemManager - "a DBus-activated daemon which controls mobile
+    broadband (2G/3G/4G) devices and connections"
+
       - http://www.freedesktop.org/wiki/Software/ModemManager/
 
-[5] "MBIM (Mobile Broadband Interface Model) Registry"
+ 5) "MBIM (Mobile Broadband Interface Model) Registry"
+
        - http://compliance.usb.org/mbim/
 
-[6] "/sys/kernel/debug/usb/devices output format"
+ 6) "/sys/kernel/debug/usb/devices output format"
+
        - Documentation/driver-api/usb/usb.rst
 
-[7] "/sys/bus/usb/devices/.../descriptors"
+ 7) "/sys/bus/usb/devices/.../descriptors"
+
        - Documentation/ABI/stable/sysfs-bus-usb
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 26ea79cecb9d..ef13fa26b4df 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -43,6 +43,7 @@ Contents:
    ax25
    baycom
    bonding
+   cdc_mbim
 
 .. only::  subproject and html
 
-- 
2.24.1

