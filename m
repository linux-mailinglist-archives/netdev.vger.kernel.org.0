Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE591BB156
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgD0WFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgD0WB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:57 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5485420B80;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=AxN1whvX2LEvqCh0BfKLJDWQcQXL/COt6CVUMUhB4ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jc57t5d5qk5Qx+ahBntP/QYCixOlOkonvRWm/PpnzZRCvKAIwpfA/I+1jUyzi61Ji
         RuEEJMCefEthB1ngkTmH9ttOxAE+NzvW29gAdXJddgxFb+N8fF39a/HWaZVZq/IBVs
         pCKhGX0te2tXV5N9q5Tdiw0gY2wgIIZl7nj2Od10=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Inq-Hy; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 03/38] docs: networking: convert altera_tse.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:18 +0200
Message-Id: <b1341bc6ced659258fbf6f176727714ab01a716d.1588024424.git.mchehab+huawei@kernel.org>
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
index dc37fc8d5bee..96ffad845fd9 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -38,6 +38,7 @@ Contents:
    nfc
    6lowpan
    6pack
+   altera_tse
 
 .. only::  subproject and html
 
-- 
2.25.4

