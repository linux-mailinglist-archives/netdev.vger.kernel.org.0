Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94CE1BB0F3
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgD0WCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726355AbgD0WCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:00 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ABC721D91;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=kfeaxpOGbwlTZVDg0aWICkcxxb1d3iaKSlL4ED1+uBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCfLx/mg+fsWsOPPtIVTBifEQUg6DOuylhQon+XrGzlCJ05q1Ndy0tOs/jd+IB3iG
         5FPqPGMMcoKrYXxY36oDkU9YHa4hPVAfR07m4a/Ms0H5OcjhPwk/e4LzqHw2nhm/gK
         kZKJDI8oBvDKTrIHuZNETKcpL76dI/7RLSZz7tsY=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Ioq-TK; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 15/38] docs: networking: convert decnet.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:30 +0200
Message-Id: <1dcd53e2396aabbb8b32e038113c13f9d77f9365.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
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
 .../admin-guide/kernel-parameters.txt         |  2 +-
 .../networking/{decnet.txt => decnet.rst}     | 77 +++++++++++--------
 Documentation/networking/index.rst            |  1 +
 MAINTAINERS                                   |  2 +-
 net/decnet/Kconfig                            |  4 +-
 5 files changed, 50 insertions(+), 36 deletions(-)
 rename Documentation/networking/{decnet.txt => decnet.rst} (87%)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 942e7f59a356..cd68635370c6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -831,7 +831,7 @@
 
 	decnet.addr=	[HW,NET]
 			Format: <area>[,<node>]
-			See also Documentation/networking/decnet.txt.
+			See also Documentation/networking/decnet.rst.
 
 	default_hugepagesz=
 			[HW] The size of the default HugeTLB page. This is
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
index 9e83d3bda4e0..e17432492745 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -50,6 +50,7 @@ Contents:
    cxacru
    dccp
    dctcp
+   decnet
 
 .. only::  subproject and html
 
diff --git a/MAINTAINERS b/MAINTAINERS
index a1558eb34c45..f5214418cc19 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4739,7 +4739,7 @@ DECnet NETWORK LAYER
 L:	linux-decnet-user@lists.sourceforge.net
 S:	Orphan
 W:	http://linux-decnet.sourceforge.net
-F:	Documentation/networking/decnet.txt
+F:	Documentation/networking/decnet.rst
 F:	net/decnet/
 
 DECSTATION PLATFORM SUPPORT
diff --git a/net/decnet/Kconfig b/net/decnet/Kconfig
index 0935453ccfd5..8f98fb2f2ec9 100644
--- a/net/decnet/Kconfig
+++ b/net/decnet/Kconfig
@@ -15,7 +15,7 @@ config DECNET
 	  <http://linux-decnet.sourceforge.net/>.
 
 	  More detailed documentation is available in
-	  <file:Documentation/networking/decnet.txt>.
+	  <file:Documentation/networking/decnet.rst>.
 
 	  Be sure to say Y to "/proc file system support" and "Sysctl support"
 	  below when using DECnet, since you will need sysctl support to aid
@@ -40,4 +40,4 @@ config DECNET_ROUTER
 	  filtering" option will be required for the forthcoming routing daemon
 	  to work.
 
-	  See <file:Documentation/networking/decnet.txt> for more information.
+	  See <file:Documentation/networking/decnet.rst> for more information.
-- 
2.25.4

