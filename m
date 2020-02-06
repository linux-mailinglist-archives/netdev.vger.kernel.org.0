Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD391547B1
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgBFPSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ak/KbW+gdVbw1EI9JpPND+zd9rSSb3zzdRYWVU3zH1U=; b=hyXtZlOkgro8tu3yKa+0jhLiAc
        jU+gswC/2PqXFgy8ZtV8Wg1ujIU983w9lcx/VAwvw5By0SaJfVMRtCRDRuNXxFFmPoRBhFFJV6X1a
        FdjZgxlKkPiujapmLdxSJMv7hDEkVsn/zHK6zkIQSRy8YnvHNCwMMIdLtI+m0vPEStXBFsX1NSLAX
        wplCfa8nRIal8Js/QaAZVas+TCPgWo6v/TBhRMiT/Rp1gW4hXDv/4/5YBDCtSyng9RJApC2EuiaNu
        4Dkj1zxeqpihJ7Hba+D5Cfq/MydwKXvW04RkpBW9xDhOBwfk10awVtE4qt4uDPNyOUD8whNbtanPZ
        Q7fLnsdQ==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jY-2e; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oVl-FH; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-decnet-user@lists.sourceforge.net
Subject: [PATCH 16/28] docs: networking: convert decnet.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:36 +0100
Message-Id: <9b3a8f28718aa8badb1c7b9b13a0499f19af4281.1581002063.git.mchehab+huawei@kernel.org>
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
- mark lists as such;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{decnet.txt => decnet.rst}     | 77 +++++++++++--------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 46 insertions(+), 32 deletions(-)
 rename Documentation/networking/{decnet.txt => decnet.rst} (87%)

diff --git a/Documentation/networking/decnet.txt b/Documentation/networking/decnet.rst
similarity index 87%
rename from Documentation/networking/decnet.txt
rename to Documentation/networking/decnet.rst
index d192f8b9948b..b8bc11ff8370 100644
--- a/Documentation/networking/decnet.txt
+++ b/Documentation/networking/decnet.rst
@@ -1,26 +1,31 @@
-                    Linux DECnet Networking Layer Information
-                   ===========================================
+.. SPDX-License-Identifier: GPL-2.0
 
-1) Other documentation....
+=========================================
+Linux DECnet Networking Layer Information
+=========================================
 
-   o Project Home Pages
-       http://www.chygwyn.com/                      	    - Kernel info
-       http://linux-decnet.sourceforge.net/                - Userland tools
-       http://www.sourceforge.net/projects/linux-decnet/   - Status page
+1. Other documentation....
+==========================
 
-2) Configuring the kernel
+   - Project Home Pages
+     - http://www.chygwyn.com/				   - Kernel info
+     - http://linux-decnet.sourceforge.net/                - Userland tools
+     - http://www.sourceforge.net/projects/linux-decnet/   - Status page
+
+2. Configuring the kernel
+=========================
 
 Be sure to turn on the following options:
 
-    CONFIG_DECNET (obviously)
-    CONFIG_PROC_FS (to see what's going on)
-    CONFIG_SYSCTL (for easy configuration)
+    - CONFIG_DECNET (obviously)
+    - CONFIG_PROC_FS (to see what's going on)
+    - CONFIG_SYSCTL (for easy configuration)
 
 if you want to try out router support (not properly debugged yet)
 you'll need the following options as well...
 
-    CONFIG_DECNET_ROUTER (to be able to add/delete routes)
-    CONFIG_NETFILTER (will be required for the DECnet routing daemon)
+    - CONFIG_DECNET_ROUTER (to be able to add/delete routes)
+    - CONFIG_NETFILTER (will be required for the DECnet routing daemon)
 
 Don't turn on SIOCGIFCONF support for DECnet unless you are really sure
 that you need it, in general you won't and it can cause ifconfig to
@@ -29,7 +34,7 @@ malfunction.
 Run time configuration has changed slightly from the 2.4 system. If you
 want to configure an endnode, then the simplified procedure is as follows:
 
- o Set the MAC address on your ethernet card before starting _any_ other
+ - Set the MAC address on your ethernet card before starting _any_ other
    network protocols.
 
 As soon as your network card is brought into the UP state, DECnet should
@@ -37,7 +42,8 @@ start working. If you need something more complicated or are unsure how
 to set the MAC address, see the next section. Also all configurations which
 worked with 2.4 will work under 2.5 with no change.
 
-3) Command line options
+3. Command line options
+=======================
 
 You can set a DECnet address on the kernel command line for compatibility
 with the 2.4 configuration procedure, but in general it's not needed any more.
@@ -56,7 +62,7 @@ interface then you won't see any entries in /proc/net/neigh for the local
 host until such time as you start a connection. This doesn't affect the
 operation of the local communications in any other way though.
 
-The kernel command line takes options looking like the following:
+The kernel command line takes options looking like the following::
 
     decnet.addr=1,2
 
@@ -82,7 +88,7 @@ address of the node in order for it to be autoconfigured (and then appear in
 FTP sites called dn2ethaddr which can compute the correct ethernet
 address to use. The address can be set by ifconfig either before or
 at the time the device is brought up. If you are using RedHat you can
-add the line:
+add the line::
 
     MACADDR=AA:00:04:00:03:04
 
@@ -95,7 +101,7 @@ verify with iproute2).
 The default device for routing can be set through the /proc filesystem
 by setting /proc/sys/net/decnet/default_device to the
 device you want DECnet to route packets out of when no specific route
-is available. Usually this will be eth0, for example:
+is available. Usually this will be eth0, for example::
 
     echo -n "eth0" >/proc/sys/net/decnet/default_device
 
@@ -106,7 +112,9 @@ confirm that by looking in the default_device file of course.
 There is a list of what the other files under /proc/sys/net/decnet/ do
 on the kernel patch web site (shown above).
 
-4) Run time kernel configuration
+4. Run time kernel configuration
+================================
+
 
 This is either done through the sysctl/proc interface (see the kernel web
 pages for details on what the various options do) or through the iproute2
