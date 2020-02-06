Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9971C1547A7
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgBFPSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:18:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38150 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727604AbgBFPSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:18:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hxtqPG2PmCrRsqAVYVDHkWSaT6ymA3jSiP5ZLoDasWE=; b=R2q93KJMFjW/TXg1otCvKSICSO
        NeDoZ6Y0QPiIolUzlSEgwgHrklzCGbSkt6O7yjg3dHj55DIyxOFxSs5678HMqqHtQgNzbwr+HCLIj
        hYo6O77bI/poQh8Wm/dnOh1Tdqbx6k3zGUESaPQfOMiE38/ZpFW8E0jBdFryRPz9K2fbfn29yeIXr
        2vJa7g0gPjlky4lk3ErkL/oqslGf8fwvJ+5AGudci99G0KB1cTnWJrleq+rNjrpHx/2DQLFqIGNsw
        iWTomgF7q/VwMLmhF7i57K5kU5it+CVpBAyYSmukDzWNCKgDO1w73fkDHY/QFkY7oaMYrdhn1Hcsn
        48U5Ssrw==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jK-LQ; Thu, 06 Feb 2020 15:18:00 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziuc-002oUz-Md; Thu, 06 Feb 2020 16:17:50 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 04/28] docs: networking: convert altera_tse.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:24 +0100
Message-Id: <4904cf566caff70fefba1c3e4bdb8a3ec0ab94aa.1581002063.git.mchehab+huawei@kernel.org>
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
- use copyright symbol;
- adjust titles and chapters, adding proper markups;
- mark lists as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../{altera_tse.txt => altera_tse.rst}        | 87 ++++++++++++-------
 Documentation/networking/index.rst            |  1 +
 2 files changed, 56 insertions(+), 32 deletions(-)
 rename Documentation/networking/{altera_tse.txt => altera_tse.rst} (85%)

diff --git a/Documentation/networking/altera_tse.txt b/Documentation/networking/altera_tse.rst
similarity index 85%
rename from Documentation/networking/altera_tse.txt
rename to Documentation/networking/altera_tse.rst
index 50b8589d12fd..7a7040072e58 100644
--- a/Documentation/networking/altera_tse.txt
+++ b/Documentation/networking/altera_tse.rst
@@ -1,6 +1,12 @@
-       Altera Triple-Speed Ethernet MAC driver
+.. SPDX-License-Identifier: GPL-2.0
 
-Copyright (C) 2008-2014 Altera Corporation
+.. include:: <isonum.txt>
+
+=======================================
+Altera Triple-Speed Ethernet MAC driver
+=======================================
+
+Copyright |copy| 2008-2014 Altera Corporation
 
 This is the driver for the Altera Triple-Speed Ethernet (TSE) controllers
 using the SGDMA and MSGDMA soft DMA IP components. The driver uses the
@@ -46,23 +52,33 @@ Jumbo frames are not supported at this time.
 The driver limits PHY operations to 10/100Mbps, and has not yet been fully
 tested for 1Gbps. This support will be added in a future maintenance update.
 
-1) Kernel Configuration
+1. Kernel Configuration
+=======================
+
 The kernel configuration option is ALTERA_TSE:
+
  Device Drivers ---> Network device support ---> Ethernet driver support --->
  Altera Triple-Speed Ethernet MAC support (ALTERA_TSE)
 
-2) Driver parameters list:
-	debug: message level (0: no output, 16: all);
-	dma_rx_num: Number of descriptors in the RX list (default is 64);
-	dma_tx_num: Number of descriptors in the TX list (default is 64).
+2. Driver parameters list
+=========================
+
+	- debug: message level (0: no output, 16: all);
+	- dma_rx_num: Number of descriptors in the RX list (default is 64);
+	- dma_tx_num: Number of descriptors in the TX list (default is 64).
+
+3. Command line options
+=======================
+
+Driver parameters can be also passed in command line by using::
 
-3) Command line options
-Driver parameters can be also passed in command line by using:
 	altera_tse=dma_rx_num:128,dma_tx_num:512
 
-4) Driver information and notes
+4. Driver information and notes
+===============================
 
-4.1) Transmit process
+4.1. Transmit process
+---------------------
 When the driver's transmit routine is called by the kernel, it sets up a
 transmit descriptor by calling the underlying DMA transmit routine (SGDMA or
 MSGDMA), and initiates a transmit operation. Once the transmit is complete, an
