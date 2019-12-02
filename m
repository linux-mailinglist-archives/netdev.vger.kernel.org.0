Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E74D10E415
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 01:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfLBAbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 19:31:01 -0500
Received: from outpost.hi.is ([130.208.165.166]:46456 "EHLO outpost.hi.is"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbfLBAbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 19:31:01 -0500
X-Greylist: delayed 773 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Dec 2019 19:31:00 EST
Received: from inpost.hi.is (inpost.hi.is [IPv6:2a00:c88:4000:1650::165:62])
        by outpost.hi.is (8.14.7/8.14.7) with ESMTP id xB20I7Aa011912
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 2 Dec 2019 00:18:07 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 outpost.hi.is xB20I7Aa011912
Received: from hekla.rhi.hi.is (hekla.rhi.hi.is [IPv6:2a00:c88:4000:1650::165:2])
        by inpost.hi.is (8.14.7/8.14.7) with ESMTP id xB20I4FU007456
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <netdev@vger.kernel.org>; Mon, 2 Dec 2019 00:18:05 GMT
DKIM-Filter: OpenDKIM Filter v2.11.0 inpost.hi.is xB20I4FU007456
Received: from hekla.rhi.hi.is (localhost [127.0.0.1])
        by hekla.rhi.hi.is (8.14.4/8.14.4) with ESMTP id xB20I4A2029771
        for <netdev@vger.kernel.org>; Mon, 2 Dec 2019 00:18:04 GMT
Received: (from bjarniig@localhost)
        by hekla.rhi.hi.is (8.14.4/8.14.4/Submit) id xB20I4qN029770
        for netdev@vger.kernel.org; Mon, 2 Dec 2019 00:18:04 GMT
Date:   Mon, 2 Dec 2019 00:18:04 +0000
From:   Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
To:     netdev@vger.kernel.org
Subject: [PATCH] iproute2-next/man/man*: Fix unequal number of .RS and .RE
 macros
Message-ID: <20191202001804.GA29741@rhi.hi.is>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  Add missing or excessive ".RE" macros.

  Remove an excessive ".EE" macro.

Signed-off-by: Bjarni Ingi Gislason <bjarniig@rhi.hi.is>
---
 man/man7/tc-hfsc.7          | 1 +
 man/man8/devlink-dev.8      | 1 +
 man/man8/devlink-port.8     | 1 +
 man/man8/devlink-region.8   | 1 +
 man/man8/devlink-resource.8 | 1 +
 man/man8/devlink-sb.8       | 1 +
 man/man8/devlink-trap.8     | 1 +
 man/man8/ip-neighbour.8     | 1 +
 man/man8/ip-nexthop.8       | 2 --
 man/man8/ip.8               | 1 -
 man/man8/rdma-statistic.8   | 1 +
 man/man8/tc-ctinfo.8        | 1 +
 man/man8/tc-police.8        | 1 +
 man/man8/tc-sample.8        | 3 ---
 man/man8/tc-simple.8        | 1 -
 man/man8/tc-skbmod.8        | 1 +
 man/man8/tc-u32.8           | 1 +
 man/man8/tc.8               | 1 +
 18 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/man/man7/tc-hfsc.7 b/man/man7/tc-hfsc.7
index 5ae5e6b3..412b4c3b 100644
--- a/man/man7/tc-hfsc.7
+++ b/man/man7/tc-hfsc.7
@@ -56,6 +56,7 @@ RT \- realtime
 LS \- linkshare
 UL \- upperlimit
 SC \- service curve
+.RE
 .fi
 .
 .SH "BASICS OF HFSC"
diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 2c6acbd3..289935db 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -262,6 +262,7 @@ Preparing to flash
 Flashing 100%
 .br
 Flashing done
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index a639d01f..188bffb7 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -116,6 +116,7 @@ Split the specified devlink port into four ports.
 devlink port unsplit pci/0000:01:00.0/1
 .RS 4
 Unplit the specified previously split devlink port.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
diff --git a/man/man8/devlink-region.8 b/man/man8/devlink-region.8
index ff10cdbd..c6756566 100644
--- a/man/man8/devlink-region.8
+++ b/man/man8/devlink-region.8
@@ -119,6 +119,7 @@ Dump the snapshot taken from cr-space address region with ID 1
 devlink region read pci/0000:00:05.0/cr-space snapshot 1 address 0x10 legth 16
 .RS 4
 Read from address 0x10, 16 Bytes of snapshot ID 1 taken from cr-space address region
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
diff --git a/man/man8/devlink-resource.8 b/man/man8/devlink-resource.8
index b8f78806..8c315807 100644
--- a/man/man8/devlink-resource.8
+++ b/man/man8/devlink-resource.8
@@ -66,6 +66,7 @@ Shows the resources of the specified devlink device.
 devlink resource set pci/0000:01:00.0 /kvd/linear 98304
 .RS 4
 Sets the size of the specified resource for the specified devlink device.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
diff --git a/man/man8/devlink-sb.8 b/man/man8/devlink-sb.8
index 91b68189..5a5a9bb9 100644
--- a/man/man8/devlink-sb.8
+++ b/man/man8/devlink-sb.8
@@ -310,6 +310,7 @@ Show occupancy for specified port from the snapshot.
 sudo devlink sb occupancy clearmax pci/0000:03:00.0
 .RS 4
 Clear watermarks for shared buffer of specified devlink device.
+.RE
 
 
 .SH SEE ALSO
diff --git a/man/man8/devlink-trap.8 b/man/man8/devlink-trap.8
index 4f079eb8..db19fe4c 100644
--- a/man/man8/devlink-trap.8
+++ b/man/man8/devlink-trap.8
@@ -127,6 +127,7 @@ Show attributes and statistics of a specific packet trap group.
 devlink trap set pci/0000:01:00.0 trap source_mac_is_multicast action trap
 .RS 4
 Set the action of a specific packet trap to 'trap'.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
diff --git a/man/man8/ip-neighbour.8 b/man/man8/ip-neighbour.8
index bc77b439..f71f18b1 100644
--- a/man/man8/ip-neighbour.8
+++ b/man/man8/ip-neighbour.8
@@ -253,6 +253,7 @@ the prefix selecting the neighbour to query.
 .TP
 .BI dev " NAME"
 get neighbour entry attached to this device.
+.RE
 
 .SH EXAMPLES
 .PP
diff --git a/man/man8/ip-nexthop.8 b/man/man8/ip-nexthop.8
index da87ca3b..68164f3c 100644
--- a/man/man8/ip-nexthop.8
+++ b/man/man8/ip-nexthop.8
@@ -130,7 +130,6 @@ create a blackhole nexthop
 .TP
 ip nexthop delete id ID
 delete nexthop with given id.
-.RE
 
 .TP
 ip nexthop show
@@ -154,7 +153,6 @@ show only nexthop groups
 ip nexthop flush
 flushes nexthops selected by some criteria. Criteria options are the same
 as show.
-.RE
 
 .TP
 ip nexthop get id ID
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index e2bda2a2..1661aa67 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -382,7 +382,6 @@ Bring up interface x.
 .RE
 .PP
 ip link set x down
-.RE
 .RS 4
 Bring down interface x.
 .RE
diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
index 541b5d63..e3f4b51b 100644
--- a/man/man8/rdma-statistic.8
+++ b/man/man8/rdma-statistic.8
@@ -162,6 +162,7 @@ List all currently allocated MR's and their counters.
 rdma statistic show mr mrn 6
 .RS 4
 Dump a specific MR statistics with mrn 6. Dumps nothing if does not exists.
+.RE
 
 .SH SEE ALSO
 .BR rdma (8),
diff --git a/man/man8/tc-ctinfo.8 b/man/man8/tc-ctinfo.8
index 9015b844..5b761a8f 100644
--- a/man/man8/tc-ctinfo.8
+++ b/man/man8/tc-ctinfo.8
@@ -161,6 +161,7 @@ tc -s filter show dev eth0
     Sent 32890260 bytes 120441 pkt (dropped 0, overlimits 0 requeues 0)
     backlog 0b 0p requeues 0
 .br
+.RE
 .SH SEE ALSO
 .BR tc (8),
 .BR tc-cake (8)
diff --git a/man/man8/tc-police.8 b/man/man8/tc-police.8
index bcc5f438..52279755 100644
--- a/man/man8/tc-police.8
+++ b/man/man8/tc-police.8
@@ -116,6 +116,7 @@ continue with the next filter in line (if any). This is the default for
 exceeding packets.
 .IP pipe
 Pass the packet to the next action in line.
+.RE
 .SH EXAMPLES
 A typical application of the police action is to enforce ingress traffic rate
 by dropping exceeding packets. Although better done on the sender's side,
diff --git a/man/man8/tc-sample.8 b/man/man8/tc-sample.8
index 3e03eba2..c4277caf 100644
--- a/man/man8/tc-sample.8
+++ b/man/man8/tc-sample.8
@@ -67,7 +67,6 @@ group
 .TP
 .BI PSAMPLE_ATTR_SAMPLE_RATE
 The rate the packet was sampled with
-.RE
 
 .SH OPTIONS
 .TP
@@ -117,8 +116,6 @@ tc filter add dev eth1 parent ffff: matchall \\
 .EE
 .RE
 
-.EE
-.RE
 .SH SEE ALSO
 .BR tc (8),
 .BR tc-matchall (8)
diff --git a/man/man8/tc-simple.8 b/man/man8/tc-simple.8
index 7363ab56..f565755e 100644
--- a/man/man8/tc-simple.8
+++ b/man/man8/tc-simple.8
@@ -54,7 +54,6 @@ grep the logs to see the logged message
 .IP 6) 4
 display stats again and observe increment by 1
 
