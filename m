Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32E81052F9
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 14:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKUN2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 08:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUN2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 08:28:42 -0500
Received: from localhost.localdomain (unknown [118.189.143.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 484B52089D;
        Thu, 21 Nov 2019 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574342921;
        bh=ZiIBZ4TQV7E0oa+xHvh5rSStAblfSch8fZw7AmKhkE8=;
        h=From:To:Cc:Subject:Date:From;
        b=QjIiOkFNMd+ni7otmKS0Ve6YEB/twRv0GOBz8eownXbB9sC4Na0xEP9zElfpnuzLP
         382mY5sBgS/FZz8iQumoLxYmB31IYSsbOulr0PfasKZqpk60FrQXadW7cGhSwxM2yE
         +n1XfJ+s8BVimVYKwMr8dxOn8y5yHuP7VEvJ0CO0=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH] net: Fix Kconfig indentation, continued
Date:   Thu, 21 Nov 2019 21:28:35 +0800
Message-Id: <20191121132835.28886-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style.  This fixes various indentation mixups (seven spaces,
tab+one space, etc).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 net/Kconfig                |  26 ++---
 net/ipv4/Kconfig           | 218 ++++++++++++++++++-------------------
 net/ipv6/netfilter/Kconfig |  28 ++---
 net/nfc/hci/Kconfig        |  14 +--
 net/xfrm/Kconfig           |  10 +-
 5 files changed, 148 insertions(+), 148 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 3101bfcbdd7a..bd191f978a23 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -258,7 +258,7 @@ config XPS
 	default y
 
 config HWBM
-       bool
+	bool
 
 config CGROUP_NET_PRIO
 	bool "Network priority cgroup"
@@ -309,12 +309,12 @@ config BPF_STREAM_PARSER
 	select STREAM_PARSER
 	select NET_SOCK_MSG
 	---help---
-	 Enabling this allows a stream parser to be used with
-	 BPF_MAP_TYPE_SOCKMAP.
+	  Enabling this allows a stream parser to be used with
+	  BPF_MAP_TYPE_SOCKMAP.
 
-	 BPF_MAP_TYPE_SOCKMAP provides a map type to use with network sockets.
-	 It can be used to enforce socket policy, implement socket redirects,
-	 etc.
+	  BPF_MAP_TYPE_SOCKMAP provides a map type to use with network sockets.
+	  It can be used to enforce socket policy, implement socket redirects,
+	  etc.
 
 config NET_FLOW_LIMIT
 	bool
@@ -349,12 +349,12 @@ config NET_DROP_MONITOR
 	tristate "Network packet drop alerting service"
 	depends on INET && TRACEPOINTS
 	---help---
-	This feature provides an alerting service to userspace in the
-	event that packets are discarded in the network stack.  Alerts
-	are broadcast via netlink socket to any listening user space
-	process.  If you don't need network drop alerts, or if you are ok
-	just checking the various proc files and other utilities for
-	drop statistics, say N here.
+	  This feature provides an alerting service to userspace in the
+	  event that packets are discarded in the network stack.  Alerts
+	  are broadcast via netlink socket to any listening user space
+	  process.  If you don't need network drop alerts, or if you are ok
+	  just checking the various proc files and other utilities for
+	  drop statistics, say N here.
 
 endmenu
 
@@ -433,7 +433,7 @@ config NET_DEVLINK
 	imply NET_DROP_MONITOR
 
 config PAGE_POOL
-       bool
+	bool
 
 config FAILOVER
 	tristate "Generic failover module"
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 03381f3e12ba..fc816b187170 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -180,8 +180,8 @@ config NET_IPIP
 config NET_IPGRE_DEMUX
 	tristate "IP: GRE demultiplexer"
 	help
-	 This is helper module to demultiplex GRE packets on GRE version field criteria.
-	 Required by ip_gre and pptp modules.
+	  This is helper module to demultiplex GRE packets on GRE version field criteria.
+	  Required by ip_gre and pptp modules.
 
 config NET_IP_TUNNEL
 	tristate
@@ -459,200 +459,200 @@ config TCP_CONG_BIC
 	tristate "Binary Increase Congestion (BIC) control"
 	default m
 	---help---
-	BIC-TCP is a sender-side only change that ensures a linear RTT
-	fairness under large windows while offering both scalability and
-	bounded TCP-friendliness. The protocol combines two schemes
-	called additive increase and binary search increase. When the
-	congestion window is large, additive increase with a large
-	increment ensures linear RTT fairness as well as good
-	scalability. Under small congestion windows, binary search
-	increase provides TCP friendliness.
-	See http://www.csc.ncsu.edu/faculty/rhee/export/bitcp/
+	  BIC-TCP is a sender-side only change that ensures a linear RTT
+	  fairness under large windows while offering both scalability and
+	  bounded TCP-friendliness. The protocol combines two schemes
+	  called additive increase and binary search increase. When the
+	  congestion window is large, additive increase with a large
+	  increment ensures linear RTT fairness as well as good
+	  scalability. Under small congestion windows, binary search
+	  increase provides TCP friendliness.
+	  See http://www.csc.ncsu.edu/faculty/rhee/export/bitcp/
 
 config TCP_CONG_CUBIC
 	tristate "CUBIC TCP"
 	default y
 	---help---
-	This is version 2.0 of BIC-TCP which uses a cubic growth function
-	among other techniques.
-	See http://www.csc.ncsu.edu/faculty/rhee/export/bitcp/cubic-paper.pdf
+	  This is version 2.0 of BIC-TCP which uses a cubic growth function
+	  among other techniques.
+	  See http://www.csc.ncsu.edu/faculty/rhee/export/bitcp/cubic-paper.pdf
 
 config TCP_CONG_WESTWOOD
 	tristate "TCP Westwood+"
 	default m
 	---help---
-	TCP Westwood+ is a sender-side only modification of the TCP Reno
-	protocol stack that optimizes the performance of TCP congestion
-	control. It is based on end-to-end bandwidth estimation to set
-	congestion window and slow start threshold after a congestion
-	episode. Using this estimation, TCP Westwood+ adaptively sets a
-	slow start threshold and a congestion window which takes into
-	account the bandwidth used  at the time congestion is experienced.
-	TCP Westwood+ significantly increases fairness wrt TCP Reno in
-	wired networks and throughput over wireless links.
+	  TCP Westwood+ is a sender-side only modification of the TCP Reno
+	  protocol stack that optimizes the performance of TCP congestion
+	  control. It is based on end-to-end bandwidth estimation to set
+	  congestion window and slow start threshold after a congestion
+	  episode. Using this estimation, TCP Westwood+ adaptively sets a
+	  slow start threshold and a congestion window which takes into
+	  account the bandwidth used  at the time congestion is experienced.
+	  TCP Westwood+ significantly increases fairness wrt TCP Reno in
+	  wired networks and throughput over wireless links.
 
 config TCP_CONG_HTCP
 	tristate "H-TCP"
 	default m
 	---help---
-	H-TCP is a send-side only modifications of the TCP Reno
-	protocol stack that optimizes the performance of TCP
-	congestion control for high speed network links. It uses a
-	modeswitch to change the alpha and beta parameters of TCP Reno
-	based on network conditions and in a way so as to be fair with
-	other Reno and H-TCP flows.
+	  H-TCP is a send-side only modifications of the TCP Reno
+	  protocol stack that optimizes the performance of TCP
+	  congestion control for high speed network links. It uses a
+	  modeswitch to change the alpha and beta parameters of TCP Reno
+	  based on network conditions and in a way so as to be fair with
+	  other Reno and H-TCP flows.
 
 config TCP_CONG_HSTCP
 	tristate "High Speed TCP"
 	default n
 	---help---
-	Sally Floyd's High Speed TCP (RFC 3649) congestion control.
-	A modification to TCP's congestion control mechanism for use
-	with large congestion windows. A table indicates how much to
-	increase the congestion window by when an ACK is received.
- 	For more detail	see http://www.icir.org/floyd/hstcp.html
+	  Sally Floyd's High Speed TCP (RFC 3649) congestion control.
+	  A modification to TCP's congestion control mechanism for use
+	  with large congestion windows. A table indicates how much to
+	  increase the congestion window by when an ACK is received.
+	  For more detail see http://www.icir.org/floyd/hstcp.html
 
 config TCP_CONG_HYBLA
 	tristate "TCP-Hybla congestion control algorithm"
 	default n
 	---help---
-	TCP-Hybla is a sender-side only change that eliminates penalization of
-	long-RTT, large-bandwidth connections, like when satellite legs are
-	involved, especially when sharing a common bottleneck with normal
-	terrestrial connections.
+	  TCP-Hybla is a sender-side only change that eliminates penalization of
+	  long-RTT, large-bandwidth connections, like when satellite legs are
+	  involved, especially when sharing a common bottleneck with normal
+	  terrestrial connections.
 
 config TCP_CONG_VEGAS
 	tristate "TCP Vegas"
 	default n
 	---help---
-	TCP Vegas is a sender-side only change to TCP that anticipates
-	the onset of congestion by estimating the bandwidth. TCP Vegas
-	adjusts the sending rate by modifying the congestion
-	window. TCP Vegas should provide less packet loss, but it is
-	not as aggressive as TCP Reno.
+	  TCP Vegas is a sender-side only change to TCP that anticipates
+	  the onset of congestion by estimating the bandwidth. TCP Vegas
+	  adjusts the sending rate by modifying the congestion
+	  window. TCP Vegas should provide less packet loss, but it is
+	  not as aggressive as TCP Reno.
 
 config TCP_CONG_NV
-       tristate "TCP NV"
-       default n
-       ---help---
-       TCP NV is a follow up to TCP Vegas. It has been modified to deal with
-       10G networks, measurement noise introduced by LRO, GRO and interrupt
-       coalescence. In addition, it will decrease its cwnd multiplicatively
-       instead of linearly.
+	tristate "TCP NV"
+	default n
+	---help---
+	  TCP NV is a follow up to TCP Vegas. It has been modified to deal with
+	  10G networks, measurement noise introduced by LRO, GRO and interrupt
+	  coalescence. In addition, it will decrease its cwnd multiplicatively
+	  instead of linearly.
 
-       Note that in general congestion avoidance (cwnd decreased when # packets
-       queued grows) cannot coexist with congestion control (cwnd decreased only
-       when there is packet loss) due to fairness issues. One scenario when they
-       can coexist safely is when the CA flows have RTTs << CC flows RTTs.
+	  Note that in general congestion avoidance (cwnd decreased when # packets
+	  queued grows) cannot coexist with congestion control (cwnd decreased only
+	  when there is packet loss) due to fairness issues. One scenario when they
+	  can coexist safely is when the CA flows have RTTs << CC flows RTTs.
 
-       For further details see http://www.brakmo.org/networking/tcp-nv/
+	  For further details see http://www.brakmo.org/networking/tcp-nv/
 
 config TCP_CONG_SCALABLE
 	tristate "Scalable TCP"
 	default n
 	---help---
-	Scalable TCP is a sender-side only change to TCP which uses a
-	MIMD congestion control algorithm which has some nice scaling
-	properties, though is known to have fairness issues.
-	See http://www.deneholme.net/tom/scalable/
+	  Scalable TCP is a sender-side only change to TCP which uses a
+	  MIMD congestion control algorithm which has some nice scaling
+	  properties, though is known to have fairness issues.
+	  See http://www.deneholme.net/tom/scalable/
 
 config TCP_CONG_LP
 	tristate "TCP Low Priority"
 	default n
 	---help---
-	TCP Low Priority (TCP-LP), a distributed algorithm whose goal is
-	to utilize only the excess network bandwidth as compared to the
-	``fair share`` of bandwidth as targeted by TCP.
-	See http://www-ece.rice.edu/networks/TCP-LP/
+	  TCP Low Priority (TCP-LP), a distributed algorithm whose goal is
+	  to utilize only the excess network bandwidth as compared to the
+	  ``fair share`` of bandwidth as targeted by TCP.
+	  See http://www-ece.rice.edu/networks/TCP-LP/
 
 config TCP_CONG_VENO
 	tristate "TCP Veno"
 	default n
 	---help---
-	TCP Veno is a sender-side only enhancement of TCP to obtain better
-	throughput over wireless networks. TCP Veno makes use of state
-	distinguishing to circumvent the difficult judgment of the packet loss
-	type. TCP Veno cuts down less congestion window in response to random
-	loss packets.
-	See <http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=1177186>
+	  TCP Veno is a sender-side only enhancement of TCP to obtain better
+	  throughput over wireless networks. TCP Veno makes use of state
+	  distinguishing to circumvent the difficult judgment of the packet loss
+	  type. TCP Veno cuts down less congestion window in response to random
+	  loss packets.
+	  See <http://ieeexplore.ieee.org/xpl/freeabs_all.jsp?arnumber=1177186>
 
 config TCP_CONG_YEAH
 	tristate "YeAH TCP"
 	select TCP_CONG_VEGAS
 	default n
 	---help---
-	YeAH-TCP is a sender-side high-speed enabled TCP congestion control
-	algorithm, which uses a mixed loss/delay approach to compute the
-	congestion window. It's design goals target high efficiency,
-	internal, RTT and Reno fairness, resilience to link loss while
-	keeping network elements load as low as possible.
+	  YeAH-TCP is a sender-side high-speed enabled TCP congestion control
+	  algorithm, which uses a mixed loss/delay approach to compute the
+	  congestion window. It's design goals target high efficiency,
+	  internal, RTT and Reno fairness, resilience to link loss while
+	  keeping network elements load as low as possible.
 
-	For further details look here:
-	  http://wil.cs.caltech.edu/pfldnet2007/paper/YeAH_TCP.pdf
+	  For further details look here:
+	    http://wil.cs.caltech.edu/pfldnet2007/paper/YeAH_TCP.pdf
 
 config TCP_CONG_ILLINOIS
 	tristate "TCP Illinois"
 	default n
 	---help---
-	TCP-Illinois is a sender-side modification of TCP Reno for
-	high speed long delay links. It uses round-trip-time to
-	adjust the alpha and beta parameters to achieve a higher average
-	throughput and maintain fairness.
+	  TCP-Illinois is a sender-side modification of TCP Reno for
+	  high speed long delay links. It uses round-trip-time to
+	  adjust the alpha and beta parameters to achieve a higher average
+	  throughput and maintain fairness.
 
-	For further details see:
-	  http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html
+	  For further details see:
+	    http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html
 
 config TCP_CONG_DCTCP
 	tristate "DataCenter TCP (DCTCP)"
 	default n
 	---help---
-	DCTCP leverages Explicit Congestion Notification (ECN) in the network to
-	provide multi-bit feedback to the end hosts. It is designed to provide:
+	  DCTCP leverages Explicit Congestion Notification (ECN) in the network to
+	  provide multi-bit feedback to the end hosts. It is designed to provide:
 
-	- High burst tolerance (incast due to partition/aggregate),
-	- Low latency (short flows, queries),
-	- High throughput (continuous data updates, large file transfers) with
-	  commodity, shallow-buffered switches.
+	  - High burst tolerance (incast due to partition/aggregate),
+	  - Low latency (short flows, queries),
+	  - High throughput (continuous data updates, large file transfers) with
+	    commodity, shallow-buffered switches.
 
-	All switches in the data center network running DCTCP must support
-	ECN marking and be configured for marking when reaching defined switch
-	buffer thresholds. The default ECN marking threshold heuristic for
-	DCTCP on switches is 20 packets (30KB) at 1Gbps, and 65 packets
-	(~100KB) at 10Gbps, but might need further careful tweaking.
+	  All switches in the data center network running DCTCP must support
+	  ECN marking and be configured for marking when reaching defined switch
+	  buffer thresholds. The default ECN marking threshold heuristic for
+	  DCTCP on switches is 20 packets (30KB) at 1Gbps, and 65 packets
+	  (~100KB) at 10Gbps, but might need further careful tweaking.
 
-	For further details see:
-	  http://simula.stanford.edu/~alizade/Site/DCTCP_files/dctcp-final.pdf
+	  For further details see:
+	    http://simula.stanford.edu/~alizade/Site/DCTCP_files/dctcp-final.pdf
 
 config TCP_CONG_CDG
 	tristate "CAIA Delay-Gradient (CDG)"
 	default n
 	---help---
-	CAIA Delay-Gradient (CDG) is a TCP congestion control that modifies
-	the TCP sender in order to:
+	  CAIA Delay-Gradient (CDG) is a TCP congestion control that modifies
+	  the TCP sender in order to:
 
 	  o Use the delay gradient as a congestion signal.
 	  o Back off with an average probability that is independent of the RTT.
 	  o Coexist with flows that use loss-based congestion control.
 	  o Tolerate packet loss unrelated to congestion.
 
-	For further details see:
-	  D.A. Hayes and G. Armitage. "Revisiting TCP congestion control using
-	  delay gradients." In Networking 2011. Preprint: http://goo.gl/No3vdg
+	  For further details see:
+	    D.A. Hayes and G. Armitage. "Revisiting TCP congestion control using
+	    delay gradients." In Networking 2011. Preprint: http://goo.gl/No3vdg
 
 config TCP_CONG_BBR
 	tristate "BBR TCP"
 	default n
 	---help---
 
-	BBR (Bottleneck Bandwidth and RTT) TCP congestion control aims to
-	maximize network utilization and minimize queues. It builds an explicit
-	model of the the bottleneck delivery rate and path round-trip
-	propagation delay. It tolerates packet loss and delay unrelated to
-	congestion. It can operate over LAN, WAN, cellular, wifi, or cable
-	modem links. It can coexist with flows that use loss-based congestion
-	control, and can operate with shallow buffers, deep buffers,
-	bufferbloat, policers, or AQM schemes that do not provide a delay
-	signal. It requires the fq ("Fair Queue") pacing packet scheduler.
+	  BBR (Bottleneck Bandwidth and RTT) TCP congestion control aims to
+	  maximize network utilization and minimize queues. It builds an explicit
+	  model of the the bottleneck delivery rate and path round-trip
+	  propagation delay. It tolerates packet loss and delay unrelated to
+	  congestion. It can operate over LAN, WAN, cellular, wifi, or cable
+	  modem links. It can coexist with flows that use loss-based congestion
+	  control, and can operate with shallow buffers, deep buffers,
+	  bufferbloat, policers, or AQM schemes that do not provide a delay
+	  signal. It requires the fq ("Fair Queue") pacing packet scheduler.
 
 choice
 	prompt "Default TCP congestion control"
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 69443e9a3aa5..0594131fa46d 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -128,9 +128,9 @@ config IP6_NF_MATCH_HL
 	depends on NETFILTER_ADVANCED
 	select NETFILTER_XT_MATCH_HL
 	---help---
-	This is a backwards-compat option for the user's convenience
-	(e.g. when running oldconfig). It selects
-	CONFIG_NETFILTER_XT_MATCH_HL.
+	  This is a backwards-compat option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_MATCH_HL.
 
 config IP6_NF_MATCH_IPV6HEADER
 	tristate '"ipv6header" IPv6 Extension Headers Match'
@@ -184,9 +184,9 @@ config IP6_NF_TARGET_HL
 	depends on NETFILTER_ADVANCED && IP6_NF_MANGLE
 	select NETFILTER_XT_TARGET_HL
 	---help---
-	This is a backwards-compatible option for the user's convenience
-	(e.g. when running oldconfig). It selects
-	CONFIG_NETFILTER_XT_TARGET_HL.
+	  This is a backwards-compatible option for the user's convenience
+	  (e.g. when running oldconfig). It selects
+	  CONFIG_NETFILTER_XT_TARGET_HL.
 
 config IP6_NF_FILTER
 	tristate "Packet filtering"
@@ -245,14 +245,14 @@ config IP6_NF_RAW
 
 # security table for MAC policy
 config IP6_NF_SECURITY
-       tristate "Security table"
-       depends on SECURITY
-       depends on NETFILTER_ADVANCED
-       help
-	 This option adds a `security' table to iptables, for use
-	 with Mandatory Access Control (MAC) policy.
-
-	 If unsure, say N.
+	tristate "Security table"
+	depends on SECURITY
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds a `security' table to iptables, for use
+	  with Mandatory Access Control (MAC) policy.
+
+	  If unsure, say N.
 
 config IP6_NF_NAT
 	tristate "ip6tables NAT support"
diff --git a/net/nfc/hci/Kconfig b/net/nfc/hci/Kconfig
index 97bd3a2c5c98..4822d6f46947 100644
--- a/net/nfc/hci/Kconfig
+++ b/net/nfc/hci/Kconfig
@@ -1,12 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NFC_HCI
-       depends on NFC
-       tristate "NFC HCI implementation"
-       default n
-       help
-	 Say Y here if you want to build support for a kernel NFC HCI
-	 implementation. This is mostly needed for devices that only process
-	 HCI frames, like for example the NXP pn544.
+	depends on NFC
+	tristate "NFC HCI implementation"
+	default n
+	help
+	  Say Y here if you want to build support for a kernel NFC HCI
+	  implementation. This is mostly needed for devices that only process
+	  HCI frames, like for example the NXP pn544.
 
 config NFC_SHDLC
 	depends on NFC_HCI
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 3981bc0d9e6c..6921a18201a0 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -3,13 +3,13 @@
 # XFRM configuration
 #
 config XFRM
-       bool
-       depends on INET
-       select GRO_CELLS
-       select SKB_EXTENSIONS
+	bool
+	depends on INET
+	select GRO_CELLS
+	select SKB_EXTENSIONS
 
 config XFRM_OFFLOAD
-       bool
+	bool
 
 config XFRM_ALGO
 	tristate
-- 
2.17.1