@@ -70,7 +86,8 @@ interrupt is driven by the transmit DMA logic. The driver handles the transmit
 completion in the context of the interrupt handling chain by recycling
 resource required to send and track the requested transmit operation.
 
-4.2) Receive process
+4.2. Receive process
+--------------------
 The driver will post receive buffers to the receive DMA logic during driver
 initialization. Receive buffers may or may not be queued depending upon the
 underlying DMA logic (MSGDMA is able queue receive buffers, SGDMA is not able
@@ -79,34 +96,39 @@ received, the DMA logic generates an interrupt. The driver handles a receive
 interrupt by obtaining the DMA receive logic status, reaping receive
 completions until no more receive completions are available.
 
-4.3) Interrupt Mitigation
+4.3. Interrupt Mitigation
+-------------------------
 The driver is able to mitigate the number of its DMA interrupts
 using NAPI for receive operations. Interrupt mitigation is not yet supported
 for transmit operations, but will be added in a future maintenance release.
 
 4.4) Ethtool support
+--------------------
 Ethtool is supported. Driver statistics and internal errors can be taken using:
 ethtool -S ethX command. It is possible to dump registers etc.
 
 4.5) PHY Support
+----------------
 The driver is compatible with PAL to work with PHY and GPHY devices.
 
 4.7) List of source files:
- o Kconfig
- o Makefile
- o altera_tse_main.c: main network device driver
- o altera_tse_ethtool.c: ethtool support
- o altera_tse.h: private driver structure and common definitions
- o altera_msgdma.h: MSGDMA implementation function definitions
- o altera_sgdma.h: SGDMA implementation function definitions
- o altera_msgdma.c: MSGDMA implementation
- o altera_sgdma.c: SGDMA implementation
- o altera_sgdmahw.h: SGDMA register and descriptor definitions
- o altera_msgdmahw.h: MSGDMA register and descriptor definitions
- o altera_utils.c: Driver utility functions
- o altera_utils.h: Driver utility function definitions
+--------------------------
+ - Kconfig
+ - Makefile
+ - altera_tse_main.c: main network device driver
+ - altera_tse_ethtool.c: ethtool support
+ - altera_tse.h: private driver structure and common definitions
+ - altera_msgdma.h: MSGDMA implementation function definitions
+ - altera_sgdma.h: SGDMA implementation function definitions
+ - altera_msgdma.c: MSGDMA implementation
+ - altera_sgdma.c: SGDMA implementation
+ - altera_sgdmahw.h: SGDMA register and descriptor definitions
+ - altera_msgdmahw.h: MSGDMA register and descriptor definitions
+ - altera_utils.c: Driver utility functions
+ - altera_utils.h: Driver utility function definitions
 
-5) Debug Information
+5. Debug Information
+====================
 
 The driver exports debug information such as internal statistics,
 debug information, MAC and DMA registers etc.
@@ -118,17 +140,18 @@ or sees the MAC registers: e.g. using: ethtool -d ethX
 The developer can also use the "debug" module parameter to get
 further debug information.
 
-6) Statistics Support
+6. Statistics Support
+=====================
 
 The controller and driver support a mix of IEEE standard defined statistics,
 RFC defined statistics, and driver or Altera defined statistics. The four
 specifications containing the standard definitions for these statistics are
 as follows:
 
- o IEEE 802.3-2012 - IEEE Standard for Ethernet.
- o RFC 2863 found at http://www.rfc-editor.org/rfc/rfc2863.txt.
- o RFC 2819 found at http://www.rfc-editor.org/rfc/rfc2819.txt.
- o Altera Triple Speed Ethernet User Guide, found at http://www.altera.com
+ - IEEE 802.3-2012 - IEEE Standard for Ethernet.
+ - RFC 2863 found at http://www.rfc-editor.org/rfc/rfc2863.txt.
+ - RFC 2819 found at http://www.rfc-editor.org/rfc/rfc2819.txt.
+ - Altera Triple Speed Ethernet User Guide, found at http://www.altera.com
 
 The statistics supported by the TSE and the device driver are as follows:
 
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 0b8b4848683d..16778c7e023b 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -36,6 +36,7 @@ Contents:
    nfc
    6lowpan
    6pack
+   altera_tse
 
 .. only::  subproject and html
 
-- 
2.24.1

