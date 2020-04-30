Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637481C0194
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgD3QG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A49624970;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=nFix0a/j/Cj5TviaDz5+T9+Ut0oC83oAgMWkoZOnEvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkzFj0pBnvQtFcGQpcY7mKuY7CwzkLdlE9w6FUv7aqrdOx4zaGMTkIpYV8ysll2T1
         YWMwLz/uVefvLrz5q1HgKt9hKtsA6TpgTUSWhUnk7V6Ll+9UTUBJpAFWzWDgGHYEKr
         kSTOF+2o8uoSimJ5RQtZMq8CkGNGhZnKfh58O9FU=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxFc-Fq; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 19/37] docs: networking: convert PLIP.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:14 +0200
Message-Id: <3a25bd7bb5cda9f622d43584bd0d062034fa4fb6.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../networking/{PLIP.txt => plip.rst}         | 43 +++++++++++--------
 drivers/net/plip/Kconfig                      |  2 +-
 3 files changed, 27 insertions(+), 19 deletions(-)
 rename Documentation/networking/{PLIP.txt => plip.rst} (92%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 696181a96e3c..18bb10239cad 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -92,6 +92,7 @@ Contents:
    packet_mmap
    phonet
    pktgen
+   plip
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/PLIP.txt b/Documentation/networking/plip.rst
similarity index 92%
rename from Documentation/networking/PLIP.txt
rename to Documentation/networking/plip.rst
index ad7e3f7c3bbf..0eda745050ff 100644
--- a/Documentation/networking/PLIP.txt
+++ b/Documentation/networking/plip.rst
@@ -1,4 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================================================
 PLIP: The Parallel Line Internet Protocol Device
+================================================
 
 Donald Becker (becker@super.org)
 I.D.A. Supercomputing Research Center, Bowie MD 20715
@@ -83,7 +87,7 @@ When the PLIP driver is used in IRQ mode, the timeout used for triggering a
 data transfer (the maximal time the PLIP driver would allow the other side
 before announcing a timeout, when trying to handshake a transfer of some
 data) is, by default, 500usec. As IRQ delivery is more or less immediate,
-this timeout is quite sufficient. 
+this timeout is quite sufficient.
 
 When in IRQ-less mode, the PLIP driver polls the parallel port HZ times
 per second (where HZ is typically 100 on most platforms, and 1024 on an
@@ -115,7 +119,7 @@ printer "null" cable to transfer data four bits at a time using
 data bit outputs connected to status bit inputs.
 
 The second data transfer method relies on both machines having
-bi-directional parallel ports, rather than output-only ``printer''
+bi-directional parallel ports, rather than output-only ``printer``
 ports.  This allows byte-wide transfers and avoids reconstructing
 nibbles into bytes, leading to much faster transfers.
 
@@ -132,7 +136,7 @@ bits with standard status register implementation.
 
 A cable that implements this protocol is available commercially as a
 "Null Printer" or "Turbo Laplink" cable.  It can be constructed with
-two DB-25 male connectors symmetrically connected as follows:
+two DB-25 male connectors symmetrically connected as follows::
 
     STROBE output	1*
     D0->ERROR	2 - 15		15 - 2
@@ -146,7 +150,8 @@ two DB-25 male connectors symmetrically connected as follows:
     SLCTIN	17 - 17
     extra grounds are 18*,19*,20*,21*,22*,23*,24*
     GROUND	25 - 25
-* Do not connect these pins on either end
+
+    * Do not connect these pins on either end
 
 If the cable you are using has a metallic shield it should be
 connected to the metallic DB-25 shell at one end only.
@@ -155,14 +160,14 @@ Parallel Transfer Mode 1
 ========================
 
 The second data transfer method relies on both machines having
-bi-directional parallel ports, rather than output-only ``printer''
+bi-directional parallel ports, rather than output-only ``printer``
 ports.  This allows byte-wide transfers, and avoids reconstructing
 nibbles into bytes.  This cable should not be used on unidirectional
-``printer'' (as opposed to ``parallel'') ports or when the machine
+``printer`` (as opposed to ``parallel``) ports or when the machine
 isn't configured for PLIP, as it will result in output driver
 conflicts and the (unlikely) possibility of damage.
 
-The cable for this transfer mode should be constructed as follows:
+The cable for this transfer mode should be constructed as follows::
 
     STROBE->BUSY 1 - 11
     D0->D0	2 - 2
@@ -179,7 +184,8 @@ The cable for this transfer mode should be constructed as follows:
     GND->ERROR	18 - 15
     extra grounds are 19*,20*,21*,22*,23*,24*
     GROUND	25 - 25
-* Do not connect these pins on either end
+
+    * Do not connect these pins on either end
 
 Once again, if the cable you are using has a metallic shield it should
 be connected to the metallic DB-25 shell at one end only.
@@ -188,7 +194,7 @@ PLIP Mode 0 transfer protocol
 =============================
 
 The PLIP driver is compatible with the "Crynwr" parallel port transfer
-standard in Mode 0.  That standard specifies the following protocol:
+standard in Mode 0.  That standard specifies the following protocol::
 
    send header nibble '0x8'
    count-low octet
@@ -196,20 +202,21 @@ standard in Mode 0.  That standard specifies the following protocol:
    ... data octets
    checksum octet
 
-Each octet is sent as
+Each octet is sent as::
+
 	<wait for rx. '0x1?'>	<send 0x10+(octet&0x0F)>
 	<wait for rx. '0x0?'>	<send 0x00+((octet>>4)&0x0F)>
 
 To start a transfer the transmitting machine outputs a nibble 0x08.
 That raises the ACK line, triggering an interrupt in the receiving
 machine.  The receiving machine disables interrupts and raises its own ACK
-line. 
+line.
 
-Restated:
+Restated::
 
-(OUT is bit 0-4, OUT.j is bit j from OUT. IN likewise)
-Send_Byte:
-   OUT := low nibble, OUT.4 := 1
-   WAIT FOR IN.4 = 1
-   OUT := high nibble, OUT.4 := 0
-   WAIT FOR IN.4 = 0
+  (OUT is bit 0-4, OUT.j is bit j from OUT. IN likewise)
+  Send_Byte:
+     OUT := low nibble, OUT.4 := 1
+     WAIT FOR IN.4 = 1
+     OUT := high nibble, OUT.4 := 0
+     WAIT FOR IN.4 = 0
diff --git a/drivers/net/plip/Kconfig b/drivers/net/plip/Kconfig
index b41035be2d51..e03556d1d0c2 100644
--- a/drivers/net/plip/Kconfig
+++ b/drivers/net/plip/Kconfig
@@ -21,7 +21,7 @@ config PLIP
 	  bits at a time (mode 0) or with special PLIP cables, to be used on
 	  bidirectional parallel ports only, which can transmit 8 bits at a
 	  time (mode 1); you can find the wiring of these cables in
-	  <file:Documentation/networking/PLIP.txt>.  The cables can be up to
+	  <file:Documentation/networking/plip.rst>.  The cables can be up to
 	  15m long.  Mode 0 works also if one of the machines runs DOS/Windows
 	  and has some PLIP software installed, e.g. the Crynwr PLIP packet
 	  driver (<http://oak.oakland.edu/simtel.net/msdos/pktdrvr-pre.html>)
-- 
2.25.4

