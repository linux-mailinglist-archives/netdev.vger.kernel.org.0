Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BF31BB117
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgD0WDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:03:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgD0WCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:00 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2ECC22240;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=MIpKEbXSntTtK5lZR5Rer4SXA8vyJjpcHy/mKV6KGgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmDKgTM8JRvUHsOcdre2pilaXJ65LFa5sa0JmZnZ8hpt4MLANc2i+yYm1GLYFXHVU
         BW8I27rfZiA9aITnSRn7PbdPVJ6s56uRGR5d30yn911mdNOvFhVCRw1kDXDpQW4d87
         OQmgdZ49lJP3DjNVKUj9a/ErDEor8QLBVJRY9GGs=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Ipn-6e; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 27/38] docs: networking: convert gtp.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:42 +0200
Message-Id: <f65f9da0b1d46247483b97b8a25a3e04e6a69472.1588024424.git.mchehab+huawei@kernel.org>
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
- add notes markups;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/{gtp.txt => gtp.rst} | 95 +++++++++++--------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 59 insertions(+), 37 deletions(-)
 rename Documentation/networking/{gtp.txt => gtp.rst} (79%)

diff --git a/Documentation/networking/gtp.txt b/Documentation/networking/gtp.rst
similarity index 79%
rename from Documentation/networking/gtp.txt
rename to Documentation/networking/gtp.rst
index 6966bbec1ecb..1563fb94b289 100644
--- a/Documentation/networking/gtp.txt
+++ b/Documentation/networking/gtp.rst
@@ -1,12 +1,18 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================================
 The Linux kernel GTP tunneling module
-======================================================================
-Documentation by Harald Welte <laforge@gnumonks.org> and
-                 Andreas Schultz <aschultz@tpip.net>
+=====================================
+
+Documentation by
+		 Harald Welte <laforge@gnumonks.org> and
+		 Andreas Schultz <aschultz@tpip.net>
 
 In 'drivers/net/gtp.c' you are finding a kernel-level implementation
 of a GTP tunnel endpoint.
 
-== What is GTP ==
+What is GTP
+===========
 
 GTP is the Generic Tunnel Protocol, which is a 3GPP protocol used for
 tunneling User-IP payload between a mobile station (phone, modem)
@@ -41,7 +47,8 @@ publicly via the 3GPP website at http://www.3gpp.org/DynaReport/29060.htm
 A direct PDF link to v13.6.0 is provided for convenience below:
 http://www.etsi.org/deliver/etsi_ts/129000_129099/129060/13.06.00_60/ts_129060v130600p.pdf
 
-== The Linux GTP tunnelling module ==
+The Linux GTP tunnelling module
+===============================
 
 The module implements the function of a tunnel endpoint, i.e. it is
 able to decapsulate tunneled IP packets in the uplink originated by
@@ -70,7 +77,8 @@ Userspace :)
 The official homepage of the module is at
 https://osmocom.org/projects/linux-kernel-gtp-u/wiki
 
-== Userspace Programs with Linux Kernel GTP-U support ==
+Userspace Programs with Linux Kernel GTP-U support
+==================================================
 
 At the time of this writing, there are at least two Free Software
 implementations that implement GTP-C and can use the netlink interface
@@ -82,7 +90,8 @@ to make use of the Linux kernel GTP-U support:
 * ergw (GGSN + P-GW in Erlang):
   https://github.com/travelping/ergw
 
-== Userspace Library / Command Line Utilities ==
+Userspace Library / Command Line Utilities
+==========================================
 
 There is a userspace library called 'libgtpnl' which is based on
 libmnl and which implements a C-language API towards the netlink
@@ -90,7 +99,8 @@ interface provided by the Kernel GTP module:
 
 http://git.osmocom.org/libgtpnl/
 
-== Protocol Versions ==
+Protocol Versions
+=================
 
 There are two different versions of GTP-U: v0 [GSM TS 09.60] and v1
 [3GPP TS 29.281].  Both are implemented in the Kernel GTP module.
@@ -105,7 +115,8 @@ doesn't implement GTP-C, we don't have to worry about this.  It's the
 responsibility of the control plane implementation in userspace to
 implement that.
 
-== IPv6 ==
+IPv6
+====
 
 The 3GPP specifications indicate either IPv4 or IPv6 can be used both
 on the inner (user) IP layer, or on the outer (transport) layer.
@@ -114,22 +125,25 @@ Unfortunately, the Kernel module currently supports IPv6 neither for
 the User IP payload, nor for the outer IP layer.  Patches or other
 Contributions to fix this are most welcome!
 
-== Mailing List ==
+Mailing List
+============
 
-If yo have questions regarding how to use the Kernel GTP module from
+If you have questions regarding how to use the Kernel GTP module from
 your own software, or want to contribute to the code, please use the
 osmocom-net-grps mailing list for related discussion. The list can be
 reached at osmocom-net-gprs@lists.osmocom.org and the mailman
 interface for managing your subscription is at
 https://lists.osmocom.org/mailman/listinfo/osmocom-net-gprs
 
