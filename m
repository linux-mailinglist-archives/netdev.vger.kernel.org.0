Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3750928738E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgJHLtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:49:12 -0400
Received: from mx1.riseup.net ([198.252.153.129]:38038 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgJHLtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 07:49:11 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4C6Txy447NzFpGq;
        Thu,  8 Oct 2020 04:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1602157750; bh=bx+z4djcQXXcXTC2wXtv0tky6q8JFgHlAHAJ/PSS6n0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TkrHHdQL/FGlhYCKeBjcCNqZ3eY/O46sM+tEC/0Zy+41bz81zu2SorLksSGJpbyQb
         Wksi/RfULBLZ8uRacm29z4YhH5jo0hoJqwZxz0jaZtvROFMaKwGfNeR9tARQY58cJZ
         bcpIe7cmLeV4PUaw8iS5lHgAbvQwUz4JUefDhYaE=
X-Riseup-User-ID: E7919AFDA53B4FBE4F51337DB00D70AA293804BDC3EB866079C70C765874343A
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4C6Txx0ntqz8tjQ;
        Thu,  8 Oct 2020 04:49:08 -0700 (PDT)
Date:   Thu, 8 Oct 2020 11:49:05 +0000
From:   Samanta Navarro <ferivoz@riseup.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] man: fix typos
Message-ID: <20201008114905.kldf7hlln74urhaf@localhost>
References: <20201004114259.nwnu3j4uuaryjvx4@localhost>
 <20201006145204.032647c9@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006145204.032647c9@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Samanta Navarro <ferivoz@riseup.net>
---
 man/man8/ip-link.8.in   | 14 +++++++-------
 man/man8/ip-neighbour.8 |  6 +++---
 man/man8/tc-actions.8   |  2 +-
 man/man8/tc-pie.8       |  4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index f451ecf..62d2d9f 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -391,7 +391,7 @@ packet the new device should accept.
 
 .TP
 .BI gso_max_segs " SEGMENTS "
-specifies the recommended maximum number of a Generic Segment Offload
+specifies the recommended maximum number of Generic Segment Offload
 segments the new device should accept.
 
 .TP
@@ -441,7 +441,7 @@ the following additional arguments are supported:
 - either 802.1Q or 802.1ad.
 
 .BI id " VLANID "
-- specifies the VLAN Identifer to use. Note that numbers with a leading " 0 " or " 0x " are interpreted as octal or hexadeimal, respectively.
+- specifies the VLAN Identifier to use. Note that numbers with a leading " 0 " or " 0x " are interpreted as octal or hexadecimal, respectively.
 
 .BR reorder_hdr " { " on " | " off " } "
 - specifies whether ethernet headers are reordered or not (default is
@@ -572,7 +572,7 @@ the following additional arguments are supported:
 .in +8
 .sp
 .BI  id " VNI "
-- specifies the VXLAN Network Identifer (or VXLAN Segment
+- specifies the VXLAN Network Identifier (or VXLAN Segment
 Identifier) to use.
 
 .BI dev " PHYS_DEV"
@@ -1237,7 +1237,7 @@ the following additional arguments are supported:
 .in +8
 .sp
 .BI  id " VNI "
-- specifies the Virtual Network Identifer to use.
+- specifies the Virtual Network Identifier to use.
 
 .sp
 .BI remote " IPADDR"
@@ -2147,7 +2147,7 @@ loaded under
 .B xdpgeneric object "|" pinned
 then the kernel will use the generic XDP variant instead of the native one.
 .B xdpdrv
-has the opposite effect of requestsing that the automatic fallback to the
+has the opposite effect of requesting that the automatic fallback to the
 generic XDP variant be disabled and in case driver is not XDP-capable error
 should be returned.
 .B xdpdrv
@@ -2466,7 +2466,7 @@ specifies the master device which enslaves devices to show.
 .TP
 .BI vrf " NAME "
 .I NAME
-speficies the VRF which enslaves devices to show.
+specifies the VRF which enslaves devices to show.
 
 .TP
 .BI type " TYPE "
@@ -2497,7 +2497,7 @@ specifies the device to display address-family statistics for.
 
 .PP
 .I "TYPE"
-specifies which help of link type to dislpay.
+specifies which help of link type to display.
 
 .SS
 .I GROUP
diff --git a/man/man8/ip-neighbour.8 b/man/man8/ip-neighbour.8
index f71f18b..a27f9ef 100644
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
diff --git a/man/man8/tc-actions.8 b/man/man8/tc-actions.8
index 6f1c201..80df577 100644
--- a/man/man8/tc-actions.8
+++ b/man/man8/tc-actions.8
@@ -253,7 +253,7 @@ should proceed after executing the action. Any of the following are valid:
 .RS
 .TP
 .B reclassify
-Restart the classifiction by jumping back to the first filter attached to
+Restart the classification by jumping back to the first filter attached to
 the action's parent.
 .TP
 .B pipe
diff --git a/man/man8/tc-pie.8 b/man/man8/tc-pie.8
index 0db97d1..5a8c782 100644
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
 
-- 
2.28.0

