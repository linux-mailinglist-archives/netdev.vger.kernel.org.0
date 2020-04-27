Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC841BB133
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgD0WET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgD0WCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:00 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7BF022209;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=gZ3kqaJAqPpuWPwp8rsvec84t06UEJWSiB9rwLxgwaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrtBuD4zHi/kjtU352oo8dk/rXifZwHC7QAq3KbdSRa3Ilr6GFgnWScEtB/mbwma9
         fZCmuep0OhOS76Czi/RwS9zJE0PpFUEpNvcMeJVj8uz5aTmtW8bHMdBI7Km2HRJpH9
         FsJDliIasM/Tp0zQGkxm8wdvxDp7VeriJ221pqj8=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000IpT-3U; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 23/38] docs: networking: convert framerelay.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:38 +0200
Message-Id: <d435143780b022bb15b07fa51a44f53f4a3f1ea6.1588024424.git.mchehab+huawei@kernel.org>
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
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../{framerelay.txt => framerelay.rst}        | 21 ++++++++++++-------
 Documentation/networking/index.rst            |  1 +
 drivers/net/wan/Kconfig                       |  4 ++--
 3 files changed, 16 insertions(+), 10 deletions(-)
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
index b2fb8b907d68..4e225f1f7039 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -58,6 +58,7 @@ Contents:
    fib_trie
    filter
    fore200e
+   framerelay
 
 .. only::  subproject and html
 
diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index dbc0e3f7a3e2..3e21726c36e8 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -336,7 +336,7 @@ config DLCI
 
 	  To use frame relay, you need supporting hardware (called FRAD) and
 	  certain programs from the net-tools package as explained in
-	  <file:Documentation/networking/framerelay.txt>.
+	  <file:Documentation/networking/framerelay.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called dlci.
@@ -361,7 +361,7 @@ config SDLA
 
 	  These are multi-protocol cards, but only Frame Relay is supported
 	  by the driver at this time. Please read
-	  <file:Documentation/networking/framerelay.txt>.
+	  <file:Documentation/networking/framerelay.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called sdla.
-- 
2.25.4