-== Issue Tracker ==
+Issue Tracker
+=============
 
 The Osmocom project maintains an issue tracker for the Kernel GTP-U
 module at
 https://osmocom.org/projects/linux-kernel-gtp-u/issues
 
-== History / Acknowledgements ==
+History / Acknowledgements
+==========================
 
 The Module was originally created in 2012 by Harald Welte, but never
 completed.  Pablo came in to finish the mess Harald left behind.  But
@@ -139,9 +153,11 @@ In 2015, Andreas Schultz came to the rescue and fixed lots more bugs,
 extended it with new features and finally pushed all of us to get it
 mainline, where it was merged in 4.7.0.
 
-== Architectural Details ==
+Architectural Details
+=====================
 
-=== Local GTP-U entity and tunnel identification ===
+Local GTP-U entity and tunnel identification
+--------------------------------------------
 
 GTP-U uses UDP for transporting PDU's. The receiving UDP port is 2152
 for GTPv1-U and 3386 for GTPv0-U.
@@ -164,15 +180,15 @@ Therefore:
     destination IP and the tunnel endpoint id. The source IP and port
     have no meaning and can change at any time.
 
-[3GPP TS 29.281] Section 4.3.0 defines this so:
+[3GPP TS 29.281] Section 4.3.0 defines this so::
 
-> The TEID in the GTP-U header is used to de-multiplex traffic
-> incoming from remote tunnel endpoints so that it is delivered to the
-> User plane entities in a way that allows multiplexing of different
-> users, different packet protocols and different QoS levels.
-> Therefore no two remote GTP-U endpoints shall send traffic to a
-> GTP-U protocol entity using the same TEID value except
-> for data forwarding as part of mobility procedures.
+  The TEID in the GTP-U header is used to de-multiplex traffic
+  incoming from remote tunnel endpoints so that it is delivered to the
+  User plane entities in a way that allows multiplexing of different
+  users, different packet protocols and different QoS levels.
+  Therefore no two remote GTP-U endpoints shall send traffic to a
+  GTP-U protocol entity using the same TEID value except
+  for data forwarding as part of mobility procedures.
 
 The definition above only defines that two remote GTP-U endpoints
 *should not* send to the same TEID, it *does not* forbid or exclude
@@ -183,7 +199,8 @@ multiple or unknown peers.
 Therefore, the receiving side identifies tunnels exclusively based on
 TEIDs, not based on the source IP!
 
-== APN vs. Network Device ==
+APN vs. Network Device
+======================
 
 The GTP-U driver creates a Linux network device for each Gi/SGi
 interface.
@@ -201,29 +218,33 @@ number of Gi/SGi interfaces implemented by a GGSN/P-GW.
 
 [3GPP TS 29.061] Section 11.3 makes it clear that the selection of a
 specific Gi/SGi interfaces is made through the Access Point Name
-(APN):
+(APN)::
 
-> 2. each private network manages its own addressing. In general this
->    will result in different private networks having overlapping
->    address ranges. A logically separate connection (e.g. an IP in IP
->    tunnel or layer 2 virtual circuit) is used between the GGSN/P-GW
->    and each private network.
->
->    In this case the IP address alone is not necessarily unique.  The
->    pair of values, Access Point Name (APN) and IPv4 address and/or
->    IPv6 prefixes, is unique.
+  2. each private network manages its own addressing. In general this
+     will result in different private networks having overlapping
+     address ranges. A logically separate connection (e.g. an IP in IP
+     tunnel or layer 2 virtual circuit) is used between the GGSN/P-GW
+     and each private network.
+
+     In this case the IP address alone is not necessarily unique.  The
+     pair of values, Access Point Name (APN) and IPv4 address and/or
+     IPv6 prefixes, is unique.
 
 In order to support the overlapping address range use case, each APN
 is mapped to a separate Gi/SGi interface (network device).
 
-NOTE: The Access Point Name is purely a control plane (GTP-C) concept.
-At the GTP-U level, only Tunnel Endpoint Identifiers are present in
-GTP-U packets and network devices are known
+.. note::
+
+   The Access Point Name is purely a control plane (GTP-C) concept.
+   At the GTP-U level, only Tunnel Endpoint Identifiers are present in
+   GTP-U packets and network devices are known
 
 Therefore for a given UE the mapping in IP to PDN network is:
+
   * network device + MS IP -> Peer IP + Peer TEID,
 
 and from PDN to IP network:
+
   * local GTP-U IP + TEID  -> network device
 
 Furthermore, before a received T-PDU is injected into the network
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 33afbb67f3fa..b29a08d1f941 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -62,6 +62,7 @@ Contents:
    generic-hdlc
    generic_netlink
    gen_stats
+   gtp
 
 .. only::  subproject and html
 
-- 
2.25.4

