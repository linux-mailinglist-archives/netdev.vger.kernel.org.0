Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88441C0174
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgD3QGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AC822497A;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=CiNEctCJ4qmZ6A7gwBTuE6/yRFv3lOhbxOpl1PZPlZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6X+nqwhEHeI2O8KFeO7SKuPclwQunTHnqA0A1W0f+gg3tlk2Xo19aDNIvEe85pJr
         mHITqAI7ie86IHUzlfODP3YTJbzch1tSuLCHh6UMWnBtPBiSBeq0HUmkvDiLw8F+qK
         PVZwXiwFKkVcd2lA3jCC2u87nqtElB+0RCN6VZ2o=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFx-JX; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 23/37] docs: networking: convert ray_cs.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:18 +0200
Message-Id: <2a554708f40ab8fd34905755518eeeda315cf4c9.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- use copyright symbol;
- add a document title;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{ray_cs.txt => ray_cs.rst}     | 101 ++++++++++--------
 drivers/net/wireless/Kconfig                  |   2 +-
 3 files changed, 60 insertions(+), 44 deletions(-)
 rename Documentation/networking/{ray_cs.txt => ray_cs.rst} (65%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 85bc52d0b3a6..b7e35b0d905c 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -96,6 +96,7 @@ Contents:
    ppp_generic
    proc_net_tcp
    radiotap-headers
+   ray_cs
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ray_cs.txt b/Documentation/networking/ray_cs.rst
similarity index 65%
rename from Documentation/networking/ray_cs.txt
rename to Documentation/networking/ray_cs.rst
index c0c12307ed9d..9a46d1ae8f20 100644
--- a/Documentation/networking/ray_cs.txt
+++ b/Documentation/networking/ray_cs.rst
@@ -1,6 +1,14 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. include:: <isonum.txt>
+
+=========================
+Raylink wireless LAN card
+=========================
+
 September 21, 1999
 
-Copyright (c) 1998  Corey Thomas (corey@world.std.com)
+Copyright |copy| 1998  Corey Thomas (corey@world.std.com)
 
 This file is the documentation for the Raylink Wireless LAN card driver for
 Linux.  The Raylink wireless LAN card is a PCMCIA card which provides IEEE
@@ -13,7 +21,7 @@ wireless LAN cards.
 
 As of kernel 2.3.18, the ray_cs driver is part of the Linux kernel
 source.  My web page for the development of ray_cs is at
-http://web.ralinktech.com/ralink/Home/Support/Linux.html 
+http://web.ralinktech.com/ralink/Home/Support/Linux.html
 and I can be emailed at corey@world.std.com
 
 The kernel driver is based on ray_cs-1.62.tgz
@@ -29,6 +37,7 @@ with nondefault parameters, they can be edited in
 will find them all.
 
 Information on card services is available at:
+
 	http://pcmcia-cs.sourceforge.net/
 
 
@@ -39,72 +48,78 @@ the driver.
 Currently, ray_cs is not part of David Hinds card services package,
 so the following magic is required.
 
-At the end of the /etc/pcmcia/config.opts file, add the line: 
-source ./ray_cs.opts 
+At the end of the /etc/pcmcia/config.opts file, add the line:
+source ./ray_cs.opts
 This will make card services read the ray_cs.opts file
 when starting.  Create the file /etc/pcmcia/ray_cs.opts containing the
-following:
+following::
 
-#### start of /etc/pcmcia/ray_cs.opts ###################
-# Configuration options for Raylink Wireless LAN PCMCIA card
-device "ray_cs"
-  class "network" module "misc/ray_cs"
+  #### start of /etc/pcmcia/ray_cs.opts ###################
+  # Configuration options for Raylink Wireless LAN PCMCIA card
+  device "ray_cs"
+    class "network" module "misc/ray_cs"
 
-card "RayLink PC Card WLAN Adapter"
-  manfid 0x01a6, 0x0000
-  bind "ray_cs"
+  card "RayLink PC Card WLAN Adapter"
+    manfid 0x01a6, 0x0000
+    bind "ray_cs"
 
-module "misc/ray_cs" opts ""
-#### end of /etc/pcmcia/ray_cs.opts #####################
+  module "misc/ray_cs" opts ""
+  #### end of /etc/pcmcia/ray_cs.opts #####################
 
 
 To join an existing network with
-different parameters, contact the network administrator for the 
+different parameters, contact the network administrator for the
 configuration information, and edit /etc/pcmcia/ray_cs.opts.
 Add the parameters below between the empty quotes.
 
 Parameters for ray_cs driver which may be specified in ray_cs.opts:
 
-bc              integer         0 = normal mode (802.11 timing)
-                                1 = slow down inter frame timing to allow
-                                    operation with older breezecom access
-                                    points.
+=============== =============== =============================================
+bc              integer         0 = normal mode (802.11 timing),
+				1 = slow down inter frame timing to allow
+				operation with older breezecom access
+				points.
 
-beacon_period	integer         beacon period in Kilo-microseconds
-				legal values = must be integer multiple 
-                                               of hop dwell
-                                default = 256
+beacon_period	integer         beacon period in Kilo-microseconds,
 
-country         integer         1 = USA (default)
-                                2 = Europe
-                                3 = Japan
-                                4 = Korea
-                                5 = Spain
-                                6 = France
-                                7 = Israel
-                                8 = Australia
+				legal values = must be integer multiple
+				of hop dwell
+
+				default = 256
+
+country         integer         1 = USA (default),
+				2 = Europe,
+				3 = Japan,
+				4 = Korea,
+				5 = Spain,
+				6 = France,
+				7 = Israel,
+				8 = Australia
 
 essid		string		ESS ID - network name to join
+
 				string with maximum length of 32 chars
 				default value = "ADHOC_ESSID"
 
-hop_dwell	integer         hop dwell time in Kilo-microseconds 
+hop_dwell	integer         hop dwell time in Kilo-microseconds
+
 				legal values = 16,32,64,128(default),256
 
 irq_mask	integer         linux standard 16 bit value 1bit/IRQ
+
 				lsb is IRQ 0, bit 1 is IRQ 1 etc.
 				Used to restrict choice of IRQ's to use.
-                                Recommended method for controlling
-                                interrupts is in /etc/pcmcia/config.opts
+				Recommended method for controlling
+				interrupts is in /etc/pcmcia/config.opts
 
-net_type	integer		0 (default) = adhoc network, 
+net_type	integer		0 (default) = adhoc network,
 				1 = infrastructure
 
 phy_addr	string          string containing new MAC address in
 				hex, must start with x eg
 				x00008f123456
 
-psm		integer         0 = continuously active
+psm		integer         0 = continuously active,
 				1 = power save mode (not useful yet)
 
 pc_debug	integer		(0-5) larger values for more verbose
@@ -114,14 +129,14 @@ ray_debug	integer		Replaced with pc_debug
 
 ray_mem_speed   integer         defaults to 500
 
-sniffer         integer         0 = not sniffer (default)
-                                1 = sniffer which can be used to record all
-                                    network traffic using tcpdump or similar, 
-                                    but no normal network use is allowed.
+sniffer         integer         0 = not sniffer (default),
+				1 = sniffer which can be used to record all
+				network traffic using tcpdump or similar,
+				but no normal network use is allowed.
 
-translate	integer		0 = no translation (encapsulate frames)
+translate	integer		0 = no translation (encapsulate frames),
 				1 = translation    (RFC1042/802.1)
-
+=============== =============== =============================================
 
 More on sniffer mode:
 
@@ -136,7 +151,7 @@ package which parses the 802.11 headers.
 
 Known Problems and missing features
 
-        Does not work with non x86
+	Does not work with non x86
 
 	Does not work with SMP
 
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 1c98d781ae49..15b0ad171f4c 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -57,7 +57,7 @@ config PCMCIA_RAYCS
 	---help---
 	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
 	  (PC-card) wireless Ethernet networking card to your computer.
-	  Please read the file <file:Documentation/networking/ray_cs.txt> for
+	  Please read the file <file:Documentation/networking/ray_cs.rst> for
 	  details.
 
 	  To compile this driver as a module, choose M here: the module will be
-- 
2.25.4

