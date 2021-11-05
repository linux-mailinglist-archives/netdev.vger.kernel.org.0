Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBE1446B47
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 00:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhKEXit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 19:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhKEXis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 19:38:48 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA37C061570
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 16:36:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u18so16110492wrg.5
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 16:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J7raEtiJfEmVVjX1DDEbMvonHZ+gRFWrQXIuqgDl5Lw=;
        b=fQIGFb2hMgqIq/1CheYXijkK+TxyN3W3ysOVM+/VxfhwSxV4EVwbf/fw+4yvsg+g6G
         HTyPei2qlD72ctwvizcWG2GyxH7P83DHroBMeowRm2KAB8y88QHNOX+GhbzMVdS1inTJ
         8p/mNhc1lUYxoWs9h7CiTOgTSjaXJ3zcq/aygqNVFNPkwFnIfQvQUXQMDzRrU15/ihnN
         R6PLhCnp29qQSa+ji9wb/QD/LsYxvYZgdxQebbxz43wGZkn7nfD1m0rN42z5NlHh9acq
         mCW4piYOhKcP5al8bKtGja3MUSo7u1E7sYltm8HlzHKfzNkZbuIwo/2kx8WgR3s9S3nE
         0kKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J7raEtiJfEmVVjX1DDEbMvonHZ+gRFWrQXIuqgDl5Lw=;
        b=Xv8B3QX+hTIOOXuLt6BU1YZ1MOZyCpbJbEPDCitU+F5+2MzrgGpJ1OzGnJWwImjeQd
         l18YMEE8Drht1ywgfQ+1vMWNGhPsAp+C+VBT22mEQra5LGg5oIOihtC7KzsyMsusfRWC
         BDuLqlGX9PWY/S1jKpegH/pJvZdLhyX02QynBC+SuP62vz1+BEJPt7c63kapAruAwaXs
         e7gove5CHCynpwqphWw27/h+NKotl/Gwju0rDJN4mwWD362iyRhfi7AhWjX8dLmxyUdH
         4LoLszT6rxCFHr0WibIvVsUJN5v3mhdJrNF80+6v3FjLReF3YoChLMsEkXSrOLBLlhVf
         y1Nw==
X-Gm-Message-State: AOAM531gsNn/0Itm/RcwXQQ4xYgJA/Vk4ZbEDnKunDApyEu7vd5ro8VW
        PAII96P4MNCu4gDUp8Qog7mKC/O0UHW+CA==
X-Google-Smtp-Source: ABdhPJyTrNbFGhtCjeGvwNyFBOT/rJSkLDQKqvmmoCY9bbe8QWMgH0tuJQTPQxuXONOZNYnGSpn6Qg==
X-Received: by 2002:adf:e882:: with SMTP id d2mr78206126wrm.389.1636155366307;
        Fri, 05 Nov 2021 16:36:06 -0700 (PDT)
Received: from localhost ([137.220.125.106])
        by smtp.gmail.com with ESMTPSA id l5sm6865206wrs.59.2021.11.05.16.36.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 16:36:05 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2] Fix some typos detected by Lintian in manpages
Date:   Fri,  5 Nov 2021 23:36:02 +0000
Message-Id: <20211105233602.3293408-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Boccassi <bluca@debian.org>

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
Usual bunch of typos found by Lintian as I uploaded the new version.
As usual no opinion on alternate phrasing/spelling, just want to silence
Lintian.

 doc/actions/gact-usage   | 2 +-
 man/man8/devlink-rate.8  | 2 +-
 man/man8/ip-link.8.in    | 6 +++---
 man/man8/ss.8            | 2 +-
 man/man8/tc-basic.8      | 2 +-
 man/man8/tc-fw.8         | 4 ++--
 man/man8/tc-matchall.8   | 2 +-
 man/man8/tc-nat.8        | 2 +-
 man/man8/tc-netem.8      | 4 ++--
 man/man8/tc-pedit.8      | 6 +++---
 man/man8/tc-sample.8     | 4 ++--
 man/man8/tc-skbedit.8    | 4 ++--
 man/man8/tc-tcindex.8    | 2 +-
 man/man8/tc-tunnel_key.8 | 2 +-
 man/man8/tc-u32.8        | 4 ++--
 man/man8/tc-vlan.8       | 2 +-
 man/man8/tc-xt.8         | 2 +-
 17 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/doc/actions/gact-usage b/doc/actions/gact-usage