-.RE
 .EX
   hadi@noma1:$ tc qdisc add dev eth0 ingress
   hadi@noma1:$tc filter add dev eth0 parent ffff: protocol ip prio 5 \\
diff --git a/man/man8/tc-skbmod.8 b/man/man8/tc-skbmod.8
index 46418b65..eb3c38fa 100644
--- a/man/man8/tc-skbmod.8
+++ b/man/man8/tc-skbmod.8
@@ -75,6 +75,7 @@ Continue classification with the next filter in line.
 .B pass
 Finish classification process and return to calling qdisc for further packet
 processing. This is the default.
+.RE
 .SH EXAMPLES
 To start, observe the following filter with a pedit action:
 
diff --git a/man/man8/tc-u32.8 b/man/man8/tc-u32.8
index 2bf2e3e9..a23a1846 100644
--- a/man/man8/tc-u32.8
+++ b/man/man8/tc-u32.8
@@ -490,6 +490,7 @@ Match on source or destination ethernet address. This is dangerous: It assumes
 an ethernet header is present at the start of the packet. This will probably
 lead to unexpected things if used with layer three interfaces like e.g. tun or
 ppp.
+.RE
 .SH EXAMPLES
 .RS
 .EX
diff --git a/man/man8/tc.8 b/man/man8/tc.8
index b81a396f..d25aadda 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -828,6 +828,7 @@ Shows classes as ASCII graph on eth0 interface.
 tc -g -s class show dev eth0
 .RS 4
 Shows classes as ASCII graph with stats info under each class.
+.RE
 
 .SH HISTORY
 .B tc
-- 
2.24.0
