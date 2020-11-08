Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9526A2AACDA
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 19:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgKHSmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 13:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHSmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 13:42:15 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DA1C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 10:42:13 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id f21so3448767plr.5
        for <netdev@vger.kernel.org>; Sun, 08 Nov 2020 10:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gSu1fJTe1N9BZinXxYJSINclf/7GiKw2ffJ7LP7VYkA=;
        b=ZmAtZ7e2bn9zC8JG+T6ChWYLYa0zSFZ+BRhn4uFbZElSMcaFaZjBwCvGhU9PJm4lZu
         RfNq7sbz2aSP4mU5JOgvHi7tG+bZegOuMwcO45E5trOR4uem+PXgW8SJnv2yuFd4KvZM
         GO6dZqe5LZ48Zd9nmLI4QROwxQoXeAR4454lut7Ouy68lhCfNU8u4Hn+iTh5AJ8QxnSi
         KQdV4uGdjfFBnFusB6oFpaPcEQCkmu+yFg04I8JRTT0BdUZQKainfUwJxr8QOf11oOVA
         4qXWxVPuufWNHLBmxtOUwNydsZ0VmIgW0lpywoSb1heg1vGii6Ef1xCxLjJAd3AkTgaB
         Emfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gSu1fJTe1N9BZinXxYJSINclf/7GiKw2ffJ7LP7VYkA=;
        b=ALulxHoessiPyvG4wmXPO5iK8DsKsOyFdI0AWY+Tcw7NoWoxYh8jrGeVbn9ShLtsaG
         TPDhKPiYheaLNEEqlG+xbG9V+h5McRXQik7EVUnyZCT6BVYQju8A/WZCGsFDbaAct0Sw
         KhS5uYqn/GUipV97t5l8XYLSHJ6zsBzXeN9+r/zYNdVHAlaUEhtZoAwUv5eN27H9hvPB
         M6gVY2K9HUt8+oeuDqe7TD3nw/k5H/ggB0Brxj15Z+oOUrkTPOH+uraWBZ6wDD1wfLVd
         gzQDk9mFScXEVwP/ZXlMfFhDnVsUWmM5stXmNM6x+yZ9M2MpDUt9k5UmUO58p1W9DrAh
         KTeA==
X-Gm-Message-State: AOAM533Mx3oK6ZGT8PVSYmCCQ+tcJM3rGOA3EA5q6IfjR6Fze0yna9bw
        XY94e5BuRe9Azmn3/PnYjjzxvB92p85WCwTg
X-Google-Smtp-Source: ABdhPJwb84TvSYBYh7hF63hZto5j8aHg5KtldZuo8FKU4X0gh1fIRxJdYaGygJyVZFG1do+PXxxSxg==
X-Received: by 2002:a17:90b:1b43:: with SMTP id nv3mr9854998pjb.67.1604860932193;
        Sun, 08 Nov 2020 10:42:12 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e14sm8053116pga.61.2020.11.08.10.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 10:42:11 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] man: fix spelling errors
Date:   Sun,  8 Nov 2020 10:42:03 -0800
Message-Id: <20201108184203.5434-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lots of little typo errors on man pages.
Found by running codespell

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 man/man8/ip-link.8.in    | 8 ++++----
 man/man8/ip-macsec.8     | 2 +-
 man/man8/ip-neighbour.8  | 6 +++---
 man/man8/ss.8            | 2 +-
 man/man8/tc-cake.8       | 4 ++--
 man/man8/tc-ct.8         | 2 +-
 man/man8/tc-flower.8     | 4 ++--
 man/man8/tc-matchall.8   | 4 ++--
 man/man8/tc-pie.8        | 4 ++--
 man/man8/tc-sfb.8        | 2 +-
 man/man8/tc-tunnel_key.8 | 4 ++--
 11 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 1eb76655fc3d..1ff017441c7b 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -444,7 +444,7 @@ the following additional arguments are supported:
 - either 802.1Q or 802.1ad.
 
 .BI id " VLANID "
