Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262682834AD
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 13:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgJELKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 07:10:31 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50640 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgJELKb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 07:10:31 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4C4dDj2F9BzFmPn;
        Mon,  5 Oct 2020 04:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1601896229; bh=viVEAAi8axpYSKY5tQdygWfgMthY13fF3GHFlHW4Zdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D0Vw+tznqnHLG3H/HVCLEs3ogVpEDFGn/h2srYXXhVNd5K/bnaP2C7FN2BbdT5dsO
         2TZCw+4OQWPgzR8ylVY1lpOEKtnP5Elk0YdX9nEv256sdSFmGHzT+E7RV7RkdW/sSl
         C+Ah8wl6QWXDqebydctmWKjO0h/Riv18VDjMDZGM=
X-Riseup-User-ID: A78C60995CF1E98674BFEAD3DF6A15A245E5E7DAC89872F6BB567A1DC2C29E8E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4C4dDd05N3z8wT7;
        Mon,  5 Oct 2020 04:10:24 -0700 (PDT)
Date:   Mon, 5 Oct 2020 11:10:20 +0000
From:   Samanta Navarro <ferivoz@riseup.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] man: fix typos
Message-ID: <20201005111020.ggajtydayerg2j3u@localhost>
References: <20201004114259.nwnu3j4uuaryjvx4@localhost>
 <20201004153315.GE4183771@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004153315.GE4183771@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
Hello Andrew,

On Sun, Oct 04, 2020 at 05:33:15PM +0200, Andrew Lunn wrote:
> On Sun, Oct 04, 2020 at 11:42:59AM +0000, Samanta Navarro wrote:
> > @@ -392,7 +392,7 @@ packet the new device should accept.
> >  .TP
> >  .BI gso_max_segs " SEGMENTS "
> >  specifies the recommended maximum number of a Generic Segment Offload
> > -segments the new device should accept.
> > +segment the new device should accept.
> 
> The original seems correct to me.

when I shorten the sentence, it states:
"specifies the number of a segments the device should accept"

Either "a segment" or "segments" without "a" is correct.

After carefully evaluating the sentence in its context, I would agree
that plural is supposed to be used there. The previous sentence in the
manual page is almost identical. This is probably a copy&paste mistake.
And this means that "a" should be removed instead.

Thank you for your feedback!


Samanta
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

