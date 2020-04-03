Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2EA119D3E7
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 11:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390689AbgDCJjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 05:39:16 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:38083 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgDCJjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 05:39:16 -0400
Received: by mail-wm1-f48.google.com with SMTP id f6so6946637wmj.3
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 02:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sVPrhy+ndtUsvjOeE01l1Y6A0Bu29+XN2mn6C00LAEs=;
        b=pinWO70M5XjFXML4xnXpa9mlGnQhjyMOzrqZ0qQIG81im4RZdHwVSaGTKYMr8/1sv4
         Kk7Ph0WaGGLJOVFMm5h0qqwVJAgs7Yl7HPd6QrGL7V6IjhvC2nEGbkWdLfZc8+8i3yDk
         tmOHAgtLVLQ9ekh/+NszS7o5SFDU4xC6St655YLpn8w/3xvf2zK1GJYdHSM407iX8vdR
         vERoBpkFijlHgdXKyUp4WNRZ+1GkdTXwLcgx+mdv3xqCC0JayVjp6A9MDNdoHKHrhGbS
         ZKJeC6OjvaKX6xwCbyVbUcEG3H2YIg87jAiZIuXeEHj1NVXZyTDdAS74YpPE11K0XbKs
         kaCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sVPrhy+ndtUsvjOeE01l1Y6A0Bu29+XN2mn6C00LAEs=;
        b=DqzrQc6Zt9GrL4WHP5MB0fpXhayrt/3G0yNy3gVoeLnoFO+CIhO1xZFjHLf4yr2h4n
         xYhGOzmlEOiVje8RD18yquFvTeC3eqUcnQBlakqOH/9dUv40TSrAPFiyVyHT+l6Xg5Y0
         KIgvEjieNvOtSGg4bJ2rl8N3wa1nXmaeLNWo5Evr9gkCBczJKzD1vbi+iHjUAP1m2RF7
         RL97z8MeMOUvqbRqYwI4ooGuFT2uONAjxuXp+pmK7TMmviZl7kSf4/YnsyfrlisNFG/H
         XKO3QTkShLVQjy9FdYJzZgvoBqBzwUSjJsQ4rV8WVjokyiop7ZLSLuer1qiUpxPVO28G
         bnQA==
X-Gm-Message-State: AGi0PubiWSPrEe1FaOJISm/1e4A53WUDcgnb+4dGnF2raZA1u2+mwBy1
        XpmmF1dO9Ga5FmGU39gqvrLyTz9T
X-Google-Smtp-Source: APiQypIL7wgE6rmz5VxAHMi+Y+4+96fg8jt8N9INxS6+DMS6B7IVg7RGXZ6C1LKPw2epS88KJwxnxg==
X-Received: by 2002:a7b:c002:: with SMTP id c2mr7716747wmb.123.1585906752265;
        Fri, 03 Apr 2020 02:39:12 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id j6sm11998171wrb.4.2020.04.03.02.39.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 02:39:11 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2] Fix spelling issues found by Lintian
