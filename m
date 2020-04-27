Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206F31BB0E3
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgD0WCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgD0WCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:02 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33F1022286;
        Mon, 27 Apr 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=clatlTN0Gmh6kZKnYzgXna/TzQHo+XKI58OeJwCd7oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VsmpCMnO3CqltjMIeFcgFnlLI3DmQESHwE9kRvejGcFNgtbjaA0t8rKYYz37+7qU5
         RW81GyzeteeCiJYO2WwJR9GjrxoPv/GvzLBZl1NyXUseNjVIUoUTU9X65pp7DUT5pE
         A7EOG/wGFuEEecTKXdzAo9snnha9WRH8n/aXNN8s=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Iqb-FH; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org
Subject: [PATCH 37/38] docs: networking: convert ipvs-sysctl.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:52 +0200
Message-Id: <c47a3042ec7d3f8cb3a44f68eb4cf5c94c075a3c.1588024424.git.mchehab+huawei@kernel.org>
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
- add a document title;
- mark lists as such;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/admin-guide/sysctl/net.rst      |   4 +-
 Documentation/networking/index.rst            |   1 +
 .../{ipvs-sysctl.txt => ipvs-sysctl.rst}      | 180 +++++++++---------
 MAINTAINERS                                   |   2 +-
 4 files changed, 98 insertions(+), 89 deletions(-)
 rename Documentation/networking/{ipvs-sysctl.txt => ipvs-sysctl.rst} (62%)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 84e3348a9543..2ad1b77a7182 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -353,8 +353,8 @@ socket's buffer. It will not take effect unless PF_UNIX flag is specified.
 
 3. /proc/sys/net/ipv4 - IPV4 settings
 -------------------------------------
-Please see: Documentation/networking/ip-sysctl.rst and ipvs-sysctl.txt for
-descriptions of these entries.
+Please see: Documentation/networking/ip-sysctl.rst and
+Documentation/admin-guide/sysctl/net.rst for descriptions of these entries.
 
 
 4. Appletalk
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 54dee1575b54..bbd4e0041457 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -72,6 +72,7 @@ Contents:
    ip-sysctl
    ipv6
    ipvlan