index 5fc3e628..7cf48abb 100644
--- a/doc/actions/gact-usage
+++ b/doc/actions/gact-usage
@@ -10,7 +10,7 @@ Where:
 
 ACTION semantics
 - pass and ok are equivalent to accept
-- continue allows to restart classification lookup
+- continue allows one to restart classification lookup
 - drop drops packets
 - reclassify implies continue classification where we left off
 
diff --git a/man/man8/devlink-rate.8 b/man/man8/devlink-rate.8
index b2dc8343..cc2f50c3 100644
--- a/man/man8/devlink-rate.8
+++ b/man/man8/devlink-rate.8
@@ -63,7 +63,7 @@ Command output show rate object identifier, it's type and rate values along with
 parent node name. Rate values printed in SI units which are more suitable to
 represent specific value. To print values in IEC units \fB-i\fR switch is
 used. JSON (\fB-j\fR) output always print rate values in bytes per second. Zero
-rate values means "unlimited" rates and ommited in output, as well as parent
+rate values means "unlimited" rates and omitted in output, as well as parent
 node name.
 
 .SS devlink port function rate set - set rate object parameters.
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 1d67c9a4..19a0c9ca 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -462,7 +462,7 @@ then VLAN header will be not inserted immediately but only before
 passing to the physical device (if this device does not support VLAN
 offloading), the similar on the RX direction - by default the packet
 will be untagged before being received by VLAN device. Reordering
-allows to accelerate tagging on egress and to hide VLAN header on
+allows one to accelerate tagging on egress and to hide VLAN header on
 ingress so the packet looks like regular Ethernet packet, at the same
 time it might be confusing for packet capture as the VLAN header does
 not exist within the packet.
@@ -691,7 +691,7 @@ or the internal FDB should be used.
 - enables the Group Policy extension (VXLAN-GBP).
 
 .in +4
-Allows to transport group policy context across VXLAN network peers.
+Allows one to transport group policy context across VXLAN network peers.
 If enabled, includes the mark of a packet in the VXLAN header for outgoing
 packets and fills the packet mark based on the information found in the
 VXLAN header for incoming packets.
@@ -2093,7 +2093,7 @@ flag in the output of the
 
 To change network namespace for wireless devices the
 .B iw
-tool can be used. But it allows to change network namespace only for
+tool can be used. But it allows one to change network namespace only for
 physical devices and by process
 .IR PID .
 
diff --git a/man/man8/ss.8 b/man/man8/ss.8
index d399381d..68f0a699 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -409,7 +409,7 @@ Please take a look at the official documentation for details regarding filters.
 .SH STATE-FILTER
 
 .B STATE-FILTER
-allows to construct arbitrary set of states to match. Its syntax is
+allows one to construct arbitrary set of states to match. Its syntax is
 sequence of keywords state and exclude followed by identifier of
 state.
 .TP
diff --git a/man/man8/tc-basic.8 b/man/man8/tc-basic.8
index fb39eaa9..d86d46ab 100644
--- a/man/man8/tc-basic.8
+++ b/man/man8/tc-basic.8
@@ -14,7 +14,7 @@ basic \- basic traffic control filter
 .SH DESCRIPTION
 The
 .B basic
-filter allows to classify packets using the extended match infrastructure.
+filter allows one to classify packets using the extended match infrastructure.
 .SH OPTIONS
 .TP
 .BI action " ACTION_SPEC"
diff --git a/man/man8/tc-fw.8 b/man/man8/tc-fw.8
index d742b473..711e128f 100644
--- a/man/man8/tc-fw.8
+++ b/man/man8/tc-fw.8
@@ -12,13 +12,13 @@ fw \- fwmark traffic control filter
 .SH DESCRIPTION
 the
 .B fw
-filter allows to classify packets based on a previously set
+filter allows one to classify packets based on a previously set
 .BR fwmark " by " iptables .
 If it is identical to the filter's
 .BR handle ,
 the filter matches.
 .B iptables