Date:   Fri,  3 Apr 2020 10:38:54 +0100
Message-Id: <20200403093855.7111-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Boccassi <bluca@debian.org>

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
Just trying to get Lintian off my back...

 doc/actions/gact-usage   |  2 +-
 include/uapi/linux/bpf.h |  2 +-
 man/man8/ip-link.8.in    | 14 +++++++-------
 man/man8/ip-macsec.8     |  2 +-
 man/man8/ss.8            |  4 ++--
 man/man8/tc-basic.8      |  2 +-
 man/man8/tc-ctinfo.8     |  2 +-
 man/man8/tc-flower.8     |  2 +-
 man/man8/tc-fw.8         |  4 ++--
 man/man8/tc-matchall.8   |  2 +-
 man/man8/tc-nat.8        |  2 +-
 man/man8/tc-netem.8      |  8 ++++----
 man/man8/tc-pedit.8      |  8 ++++----
 man/man8/tc-police.8     |  2 +-
 man/man8/tc-sample.8     |  4 ++--
 man/man8/tc-skbedit.8    |  4 ++--
 man/man8/tc-skbmod.8     |  2 +-
 man/man8/tc-tcindex.8    |  2 +-
 man/man8/tc-tunnel_key.8 |  2 +-
 man/man8/tc-u32.8        |  4 ++--
 man/man8/tc-vlan.8       |  4 ++--
 man/man8/tc-xt.8         |  2 +-
 man/man8/tc.8            |  2 +-
 23 files changed, 41 insertions(+), 41 deletions(-)

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
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 65764580..af3b19d3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2459,7 +2459,7 @@ union bpf_attr {
  * int bpf_spin_lock(struct bpf_spin_lock *lock)
  *	Description
  *		Acquire a spinlock represented by the pointer *lock*, which is
- *		stored as part of a value of a map. Taking the lock allows to
+ *		stored as part of a value of a map. Taking the lock allows one to
  *		safely update the rest of the fields in that value. The
  *		spinlock can (and must) later be released with a call to
  *		**bpf_spin_unlock**\ (\ *lock*\ ).
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 939e2ad4..8ee96beb 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -437,7 +437,7 @@ the following additional arguments are supported:
 - either 802.1Q or 802.1ad.
 
 .BI id " VLANID "
-- specifies the VLAN Identifer to use. Note that numbers with a leading " 0 " or " 0x " are interpreted as octal or hexadeimal, respectively.
+- specifies the VLAN Identifier to use. Note that numbers with a leading " 0 " or " 0x " are interpreted as octal or hexadeimal, respectively.
 
 .BR reorder_hdr " { " on " | " off " } "
 - specifies whether ethernet headers are reordered or not (default is
@@ -450,7 +450,7 @@ then VLAN header will be not inserted immediately but only before
 passing to the physical device (if this device does not support VLAN
 offloading), the similar on the RX direction - by default the packet
 will be untagged before being received by VLAN device. Reordering
-allows to accelerate tagging on egress and to hide VLAN header on
+allows one to accelerate tagging on egress and to hide VLAN header on
 ingress so the packet looks like regular Ethernet packet, at the same
 time it might be confusing for packet capture as the VLAN header does
 not exist within the packet.
@@ -568,7 +568,7 @@ the following additional arguments are supported:
 .in +8
 .sp
 .BI  id " VNI "
-- specifies the VXLAN Network Identifer (or VXLAN Segment
+- specifies the VXLAN Network Identifier (or VXLAN Segment
 Identifier) to use.
 
 .BI dev " PHYS_DEV"
@@ -679,7 +679,7 @@ or the internal FDB should be used.
 - enables the Group Policy extension (VXLAN-GBP).
 
 .in +4
-Allows to transport group policy context across VXLAN network peers.
+Allows one to transport group policy context across VXLAN network peers.
 If enabled, includes the mark of a packet in the VXLAN header for outgoing
 packets and fills the packet mark based on the information found in the
 VXLAN header for incoming packets.
@@ -1233,7 +1233,7 @@ the following additional arguments are supported:
 .in +8
 .sp
 .BI  id " VNI "
-- specifies the Virtual Network Identifer to use.
+- specifies the Virtual Network Identifier to use.
 
 .sp
 .BI remote " IPADDR"
@@ -1936,7 +1936,7 @@ flag in the output of the
 
 To change network namespace for wireless devices the
 .B iw
-tool can be used. But it allows to change network namespace only for
+tool can be used. But it allows one to change network namespace only for
 physical devices and by process
 .IR PID .
 
@@ -2424,7 +2424,7 @@ specifies the device to display address-family statistics for.
 
 .PP
 .I "TYPE"
-specifies which help of link type to dislpay.
+specifies which help of link type to display.
 
 .SS
 .I GROUP
diff --git a/man/man8/ip-macsec.8 b/man/man8/ip-macsec.8
index 2179b336..926b8adf 100644
--- a/man/man8/ip-macsec.8
+++ b/man/man8/ip-macsec.8
@@ -106,7 +106,7 @@ type.
 .SH NOTES
 This tool can be used to configure the 802.1AE keys of the interface. Note that 802.1AE uses GCM-AES
 with a initialization vector (IV) derived from the packet number. The same key must not be used
-with the same IV more than once. Instead, keys must be frequently regenerated and distibuted.
+with the same IV more than once. Instead, keys must be frequently regenerated and distributed.
 This tool is thus mostly for debugging and testing, or in combination with a user-space application
 that reconfigures the keys. It is wrong to just configure the keys statically and assume them to work
 indefinitely. The suggested and standardized way for key management is 802.1X-2010, which is implemented
diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 023d771b..78157c68 100644
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
@@ -392,7 +392,7 @@ Please take a look at the official documentation for details regarding filters.
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
diff --git a/man/man8/tc-ctinfo.8 b/man/man8/tc-ctinfo.8
index 5b761a8f..efa2eeca 100644
--- a/man/man8/tc-ctinfo.8
+++ b/man/man8/tc-ctinfo.8
@@ -58,7 +58,7 @@ Specify the conntrack zone when doing conntrack lookups for packets.
 zone is a 16bit unsigned decimal value.
 Default is 0.
 .IP CONTROL
-The following keywords allow to control how the tree of qdisc, classes,
+The following keywords allow one to control how the tree of qdisc, classes,
 filters and actions is further traversed after this action.
 .RS
 .TP
diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index eb9eb5f0..bda4f81c 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -225,7 +225,7 @@ If the prefix is missing, \fBtc\fR assumes a full-length host match.
 .TQ
 .IR \fBsrc_port " { "  MASKED_NUMBER " | " " MIN_VALUE-MAX_VALUE "  }
 Match on layer 4 protocol source or destination port number, with an
-optional mask. Alternatively, the mininum and maximum values can be
+optional mask. Alternatively, the minimum and maximum values can be
 specified to match on a range of layer 4 protocol source or destination
 port numbers. Only available for
 .BR ip_proto " values " udp ", " tcp  " and " sctp
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
index e3cddb1f..81d38a92 100644
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
index 5a08a406..21775854 100644
--- a/man/man8/tc-netem.8
+++ b/man/man8/tc-netem.8
@@ -67,7 +67,7 @@ NetEm \- Network Emulator
 
 .SH DESCRIPTION
 NetEm is an enhancement of the Linux traffic control facilities
-that allow to add delay, packet loss, duplication and more other
+that allow one to add delay, packet loss, duplication and more other
 characteristics to packets outgoing from a selected network
 interface. NetEm is built using the existing Quality Of Service (QOS)
 and Differentiated Services (diffserv) facilities in the Linux
@@ -82,12 +82,12 @@ maximum number of packets the qdisc may hold queued at a time.
 
 .SS delay
 adds the chosen delay to the packets outgoing to chosen network interface. The
-optional parameters allows to introduce a delay variation and a correlation.
+optional parameters allows one to introduce a delay variation and a correlation.
 Delay and jitter values are expressed in ms while correlation is percentage.
 
 .SS distribution
 allow the user to choose the delay distribution. If not specified, the default
-distribution is Normal. Additional parameters allow to consider situations in
+distribution is Normal. Additional parameters allow one to consider situations in
 which network has variable delays depending on traffic flows concurring on the
 same path, that causes several delay peaks and a tail.
 
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
index bbd725c4..27593f01 100644
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
@@ -293,11 +293,11 @@ Keep the addressed data as is.
 .BI retain " RVAL"
 This optional extra part of
 .I CMD_SPEC
-allows to exclude bits from being changed. Supported only for 32 bits fields
+allows one to exclude bits from being changed. Supported only for 32 bits fields
 or smaller.
 .TP
 .I CONTROL
-The following keywords allow to control how the tree of qdisc, classes,
+The following keywords allow one to control how the tree of qdisc, classes,
 filters and actions is further traversed after this action.
 .RS
 .TP
diff --git a/man/man8/tc-police.8 b/man/man8/tc-police.8
index 52279755..092f920d 100644
--- a/man/man8/tc-police.8
+++ b/man/man8/tc-police.8
@@ -34,7 +34,7 @@ police - policing action
 .SH DESCRIPTION
 The
 .B police
-action allows to limit bandwidth of traffic matched by the filter it is
+action allows one to limit bandwidth of traffic matched by the filter it is
 attached to. Basically there are two different algorithms available to measure
 the packet rate: The first one uses an internal dual token bucket and is
 configured using the
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
diff --git a/man/man8/tc-skbmod.8 b/man/man8/tc-skbmod.8
index eb3c38fa..2bf98949 100644
--- a/man/man8/tc-skbmod.8
+++ b/man/man8/tc-skbmod.8
@@ -54,7 +54,7 @@ directive is performed
 after any outstanding D/SMAC changes.
 .TP
 .I CONTROL
-The following keywords allow to control how the tree of qdisc, classes,
+The following keywords allow one to control how the tree of qdisc, classes,
 filters and actions is further traversed after this action.
 .RS
 .TP
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
index 2145eb62..c252b25e 100644
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
index a23a1846..b4266ba8 100644
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
index f5ffc25f..9aa221ea 100644
--- a/man/man8/tc-vlan.8
+++ b/man/man8/tc-vlan.8
@@ -30,7 +30,7 @@ vlan - vlan manipulation module
 .SH DESCRIPTION
 The
 .B vlan
-action allows to perform 802.1Q en- or decapsulation on a packet, reflected by
+action allows one to perform 802.1Q en- or decapsulation on a packet, reflected by
 the operation modes
 .IR POP ", " PUSH " and " MODIFY .
 The
@@ -40,7 +40,7 @@ outer-most VLAN encapsulation. The
 .IR PUSH " and " MODIFY
 modes require at least a
 .I VLANID
-and allow to optionally choose the
+and allow one to optionally choose the
 .I VLANPROTO
 to use.
 .SH OPTIONS
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
diff --git a/man/man8/tc.8 b/man/man8/tc.8
index e8e0cd0f..bf955d3e 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -320,7 +320,7 @@ band is not stopped prior to dequeuing a packet.
 .TP
 netem
 Network Emulator is an enhancement of the Linux traffic control facilities that
-allow to add delay, packet loss, duplication and more other characteristics to
+allow one to add delay, packet loss, duplication and more other characteristics to
 packets outgoing from a selected network interface.
 .TP
 pfifo_fast
-- 
2.20.1