+   ipvs-sysctl
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.rst
similarity index 62%
rename from Documentation/networking/ipvs-sysctl.txt
rename to Documentation/networking/ipvs-sysctl.rst
index 056898685d40..be36c4600e8f 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.rst
@@ -1,23 +1,30 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========
+IPvs-sysctl
+===========
+
 /proc/sys/net/ipv4/vs/* Variables:
+==================================
 
 am_droprate - INTEGER
-        default 10
+	default 10
 
-        It sets the always mode drop rate, which is used in the mode 3
-        of the drop_rate defense.
+	It sets the always mode drop rate, which is used in the mode 3
+	of the drop_rate defense.
 
 amemthresh - INTEGER
-        default 1024
+	default 1024
 
-        It sets the available memory threshold (in pages), which is
-        used in the automatic modes of defense. When there is no
-        enough available memory, the respective strategy will be
-        enabled and the variable is automatically set to 2, otherwise
-        the strategy is disabled and the variable is  set  to 1.
+	It sets the available memory threshold (in pages), which is
+	used in the automatic modes of defense. When there is no
+	enough available memory, the respective strategy will be
+	enabled and the variable is automatically set to 2, otherwise
+	the strategy is disabled and the variable is  set  to 1.
 
 backup_only - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	If set, disable the director function while the server is
 	in backup mode to avoid packet loops for DR/TUN methods.
@@ -44,8 +51,8 @@ conn_reuse_mode - INTEGER
 	real servers to a very busy cluster.
 
 conntrack - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	If set, maintain connection tracking entries for
 	connections handled by IPVS.
@@ -61,28 +68,28 @@ conntrack - BOOLEAN
 	Only available when IPVS is compiled with CONFIG_IP_VS_NFCT enabled.
 
 cache_bypass - BOOLEAN
-        0 - disabled (default)
-        not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
-        If it is enabled, forward packets to the original destination
-        directly when no cache server is available and destination
-        address is not local (iph->daddr is RTN_UNICAST). It is mostly
-        used in transparent web cache cluster.
+	If it is enabled, forward packets to the original destination
+	directly when no cache server is available and destination
+	address is not local (iph->daddr is RTN_UNICAST). It is mostly
+	used in transparent web cache cluster.
 
 debug_level - INTEGER
-	0          - transmission error messages (default)
-	1          - non-fatal error messages
-	2          - configuration
-	3          - destination trash
-	4          - drop entry
-	5          - service lookup
-	6          - scheduling
-	7          - connection new/expire, lookup and synchronization
-	8          - state transition
-	9          - binding destination, template checks and applications
-	10         - IPVS packet transmission
-	11         - IPVS packet handling (ip_vs_in/ip_vs_out)
-	12 or more - packet traversal
+	- 0          - transmission error messages (default)
+	- 1          - non-fatal error messages
+	- 2          - configuration
+	- 3          - destination trash
+	- 4          - drop entry
+	- 5          - service lookup
+	- 6          - scheduling
+	- 7          - connection new/expire, lookup and synchronization
+	- 8          - state transition
+	- 9          - binding destination, template checks and applications
+	- 10         - IPVS packet transmission
+	- 11         - IPVS packet handling (ip_vs_in/ip_vs_out)
+	- 12 or more - packet traversal
 
 	Only available when IPVS is compiled with CONFIG_IP_VS_DEBUG enabled.
 
@@ -92,58 +99,58 @@ debug_level - INTEGER
 	the level.
 
 drop_entry - INTEGER
-        0  - disabled (default)
+	- 0  - disabled (default)
 
-        The drop_entry defense is to randomly drop entries in the
-        connection hash table, just in order to collect back some
-        memory for new connections. In the current code, the
-        drop_entry procedure can be activated every second, then it
-        randomly scans 1/32 of the whole and drops entries that are in
-        the SYN-RECV/SYNACK state, which should be effective against
-        syn-flooding attack.
+	The drop_entry defense is to randomly drop entries in the
+	connection hash table, just in order to collect back some
+	memory for new connections. In the current code, the
+	drop_entry procedure can be activated every second, then it
+	randomly scans 1/32 of the whole and drops entries that are in
+	the SYN-RECV/SYNACK state, which should be effective against
+	syn-flooding attack.
 
-        The valid values of drop_entry are from 0 to 3, where 0 means
-        that this strategy is always disabled, 1 and 2 mean automatic
-        modes (when there is no enough available memory, the strategy
-        is enabled and the variable is automatically set to 2,
-        otherwise the strategy is disabled and the variable is set to
-        1), and 3 means that that the strategy is always enabled.
+	The valid values of drop_entry are from 0 to 3, where 0 means
+	that this strategy is always disabled, 1 and 2 mean automatic
+	modes (when there is no enough available memory, the strategy
+	is enabled and the variable is automatically set to 2,
+	otherwise the strategy is disabled and the variable is set to
+	1), and 3 means that that the strategy is always enabled.
 
 drop_packet - INTEGER
-        0  - disabled (default)
+	- 0  - disabled (default)
 
-        The drop_packet defense is designed to drop 1/rate packets
-        before forwarding them to real servers. If the rate is 1, then
-        drop all the incoming packets.
+	The drop_packet defense is designed to drop 1/rate packets
+	before forwarding them to real servers. If the rate is 1, then
+	drop all the incoming packets.
 
-        The value definition is the same as that of the drop_entry. In
-        the automatic mode, the rate is determined by the follow
-        formula: rate = amemthresh / (amemthresh - available_memory)
-        when available memory is less than the available memory
-        threshold. When the mode 3 is set, the always mode drop rate
-        is controlled by the /proc/sys/net/ipv4/vs/am_droprate.
+	The value definition is the same as that of the drop_entry. In
+	the automatic mode, the rate is determined by the follow
+	formula: rate = amemthresh / (amemthresh - available_memory)
+	when available memory is less than the available memory
+	threshold. When the mode 3 is set, the always mode drop rate
+	is controlled by the /proc/sys/net/ipv4/vs/am_droprate.
 
 expire_nodest_conn - BOOLEAN
-        0 - disabled (default)
-        not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
-        The default value is 0, the load balancer will silently drop
-        packets when its destination server is not available. It may
-        be useful, when user-space monitoring program deletes the
-        destination server (because of server overload or wrong
-        detection) and add back the server later, and the connections
-        to the server can continue.
+	The default value is 0, the load balancer will silently drop
+	packets when its destination server is not available. It may
+	be useful, when user-space monitoring program deletes the
+	destination server (because of server overload or wrong
+	detection) and add back the server later, and the connections
+	to the server can continue.
 
-        If this feature is enabled, the load balancer will expire the
-        connection immediately when a packet arrives and its
-        destination server is not available, then the client program
-        will be notified that the connection is closed. This is
-        equivalent to the feature some people requires to flush
-        connections when its destination is not available.
+	If this feature is enabled, the load balancer will expire the
+	connection immediately when a packet arrives and its
+	destination server is not available, then the client program
+	will be notified that the connection is closed. This is
+	equivalent to the feature some people requires to flush
+	connections when its destination is not available.
 
 expire_quiescent_template - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	When set to a non-zero value, the load balancer will expire
 	persistent templates when the destination server is quiescent.
@@ -158,8 +165,8 @@ expire_quiescent_template - BOOLEAN
 	connection and the destination server is quiescent.
 
 ignore_tunneled - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	If set, ipvs will set the ipvs_property on all packets which are of
 	unrecognized protocols.  This prevents us from routing tunneled
@@ -168,30 +175,30 @@ ignore_tunneled - BOOLEAN
 	ipvs routing loops when ipvs is also acting as a real server).
 
 nat_icmp_send - BOOLEAN
-        0 - disabled (default)
-        not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
-        It controls sending icmp error messages (ICMP_DEST_UNREACH)
-        for VS/NAT when the load balancer receives packets from real
-        servers but the connection entries don't exist.
+	It controls sending icmp error messages (ICMP_DEST_UNREACH)
+	for VS/NAT when the load balancer receives packets from real
+	servers but the connection entries don't exist.
 
 pmtu_disc - BOOLEAN
-	0 - disabled
-	not 0 - enabled (default)
+	- 0 - disabled
+	- not 0 - enabled (default)
 
 	By default, reject with FRAG_NEEDED all DF packets that exceed
 	the PMTU, irrespective of the forwarding method. For TUN method
 	the flag can be disabled to fragment such packets.
 
 secure_tcp - INTEGER
-        0  - disabled (default)
+	- 0  - disabled (default)
 
 	The secure_tcp defense is to use a more complicated TCP state
 	transition table. For VS/NAT, it also delays entering the
 	TCP ESTABLISHED state until the three way handshake is completed.
 
-        The value definition is the same as that of drop_entry and
-        drop_packet.
+	The value definition is the same as that of drop_entry and
+	drop_packet.
 
 sync_threshold - vector of 2 INTEGERs: sync_threshold, sync_period
 	default 3 50
@@ -248,8 +255,8 @@ sync_ports - INTEGER
 	8848+sync_ports-1.
 
 snat_reroute - BOOLEAN
-	0 - disabled
-	not 0 - enabled (default)
+	- 0 - disabled
+	- not 0 - enabled (default)
 
 	If enabled, recalculate the route of SNATed packets from
 	realservers so that they are routed as if they originate from the
@@ -270,6 +277,7 @@ sync_persist_mode - INTEGER
 	Controls the synchronisation of connections when using persistence
 
 	0: All types of connections are synchronised
+
 	1: Attempt to reduce the synchronisation traffic depending on
 	the connection type. For persistent services avoid synchronisation
 	for normal connections, do it only for persistence templates.
diff --git a/MAINTAINERS b/MAINTAINERS
index 3764697a6002..2828723f0d4d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8957,7 +8957,7 @@ L:	lvs-devel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git
-F:	Documentation/networking/ipvs-sysctl.txt
+F:	Documentation/networking/ipvs-sysctl.rst
 F:	include/net/ip_vs.h
 F:	include/uapi/linux/ip_vs.h
 F:	net/netfilter/ipvs/
-- 
2.25.4

