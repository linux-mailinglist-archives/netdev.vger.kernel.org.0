Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B93BB899
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732608AbfIWPw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728464AbfIWPw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 11:52:57 -0400
Received: from localhost.localdomain (unknown [194.230.155.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 883A620882;
        Mon, 23 Sep 2019 15:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569253975;
        bh=wsRw+5OFigXOvW/TmLwyJ0IDVIJ/i3H8mrfAQwzsvho=;
        h=From:To:Cc:Subject:Date:From;
        b=EjGht6N2oXaQ0mXXCrzebTxG3WEs0BjDYcTK/vjZkItgfT1eM0NJM6NGyrz/3W3ew
         51imANnLdrleBNMdNWYLnYtJDjl4SB8TOn6/bzXIRy2HGefTgyVQ2OG0zb0CcI61gj
         O+F44nzFDpuNQJ6C55sAuE+IxlOfOZFAR27vmGgA=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH trivial 1/2] net: Fix Kconfig indentation
Date:   Mon, 23 Sep 2019 17:52:42 +0200
Message-Id: <20190923155243.6997-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
    $ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 net/batman-adv/Kconfig     |  10 +--
 net/ife/Kconfig            |   2 +-
 net/ipv4/Kconfig           |   4 +-
 net/ipv6/netfilter/Kconfig |  16 ++---
 net/netfilter/Kconfig      |   2 +-
 net/netfilter/ipvs/Kconfig |   6 +-
 net/rds/Kconfig            |   4 +-
 net/sched/Kconfig          | 144 ++++++++++++++++++-------------------
 8 files changed, 94 insertions(+), 94 deletions(-)

diff --git a/net/batman-adv/Kconfig b/net/batman-adv/Kconfig
index a3d188dfbe75..d5028af750d5 100644
--- a/net/batman-adv/Kconfig
+++ b/net/batman-adv/Kconfig
@@ -12,11 +12,11 @@ config BATMAN_ADV
 	depends on NET
 	select LIBCRC32C
 	help
-          B.A.T.M.A.N. (better approach to mobile ad-hoc networking) is
-          a routing protocol for multi-hop ad-hoc mesh networks. The
-          networks may be wired or wireless. See
-          https://www.open-mesh.org/ for more information and user space
-          tools.
+	  B.A.T.M.A.N. (better approach to mobile ad-hoc networking) is
+	  a routing protocol for multi-hop ad-hoc mesh networks. The
+	  networks may be wired or wireless. See
+	  https://www.open-mesh.org/ for more information and user space
+	  tools.
 
 config BATMAN_ADV_BATMAN_V
 	bool "B.A.T.M.A.N. V protocol"
diff --git a/net/ife/Kconfig b/net/ife/Kconfig
index 6cd1f6d18f30..bcf650564db4 100644
--- a/net/ife/Kconfig
+++ b/net/ife/Kconfig
@@ -5,7 +5,7 @@
 
 menuconfig NET_IFE
 	depends on NET
-        tristate "Inter-FE based on IETF ForCES InterFE LFB"
+	tristate "Inter-FE based on IETF ForCES InterFE LFB"
 	default n
 	help
 	  Say Y here to add support of IFE encapsulation protocol
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 974de4d20f25..03381f3e12ba 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -492,8 +492,8 @@ config TCP_CONG_WESTWOOD
 	wired networks and throughput over wireless links.
 
 config TCP_CONG_HTCP
-        tristate "H-TCP"
-        default m
+	tristate "H-TCP"
+	default m
 	---help---
 	H-TCP is a send-side only modifications of the TCP Reno
 	protocol stack that optimizes the performance of TCP
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 6120a7800975..69443e9a3aa5 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -170,13 +170,13 @@ config IP6_NF_MATCH_RT
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_SRH
-        tristate '"srh" Segment Routing header match support'
-        depends on NETFILTER_ADVANCED
-        help
-          srh matching allows you to match packets based on the segment
+	tristate '"srh" Segment Routing header match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  srh matching allows you to match packets based on the segment
 	  routing header of the packet.
 
-          To compile it as a module, choose M here.  If unsure, say N.
+	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The targets
 config IP6_NF_TARGET_HL
@@ -249,10 +249,10 @@ config IP6_NF_SECURITY
        depends on SECURITY
        depends on NETFILTER_ADVANCED
        help
-         This option adds a `security' table to iptables, for use
-         with Mandatory Access Control (MAC) policy.
+	 This option adds a `security' table to iptables, for use
+	 with Mandatory Access Control (MAC) policy.
 
-         If unsure, say N.
+	 If unsure, say N.
 
 config IP6_NF_NAT
 	tristate "ip6tables NAT support"
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 34ec7afec116..91efae88e8c2 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -697,7 +697,7 @@ config NF_FLOW_TABLE_INET
 	tristate "Netfilter flow table mixed IPv4/IPv6 module"
 	depends on NF_FLOW_TABLE
 	help
-          This option adds the flow table mixed IPv4/IPv6 support.
+	  This option adds the flow table mixed IPv4/IPv6 support.
 
 	  To compile it as a module, choose M here.
 
diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index f6f1a0d5c47d..5b672e05d758 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -135,7 +135,7 @@ config	IP_VS_WRR
 	  module, choose M here. If unsure, say N.
 
 config	IP_VS_LC
-        tristate "least-connection scheduling"
+	tristate "least-connection scheduling"
 	---help---
 	  The least-connection scheduling algorithm directs network
 	  connections to the server with the least number of active 
@@ -145,7 +145,7 @@ config	IP_VS_LC
 	  module, choose M here. If unsure, say N.
 
 config	IP_VS_WLC
-        tristate "weighted least-connection scheduling"
+	tristate "weighted least-connection scheduling"
 	---help---
 	  The weighted least-connection scheduling algorithm directs network
 	  connections to the server with the least active connections
@@ -333,7 +333,7 @@ config	IP_VS_NFCT
 
 config	IP_VS_PE_SIP
 	tristate "SIP persistence engine"
-        depends on IP_VS_PROTO_UDP
+	depends on IP_VS_PROTO_UDP
 	depends on NF_CONNTRACK_SIP
 	---help---
 	  Allow persistence based on the SIP Call-ID
diff --git a/net/rds/Kconfig b/net/rds/Kconfig
index 38ea7f0f2699..c64e154bc18f 100644
--- a/net/rds/Kconfig
+++ b/net/rds/Kconfig
@@ -23,6 +23,6 @@ config RDS_TCP
 	  This transport does not support RDMA operations.
 
 config RDS_DEBUG
-        bool "RDS debugging messages"
+	bool "RDS debugging messages"
 	depends on RDS
-        default n
+	default n
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index b3faafeafab9..5b044ae6dc1e 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -324,7 +324,7 @@ config NET_SCH_CAKE
 	tristate "Common Applications Kept Enhanced (CAKE)"
 	help
 	  Say Y here if you want to use the Common Applications Kept Enhanced
-          (CAKE) queue management algorithm.
+	  (CAKE) queue management algorithm.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called sch_cake.
@@ -730,8 +730,8 @@ config NET_CLS_ACT
 
 config NET_ACT_POLICE
 	tristate "Traffic Policing"
-        depends on NET_CLS_ACT
-        ---help---
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here if you want to do traffic policing, i.e. strict
 	  bandwidth limiting. This action replaces the existing policing
 	  module.
@@ -740,9 +740,9 @@ config NET_ACT_POLICE
 	  module will be called act_police.
 
 config NET_ACT_GACT
-        tristate "Generic actions"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "Generic actions"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here to take generic actions such as dropping and
 	  accepting packets.
 
@@ -750,15 +750,15 @@ config NET_ACT_GACT
 	  module will be called act_gact.
 
 config GACT_PROB
-        bool "Probability support"
-        depends on NET_ACT_GACT
-        ---help---
+	bool "Probability support"
+	depends on NET_ACT_GACT
+	---help---
 	  Say Y here to use the generic action randomly or deterministically.
 
 config NET_ACT_MIRRED
-        tristate "Redirecting and Mirroring"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "Redirecting and Mirroring"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here to allow packets to be mirrored or redirected to
 	  other devices.
 
@@ -766,10 +766,10 @@ config NET_ACT_MIRRED
 	  module will be called act_mirred.
 
 config NET_ACT_SAMPLE
-        tristate "Traffic Sampling"
-        depends on NET_CLS_ACT
-        select PSAMPLE
-        ---help---
+	tristate "Traffic Sampling"
+	depends on NET_CLS_ACT
+	select PSAMPLE
+	---help---
 	  Say Y here to allow packet sampling tc action. The packet sample
 	  action consists of statistically choosing packets and sampling
 	  them using the psample module.
@@ -778,9 +778,9 @@ config NET_ACT_SAMPLE
 	  module will be called act_sample.
 
 config NET_ACT_IPT
-        tristate "IPtables targets"
-        depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
-        ---help---
+	tristate "IPtables targets"
+	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	---help---
 	  Say Y here to be able to invoke iptables targets after successful
 	  classification.
 
@@ -788,9 +788,9 @@ config NET_ACT_IPT
 	  module will be called act_ipt.
 
 config NET_ACT_NAT
-        tristate "Stateless NAT"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "Stateless NAT"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here to do stateless NAT on IPv4 packets.  You should use
 	  netfilter for NAT unless you know what you are doing.
 
@@ -798,18 +798,18 @@ config NET_ACT_NAT
 	  module will be called act_nat.
 
 config NET_ACT_PEDIT
-        tristate "Packet Editing"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "Packet Editing"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here if you want to mangle the content of packets.
 
 	  To compile this code as a module, choose M here: the
 	  module will be called act_pedit.
 
 config NET_ACT_SIMP
-        tristate "Simple Example (Debug)"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "Simple Example (Debug)"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here to add a simple action for demonstration purposes.
 	  It is meant as an example and for debugging purposes. It will
 	  print a configured policy string followed by the packet count
@@ -821,9 +821,9 @@ config NET_ACT_SIMP
 	  module will be called act_simple.
 
 config NET_ACT_SKBEDIT
-        tristate "SKB Editing"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "SKB Editing"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here to change skb priority or queue_mapping settings.
 
 	  If unsure, say N.
@@ -832,10 +832,10 @@ config NET_ACT_SKBEDIT
 	  module will be called act_skbedit.
 
 config NET_ACT_CSUM
-        tristate "Checksum Updating"
-        depends on NET_CLS_ACT && INET
-        select LIBCRC32C
-        ---help---
+	tristate "Checksum Updating"
+	depends on NET_CLS_ACT && INET
+	select LIBCRC32C
+	---help---
 	  Say Y here to update some common checksum after some direct
 	  packet alterations.
 
@@ -854,9 +854,9 @@ config NET_ACT_MPLS
 	  module will be called act_mpls.
 
 config NET_ACT_VLAN
-        tristate "Vlan manipulation"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "Vlan manipulation"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here to push or pop vlan headers.
 
 	  If unsure, say N.
@@ -865,9 +865,9 @@ config NET_ACT_VLAN
 	  module will be called act_vlan.
 
 config NET_ACT_BPF
-        tristate "BPF based action"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "BPF based action"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here to execute BPF code on packets. The BPF code will decide
 	  if the packet should be dropped or not.
 
@@ -877,10 +877,10 @@ config NET_ACT_BPF
 	  module will be called act_bpf.
 
 config NET_ACT_CONNMARK
-        tristate "Netfilter Connection Mark Retriever"
-        depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
-        depends on NF_CONNTRACK && NF_CONNTRACK_MARK
-        ---help---
+	tristate "Netfilter Connection Mark Retriever"
+	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NF_CONNTRACK && NF_CONNTRACK_MARK
+	---help---
 	  Say Y here to allow retrieving of conn mark
 
 	  If unsure, say N.
@@ -889,10 +889,10 @@ config NET_ACT_CONNMARK
 	  module will be called act_connmark.
 
 config NET_ACT_CTINFO
-        tristate "Netfilter Connection Mark Actions"
-        depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
-        depends on NF_CONNTRACK && NF_CONNTRACK_MARK
-        help
+	tristate "Netfilter Connection Mark Actions"
+	depends on NET_CLS_ACT && NETFILTER && IP_NF_IPTABLES
+	depends on NF_CONNTRACK && NF_CONNTRACK_MARK
+	help
 	  Say Y here to allow transfer of a connmark stored information.
 	  Current actions transfer connmark stored DSCP into
 	  ipv4/v6 diffserv and/or to transfer connmark to packet
@@ -906,21 +906,21 @@ config NET_ACT_CTINFO
 	  module will be called act_ctinfo.
 
 config NET_ACT_SKBMOD
-        tristate "skb data modification action"
-        depends on NET_CLS_ACT
-        ---help---
-         Say Y here to allow modification of skb data
+	tristate "skb data modification action"
+	depends on NET_CLS_ACT
+	---help---
+	 Say Y here to allow modification of skb data
 
-         If unsure, say N.
+	 If unsure, say N.
 
-         To compile this code as a module, choose M here: the
-         module will be called act_skbmod.
+	 To compile this code as a module, choose M here: the
+	 module will be called act_skbmod.
 
 config NET_ACT_IFE
-        tristate "Inter-FE action based on IETF ForCES InterFE LFB"
-        depends on NET_CLS_ACT
-        select NET_IFE
-        ---help---
+	tristate "Inter-FE action based on IETF ForCES InterFE LFB"
+	depends on NET_CLS_ACT
+	select NET_IFE
+	---help---
 	  Say Y here to allow for sourcing and terminating metadata
 	  For details refer to netdev01 paper:
 	  "Distributing Linux Traffic Control Classifier-Action Subsystem"
@@ -930,9 +930,9 @@ config NET_ACT_IFE
 	  module will be called act_ife.
 
 config NET_ACT_TUNNEL_KEY
-        tristate "IP tunnel metadata manipulation"
-        depends on NET_CLS_ACT
-        ---help---
+	tristate "IP tunnel metadata manipulation"
+	depends on NET_CLS_ACT
+	---help---
 	  Say Y here to set/release ip tunnel metadata.
 
 	  If unsure, say N.
@@ -941,9 +941,9 @@ config NET_ACT_TUNNEL_KEY
 	  module will be called act_tunnel_key.
 
 config NET_ACT_CT
-        tristate "connection tracking tc action"
-        depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
-        help
+	tristate "connection tracking tc action"
+	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
+	help
 	  Say Y here to allow sending the packets to conntrack module.
 
 	  If unsure, say N.
@@ -952,16 +952,16 @@ config NET_ACT_CT
 	  module will be called act_ct.
 
 config NET_IFE_SKBMARK
-        tristate "Support to encoding decoding skb mark on IFE action"
-        depends on NET_ACT_IFE
+	tristate "Support to encoding decoding skb mark on IFE action"
+	depends on NET_ACT_IFE
 
 config NET_IFE_SKBPRIO
-        tristate "Support to encoding decoding skb prio on IFE action"
-        depends on NET_ACT_IFE
+	tristate "Support to encoding decoding skb prio on IFE action"
+	depends on NET_ACT_IFE
 
 config NET_IFE_SKBTCINDEX
-        tristate "Support to encoding decoding skb tcindex on IFE action"
-        depends on NET_ACT_IFE
+	tristate "Support to encoding decoding skb tcindex on IFE action"
+	depends on NET_ACT_IFE
 
 config NET_TC_SKB_EXT
 	bool "TC recirculation support"
-- 
2.17.1

