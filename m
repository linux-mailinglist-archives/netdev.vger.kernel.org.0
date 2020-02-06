Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05BA1547CE
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgBFPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:23 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38018 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tE447pia6RDKV6kfdANS+czYd2/mpOi7u291Ajc7iKM=; b=eRvjWjTikv4oJAiZ1vPB9gDZZB
        zUTMUNvM8ny2lK6yZYKGcvprPBHLaosZAjfY+1vg6y9ttz6y1njcbsxJ4eemdBA+XU7N8ES52AkH4
        LFVRlS8XmRpMoh50oe9+5ToslbAoe8J9cxcD3YaXv5Y+GDLh7pvGsH1ybPt9EQzPi0JZLUiyaDeLX
        pqbNtnZ2TyXyYnf1WaTLV0GeZjaGum1mXY6Vz3KuEJdyp3Ok3KVqaP9s8NQrCDsKJGzHX1BPkrupa
        5lWaD4O/MtdeqbQcTSK5LoGfnjUuVhOyb0ffsyYbQiEFzTTqWL8EM3Kkbc4n0UeZANPfDrLsLNmqJ
        xcj7UsPA==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziuk-0005jL-WB; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oWJ-Sr; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 24/28] docs: networking: convert framerelay.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:44 +0100
Message-Id: <4c2c0494a2e8f985530e48c87c143ce1a337bbf1.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.


Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../{framerelay.txt => framerelay.rst}        | 21 ++++++++++++-------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 14 insertions(+), 8 deletions(-)
 rename Documentation/networking/{framerelay.txt => framerelay.rst} (93%)

diff --git a/Documentation/networking/framerelay.txt b/Documentation/networking/framerelay.rst
similarity index 93%
rename from Documentation/networking/framerelay.txt
rename to Documentation/networking/framerelay.rst
index 1a0b720440dd..6d904399ec6d 100644
--- a/Documentation/networking/framerelay.txt
+++ b/Documentation/networking/framerelay.rst
@@ -1,4 +1,10 @@
-Frame Relay (FR) support for linux is built into a two tiered system of device 
+.. SPDX-License-Identifier: GPL-2.0
+
+================
+Frame Relay (FR)
+================
+
+Frame Relay (FR) support for linux is built into a two tiered system of device
 drivers.  The upper layer implements RFC1490 FR specification, and uses the
 Data Link Connection Identifier (DLCI) as its hardware address.  Usually these
 are assigned by your network supplier, they give you the number/numbers of
@@ -7,18 +13,18 @@ the Virtual Connections (VC) assigned to you.
 Each DLCI is a point-to-point link between your machine and a remote one.
 As such, a separate device is needed to accommodate the routing.  Within the
 net-tools archives is 'dlcicfg'.  This program will communicate with the
-base "DLCI" device, and create new net devices named 'dlci00', 'dlci01'... 
+base "DLCI" device, and create new net devices named 'dlci00', 'dlci01'...
 The configuration script will ask you how many DLCIs you need, as well as
 how many DLCIs you want to assign to each Frame Relay Access Device (FRAD).
 
 The DLCI uses a number of function calls to communicate with the FRAD, all
-of which are stored in the FRAD's private data area.  assoc/deassoc, 
+of which are stored in the FRAD's private data area.  assoc/deassoc,
 activate/deactivate and dlci_config.  The DLCI supplies a receive function
 to the FRAD to accept incoming packets.
 
 With this initial offering, only 1 FRAD driver is available.  With many thanks
-to Sangoma Technologies, David Mandelstam & Gene Kozin, the S502A, S502E & 
-S508 are supported.  This driver is currently set up for only FR, but as 
+to Sangoma Technologies, David Mandelstam & Gene Kozin, the S502A, S502E &
+S508 are supported.  This driver is currently set up for only FR, but as
 Sangoma makes more firmware modules available, it can be updated to provide
 them as well.
 
@@ -32,8 +38,7 @@ an initial configuration.
 Additional FRAD device drivers can be added as hardware is available.
 
 At this time, the dlcicfg and fradcfg programs have not been incorporated into
-the net-tools distribution.  They can be found at ftp.invlogic.com, in 
+the net-tools distribution.  They can be found at ftp.invlogic.com, in
 /pub/linux.  Note that with OS/2 FTPD, you end up in /pub by default, so just
-use 'cd linux'.  v0.10 is for use on pre-2.0.3 and earlier, v0.15 is for 
+use 'cd linux'.  v0.10 is for use on pre-2.0.3 and earlier, v0.15 is for
 pre-2.0.4 and later.
-
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 022e0e895156..538b9d3e838e 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -56,6 +56,7 @@ Contents:
    fib_trie
    filter
    fore200e
+   framerelay
 
 .. only::  subproject and html
 
-- 
2.24.1