-- specifies the VLAN Identifer to use. Note that numbers with a leading " 0 " or " 0x " are interpreted as octal or hexadeimal, respectively.
+- specifies the VLAN Identifier to use. Note that numbers with a leading " 0 " or " 0x " are interpreted as octal or hexadecimal, respectively.
 
 .BR reorder_hdr " { " on " | " off " } "
 - specifies whether ethernet headers are reordered or not (default is
@@ -575,7 +575,7 @@ the following additional arguments are supported:
 .in +8
 .sp
 .BI  id " VNI "
-- specifies the VXLAN Network Identifer (or VXLAN Segment
+- specifies the VXLAN Network Identifier (or VXLAN Segment
 Identifier) to use.
 
 .BI dev " PHYS_DEV"
@@ -1240,7 +1240,7 @@ the following additional arguments are supported:
 .in +8
 .sp
 .BI  id " VNI "
-- specifies the Virtual Network Identifer to use.
+- specifies the Virtual Network Identifier to use.
 
 .sp
 .BI remote " IPADDR"
@@ -2507,7 +2507,7 @@ specifies the device to display address-family statistics for.
 
 .PP
 .I "TYPE"
-specifies which help of link type to dislpay.
+specifies which help of link type to display.
 
 .SS
 .I GROUP
diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index 8e9175c57eff..6739e51c3632 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -119,7 +119,7 @@ type.
 .SH NOTES
 This tool can be used to configure the 802.1AE keys of the interface. Note that 802.1AE uses GCM-AES
 with a initialization vector (IV) derived from the packet number. The same key must not be used
-with the same IV more than once. Instead, keys must be frequently regenerated and distibuted.
+with the same IV more than once. Instead, keys must be frequently regenerated and distributed.
 This tool is thus mostly for debugging and testing, or in combination with a user-space application
 that reconfigures the keys. It is wrong to just configure the keys statically and assume them to work
 indefinitely. The suggested and standardized way for key management is 802.1X-2010, which is implemented
diff --git a/man/man8/ip-neighbour.8 b/man/man8/ip-neighbour.8
index f71f18b1e59a..a27f9ef847d2 100644
--- a/man/man8/ip-neighbour.8
+++ b/man/man8/ip-neighbour.8
@@ -85,11 +85,11 @@ the interface to which this neighbour is attached.
 
 .TP
 .BI proxy
-indicates whether we are proxying for this neigbour entry
+indicates whether we are proxying for this neighbour entry
 
 .TP
 .BI router
-indicates whether neigbour is a router
+indicates whether neighbour is a router
 
 .TP
 .BI extern_learn
@@ -244,7 +244,7 @@ lookup a neighbour entry to a destination given a device
 
 .TP
 .BI proxy
-indicates whether we should lookup a proxy neigbour entry
+indicates whether we should lookup a proxy neighbour entry
 
 .TP
 .BI to " ADDRESS " (default)
diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 839bab3885fe..e4b9cdcbef6d 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -69,7 +69,7 @@ how long time the timer will expire
 .P
 .TP
 .B <retrans>
-how many times the retransmission occured
+how many times the retransmission occurred
 .RE
 .TP
 .B \-e, \-\-extended
diff --git a/man/man8/tc-cake.8 b/man/man8/tc-cake.8
index 4112b7556599..cb67d15f190a 100644
--- a/man/man8/tc-cake.8
+++ b/man/man8/tc-cake.8
@@ -413,9 +413,9 @@ suffered by Australasian residents.  Equivalent to
 .SH FLOW ISOLATION PARAMETERS
 With flow isolation enabled, CAKE places packets from different flows into
 different queues, each of which carries its own AQM state.  Packets from each
-queue are then delivered fairly, according to a DRR++ algorithm which minimises
+queue are then delivered fairly, according to a DRR++ algorithm which minimizes
 latency for "sparse" flows.  CAKE uses a set-associative hashing algorithm to
-minimise flow collisions.
+minimize flow collisions.
 
 These keywords specify whether fairness based on source address, destination
 address, individual flows, or any combination of those is desired.
diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
index 45d29320f1d0..709e62a99cfd 100644
--- a/man/man8/tc-ct.8
+++ b/man/man8/tc-ct.8
@@ -66,7 +66,7 @@ Restore any previous configured nat.
 Remove any conntrack state and metadata (mark/label) from the packet (must only option specified).
 .TP
 .BI force
-Forces conntrack direction for a previously commited connections, so that current direction will become the original direction (only valid with commit).
+Forces conntrack direction for a previously committed connections, so that current direction will become the original direction (only valid with commit).
 
 .SH EXAMPLES
 Example showing natted firewall in conntrack zone 2, and conntrack mark usage:
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index b5bcfd1d73bc..da3dd75791f7 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -306,7 +306,7 @@ If the prefix is missing, \fBtc\fR assumes a full-length host match.
 .TQ
 .IR \fBsrc_port " { "  MASKED_NUMBER " | " " MIN_VALUE-MAX_VALUE "  }
 Match on layer 4 protocol source or destination port number, with an
-optional mask. Alternatively, the mininum and maximum values can be
+optional mask. Alternatively, the minimum and maximum values can be
 specified to match on a range of layer 4 protocol source or destination
 port numbers. Only available for
 .BR ip_proto " values " udp ", " tcp  " and " sctp
@@ -384,7 +384,7 @@ Matches on connection tracking info
 .RS
 .TP
 .I CT_STATE
-Match the connection state, and can ne combination of [{+|-}flag] flags, where flag can be one of
+Match the connection state, and can be combination of [{+|-}flag] flags, where flag can be one of
 .RS
 .TP
 trk - Tracked connection.
diff --git a/man/man8/tc-matchall.8 b/man/man8/tc-matchall.8
index e3cddb1f1ca5..75c28c94398c 100644
--- a/man/man8/tc-matchall.8
+++ b/man/man8/tc-matchall.8
@@ -45,7 +45,7 @@ tc filter add dev eth1 parent ffff:           \\
 .EE
 .RE
 
-The first command creats an ingress qdisc with handle
+The first command creates an ingress qdisc with handle
 .BR ffff:
 on device
 .BR eth1
@@ -64,7 +64,7 @@ tc filter add dev eth1 parent 1:               \\
 .EE
 .RE
 
-The first command creats an egress qdisc with handle
+The first command creates an egress qdisc with handle
 .BR 1:
 that replaces the root qdisc on device
 .BR eth1
diff --git a/man/man8/tc-pie.8 b/man/man8/tc-pie.8
index 0db97d13b0d5..5a8c782074e7 100644
--- a/man/man8/tc-pie.8
+++ b/man/man8/tc-pie.8
@@ -40,7 +40,7 @@ aims to control delay. The main design goals are
 PIE is designed to control delay effectively. First, an average dequeue rate is
 estimated based on the standing queue. The rate is used to calculate the current
 delay. Then, on a periodic basis, the delay is used to calculate the dropping
-probabilty. Finally, on arrival, a packet is dropped (or marked) based on this
+probability. Finally, on arrival, a packet is dropped (or marked) based on this
 probability.
 
 PIE makes adjustments to the probability based on the trend of the delay i.e.
@@ -52,7 +52,7 @@ growth and are determined through control theoretic approaches. alpha determines
 the deviation between the current and target latency changes probability. beta exerts
 additional adjustments depending on the latency trend.
 
-The drop probabilty is used to mark packets in ecn mode. However, as in RED,
+The drop probability is used to mark packets in ecn mode. However, as in RED,
 beyond 10% packets are dropped based on this probability. The bytemode is used
 to drop packets proportional to the packet size.
 
diff --git a/man/man8/tc-sfb.8 b/man/man8/tc-sfb.8
index aad19e1eb723..e4584deb7520 100644
--- a/man/man8/tc-sfb.8
+++ b/man/man8/tc-sfb.8
@@ -105,7 +105,7 @@ device the qdisc is attached to.
 .TP
 max
 Maximum length of a buckets queue, in packets, before packets start being
-dropped. Should be sightly larger than
+dropped. Should be slightly larger than
 .B target
 , but should not be set to values exceeding 1.5 times that of
 .B target .
diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index ad9972402c0e..f9863f99a6f6 100644
--- a/man/man8/tc-tunnel_key.8
+++ b/man/man8/tc-tunnel_key.8
@@ -96,13 +96,13 @@ variable length hexadecimal value. Additionally multiple options may be
 listed using a comma delimiter.
 .TP
 .B vxlan_opts
-Vxlan metatdata options.
+Vxlan metadata options.
 .B vxlan_opts
 is specified in the form GBP, as a 32bit number. Multiple options is not
 supported.
 .TP
 .B erspan_opts
-Erspan metatdata options.
+Erspan metadata options.
 .B erspan_opts
 is specified in the form VERSION:INDEX:DIR:HWID, where VERSION is represented
 as a 8bit number, INDEX as an 32bit number, DIR and HWID as a 8bit number.
-- 
2.27.0