@@ -122,20 +130,21 @@ since its the _only_ way to add and delete routes currently. Eventually
 there will be a routing daemon to send and receive routing messages for
 each interface and update the kernel routing tables accordingly. The
 routing daemon will use netfilter to listen to routing packets, and
-rtnetlink to update the kernels routing tables. 
+rtnetlink to update the kernels routing tables.
 
 The DECnet raw socket layer has been removed since it was there purely
 for use by the routing daemon which will now use netfilter (a much cleaner
 and more generic solution) instead.
 
-5) How can I tell if its working ?
+5. How can I tell if its working?
+=================================
 
 Here is a quick guide of what to look for in order to know if your DECnet
 kernel subsystem is working.
 
    - Is the node address set (see /proc/sys/net/decnet/node_address)
-   - Is the node of the correct type 
-                             (see /proc/sys/net/decnet/conf/<dev>/forwarding)
+   - Is the node of the correct type
+     (see /proc/sys/net/decnet/conf/<dev>/forwarding)
    - Is the Ethernet MAC address of each Ethernet card set to match
      the DECnet address. If in doubt use the dn2ethaddr utility available
      at the ftp archive.
@@ -160,7 +169,8 @@ kernel subsystem is working.
      network, and see if you can obtain the same results.
    - At this point you are on your own... :-)
 
-6) How to send a bug report
+6. How to send a bug report
+===========================
 
 If you've found a bug and want to report it, then there are several things
 you can do to help me work out exactly what it is that is wrong. Useful
@@ -175,18 +185,19 @@ information (_most_ of which _is_ _essential_) includes:
  - How much data was being transferred ?
  - Was the network congested ?
  - How can the problem be reproduced ?
- - Can you use tcpdump to get a trace ? (N.B. Most (all?) versions of 
+ - Can you use tcpdump to get a trace ? (N.B. Most (all?) versions of
    tcpdump don't understand how to dump DECnet properly, so including
    the hex listing of the packet contents is _essential_, usually the -x flag.
    You may also need to increase the length grabbed with the -s flag. The
    -e flag also provides very useful information (ethernet MAC addresses))
 
-7) MAC FAQ
+7. MAC FAQ
+==========
 
 A quick FAQ on ethernet MAC addresses to explain how Linux and DECnet
-interact and how to get the best performance from your hardware. 
+interact and how to get the best performance from your hardware.
 
-Ethernet cards are designed to normally only pass received network frames 
+Ethernet cards are designed to normally only pass received network frames
 to a host computer when they are addressed to it, or to the broadcast address.
 
 Linux has an interface which allows the setting of extra addresses for
@@ -197,8 +208,8 @@ significant processor time and bus bandwidth can be used up on a busy
 network (see the NAPI documentation for a longer explanation of these
 effects).
 
-DECnet makes use of this interface to allow running DECnet on an ethernet 
-card which has already been configured using TCP/IP (presumably using the 
+DECnet makes use of this interface to allow running DECnet on an ethernet
+card which has already been configured using TCP/IP (presumably using the
 built in MAC address of the card, as usual) and/or to allow multiple DECnet
 addresses on each physical interface. If you do this, be aware that if your
 ethernet card doesn't support perfect hashing in its MAC address filter
@@ -210,7 +221,8 @@ to gain the best efficiency. Better still is to use a card which supports
 NAPI as well.
 
 
-8) Mailing list
+8. Mailing list
+===============
 
 If you are keen to get involved in development, or want to ask questions
 about configuration, or even just report bugs, then there is a mailing
@@ -218,7 +230,8 @@ list that you can join, details are at:
 
 http://sourceforge.net/mail/?group_id=4993
 
-9) Legal Info
+9. Legal Info
+=============
 
 The Linux DECnet project team have placed their code under the GPL. The
 software is provided "as is" and without warranty express or implied.
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 7c815ffb1403..3acf02aaacee 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -48,6 +48,7 @@ Contents:
    cxacru
    dccp
    dctcp
+   decnet
 
 .. only::  subproject and html
 
-- 
2.24.1