-allows to mark single packets with the
+allows one to mark single packets with the
 .B MARK
 target, or whole connections using
 .BR CONNMARK .
diff --git a/man/man8/tc-matchall.8 b/man/man8/tc-matchall.8
index 75c28c94..d0224066 100644
--- a/man/man8/tc-matchall.8
+++ b/man/man8/tc-matchall.8
@@ -15,7 +15,7 @@ matchall \- traffic control filter that matches every packet
 .SH DESCRIPTION
 The
 .B matchall
-filter allows to classify every packet that flows on the port and run a
+filter allows one to classify every packet that flows on the port and run a
 action on it.
 .SH OPTIONS
 .TP
diff --git a/man/man8/tc-nat.8 b/man/man8/tc-nat.8
index fdcc052a..f3b17ef5 100644
--- a/man/man8/tc-nat.8
+++ b/man/man8/tc-nat.8
@@ -25,7 +25,7 @@ nat - stateless native address translation action
 .SH DESCRIPTION
 The
 .B nat
-action allows to perform NAT without the overhead of conntrack, which is
+action allows one to perform NAT without the overhead of conntrack, which is
 desirable if the number of flows or addresses to perform NAT on is large. This
 action is best used in combination with the
 .B u32
diff --git a/man/man8/tc-netem.8 b/man/man8/tc-netem.8
index 5a08a406..63ccc2a3 100644
--- a/man/man8/tc-netem.8
+++ b/man/man8/tc-netem.8
@@ -82,7 +82,7 @@ maximum number of packets the qdisc may hold queued at a time.
 
 .SS delay
 adds the chosen delay to the packets outgoing to chosen network interface. The
-optional parameters allows to introduce a delay variation and a correlation.
+optional parameters allows one to introduce a delay variation and a correlation.
 Delay and jitter values are expressed in ms while correlation is percentage.
 
 .SS distribution
@@ -99,7 +99,7 @@ is now deprecated due to the noticed bad behavior.
 .SS loss state
 adds packet losses according to the 4-state Markov using the transition
 probabilities as input parameters. The parameter p13 is mandatory and if used
-alone corresponds to the Bernoulli model. The optional parameters allows to
+alone corresponds to the Bernoulli model. The optional parameters allows one to
 extend the model to 2-state (p31), 3-state (p23 and p32) and 4-state (p14).
 State 1 corresponds to good reception, State 4 to independent losses, State 3
 to burst losses and State 2 to good reception within a burst.
diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index 15159ddd..b9d5a44b 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -118,7 +118,7 @@ or a single byte
 .BI at " AT " offmask " MASK " shift " SHIFT"
 This is an optional part of
 .IR RAW_OP
-which allows to have a variable
+which allows one to have a variable
 .I OFFSET
 depending on packet data at offset
 .IR AT ,
@@ -202,7 +202,7 @@ unexpected things.
 .B icmp_type
 .TQ
 .B icmp_code
-Again, this allows to change data past the actual IP header itself. It assumes
+Again, this allows one to change data past the actual IP header itself. It assumes
 an ICMP header is present immediately following the (minimal sized) IP header.
 If it is not or the latter is bigger than the minimum of 20 bytes, this will do
 unexpected things. These fields are eight-bit values.
@@ -300,7 +300,7 @@ Keep the addressed data as is.
 .BI retain " RVAL"
 This optional extra part of
 .I CMD_SPEC
-allows to exclude bits from being changed. Supported only for 32 bits fields
+allows one to exclude bits from being changed. Supported only for 32 bits fields
 or smaller.
 .TP
 .I CONTROL
diff --git a/man/man8/tc-sample.8 b/man/man8/tc-sample.8
index c4277caf..44fc2628 100644
--- a/man/man8/tc-sample.8
+++ b/man/man8/tc-sample.8
@@ -92,8 +92,8 @@ packets that came from a specific rule.
 .TP
 .BI index " INDEX"
 Is a unique ID for an action. When creating new action instance, this parameter
-allows to set the new action index. When using existing action, this parameter
-allows to specify the existing action index.  The index must 32bit unsigned
+allows one to set the new action index. When using existing action, this parameter
+allows one to specify the existing action index.  The index must 32bit unsigned
 integer greater than zero.
 .SH EXAMPLES
 Sample one of every 100 packets flowing into interface eth0 to psample group 12:
diff --git a/man/man8/tc-skbedit.8 b/man/man8/tc-skbedit.8
index 704f63bd..b2f8e75d 100644
--- a/man/man8/tc-skbedit.8
+++ b/man/man8/tc-skbedit.8
@@ -16,9 +16,9 @@ skbedit - SKB editing action
 .SH DESCRIPTION
 The
 .B skbedit
-action allows to change a packet's associated meta data. It complements the
+action allows one to change a packet's associated meta data. It complements the
 .B pedit
-action, which in turn allows to change parts of the packet data itself.
+action, which in turn allows one to change parts of the packet data itself.
 
 The most unique feature of
 .B skbedit
diff --git a/man/man8/tc-tcindex.8 b/man/man8/tc-tcindex.8
index 9a4e5ffc..ccf2c5e8 100644
--- a/man/man8/tc-tcindex.8
+++ b/man/man8/tc-tcindex.8
@@ -16,7 +16,7 @@ tcindex \- traffic control index filter
 .B action
 .BR ACTION_SPEC " ]"
 .SH DESCRIPTION
-This filter allows to match packets based on their
+This filter allows one to match packets based on their
 .B tcindex
 field value, i.e. the combination of the DSCP and ECN fields as present in IPv4
 and IPv6 headers.
diff --git a/man/man8/tc-tunnel_key.8 b/man/man8/tc-tunnel_key.8
index f9863f99..f639f433 100644
--- a/man/man8/tc-tunnel_key.8
+++ b/man/man8/tc-tunnel_key.8
@@ -23,7 +23,7 @@ tunnel_key - Tunnel metadata manipulation
 .SH DESCRIPTION
 The
 .B tunnel_key
-action combined with a shared IP tunnel device, allows to perform IP tunnel en-
+action combined with a shared IP tunnel device, allows one to perform IP tunnel en-
 or decapsulation on a packet, reflected by
 the operation modes
 .IR UNSET " and " SET .
diff --git a/man/man8/tc-u32.8 b/man/man8/tc-u32.8
index fec9af7f..e5690681 100644
--- a/man/man8/tc-u32.8
+++ b/man/man8/tc-u32.8
@@ -150,7 +150,7 @@ u32 \- universal 32bit traffic control filter
 .BR at " [ " nexthdr+ " ] "
 .IR int_value " ]"
 .SH DESCRIPTION
-The Universal/Ugly 32bit filter allows to match arbitrary bitfields in the
+The Universal/Ugly 32bit filter allows one to match arbitrary bitfields in the
 packet. Due to breaking everything down to values, masks and offsets, It is
 equally powerful and hard to use. Luckily many abstracting directives are
 present which allow defining rules on a higher level and therefore free the
@@ -375,7 +375,7 @@ or IPv6 (
 .BR ip6 )
 header.
 .IR IP / IP6
-then allows to match various header fields:
+then allows one to match various header fields:
 .RS
 .TP
 .BI src " ADDR"
diff --git a/man/man8/tc-vlan.8 b/man/man8/tc-vlan.8
index 264053d3..eee663fa 100644
--- a/man/man8/tc-vlan.8
+++ b/man/man8/tc-vlan.8
@@ -35,7 +35,7 @@ vlan - vlan manipulation module
 .SH DESCRIPTION
 The
 .B vlan
-action allows to perform 802.1Q en- or decapsulation on a packet, reflected by
+action allows one to perform 802.1Q en- or decapsulation on a packet, reflected by
 the operation modes
 .IR POP ", " PUSH " and " MODIFY .
 The
diff --git a/man/man8/tc-xt.8 b/man/man8/tc-xt.8
index 4fd800cf..f6dc5add 100644
--- a/man/man8/tc-xt.8
+++ b/man/man8/tc-xt.8
@@ -10,7 +10,7 @@ xt - tc iptables action
 .SH DESCRIPTION
 The
 .B xt
-action allows to call arbitrary iptables targets for packets matching the filter
+action allows one to call arbitrary iptables targets for packets matching the filter
 this action is attached to.
 .SH OPTIONS
 .TP
-- 
2.30.2

