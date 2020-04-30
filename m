Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF41C013B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgD3QEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 841F82498F;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=nolpLC+XtpUxWUQxmtZr8j7lwop5gfR05OFWb3huBdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGWUoL4Q3uWwP3L8NAkbk2ZuJ1wilnBnV0iBopMtH0LSKQHYE5Sb6nGbrOwNSCo+b
         gylqZKQXSPj7RH4WmjBbkfLYWZWEM+d//4msWKgAbdUX0C06Y+oM6OAqSLIRJ6esrG
         lOXTO4dgr5C0l2J5WwcSlliptUDsAWSm/5VQZW5s=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGV-Px; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 30/37] docs: networking: convert skfp.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:25 +0200
Message-Id: <1f1a7504063f2b79f8f21144cf8d493df04941e3.1588261997.git.mchehab+huawei@kernel.org>
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
- use copyright symbol;
- add a document title;
- adjust titles and chapters, adding proper markups;
- comment out text-only TOC from html/pdf output;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{skfp.txt => skfp.rst}         | 153 +++++++++++-------
 drivers/net/fddi/Kconfig                      |   2 +-
 3 files changed, 95 insertions(+), 61 deletions(-)
 rename Documentation/networking/{skfp.txt => skfp.rst} (68%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 716744c568b7..d19ddcbe66e5 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -103,6 +103,7 @@ Contents:
    sctp
    secid
    seg6-sysctl
+   skfp
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/skfp.txt b/Documentation/networking/skfp.rst
similarity index 68%
rename from Documentation/networking/skfp.txt
rename to Documentation/networking/skfp.rst
index 203ec66c9fb4..58f548105c1d 100644
--- a/Documentation/networking/skfp.txt
+++ b/Documentation/networking/skfp.rst
@@ -1,35 +1,41 @@
-(C)Copyright 1998-2000 SysKonnect,
-===========================================================================
+.. SPDX-License-Identifier: GPL-2.0
+
+.. include:: <isonum.txt>
+
+========================
+SysKonnect driver - SKFP
+========================
+
+|copy| Copyright 1998-2000 SysKonnect,
 
 skfp.txt created 11-May-2000
 
 Readme File for skfp.o v2.06
 
 
-This file contains
-(1) OVERVIEW
-(2) SUPPORTED ADAPTERS
-(3) GENERAL INFORMATION
-(4) INSTALLATION
-(5) INCLUSION OF THE ADAPTER IN SYSTEM START
-(6) TROUBLESHOOTING
-(7) FUNCTION OF THE ADAPTER LEDS
-(8) HISTORY
+.. This file contains
 
-===========================================================================
+   (1) OVERVIEW
+   (2) SUPPORTED ADAPTERS
+   (3) GENERAL INFORMATION
+   (4) INSTALLATION
+   (5) INCLUSION OF THE ADAPTER IN SYSTEM START
+   (6) TROUBLESHOOTING
+   (7) FUNCTION OF THE ADAPTER LEDS
+   (8) HISTORY
 
 
-
-(1) OVERVIEW
-============
+1. Overview
+===========
 
 This README explains how to use the driver 'skfp' for Linux with your
 network adapter.
 
 Chapter 2: Contains a list of all network adapters that are supported by
-	   this driver.
+this driver.
 
-Chapter 3: Gives some general information.
+Chapter 3:
+	   Gives some general information.
 
 Chapter 4: Describes common problems and solutions.
 
@@ -37,14 +43,13 @@ Chapter 5: Shows the changed functionality of the adapter LEDs.
 
 Chapter 6: History of development.
 
-***
 
-
-(2) SUPPORTED ADAPTERS
-======================
+2. Supported adapters
+=====================
 
 The network driver 'skfp' supports the following network adapters:
 SysKonnect adapters:
+
   - SK-5521 (SK-NET FDDI-UP)
   - SK-5522 (SK-NET FDDI-UP DAS)
   - SK-5541 (SK-NET FDDI-FP)
@@ -55,157 +60,187 @@ SysKonnect adapters:
   - SK-5841 (SK-NET FDDI-FP64)
   - SK-5843 (SK-NET FDDI-LP64)
   - SK-5844 (SK-NET FDDI-LP64 DAS)
+
 Compaq adapters (not tested):
+
   - Netelligent 100 FDDI DAS Fibre SC
   - Netelligent 100 FDDI SAS Fibre SC
   - Netelligent 100 FDDI DAS UTP
   - Netelligent 100 FDDI SAS UTP
   - Netelligent 100 FDDI SAS Fibre MIC
-***
 
 
-(3) GENERAL INFORMATION
-=======================
+3. General Information
+======================
 
 From v2.01 on, the driver is integrated in the linux kernel sources.
 Therefore, the installation is the same as for any other adapter
 supported by the kernel.
+
 Refer to the manual of your distribution about the installation
 of network adapters.
+
 Makes my life much easier :-)
-***
 
-
-(4) TROUBLESHOOTING
-===================
+4. Troubleshooting
+==================
 
 If you run into problems during installation, check those items:
 
-Problem:  The FDDI adapter cannot be found by the driver.
-Reason:   Look in /proc/pci for the following entry:
-             'FDDI network controller: SysKonnect SK-FDDI-PCI ...'
+Problem:
+	  The FDDI adapter cannot be found by the driver.
+
+Reason:
+	  Look in /proc/pci for the following entry:
+
+	     'FDDI network controller: SysKonnect SK-FDDI-PCI ...'
+
 	  If this entry exists, then the FDDI adapter has been
 	  found by the system and should be able to be used.
+
 	  If this entry does not exist or if the file '/proc/pci'
 	  is not there, then you may have a hardware problem or PCI
 	  support may not be enabled in your kernel.
+
 	  The adapter can be checked using the diagnostic program
 	  which is available from the SysKonnect web site:
+
 	      www.syskonnect.de
+
 	  Some COMPAQ machines have a problem with PCI under
 	  Linux. This is described in the 'PCI howto' document
 	  (included in some distributions or available from the
 	  www, e.g. at 'www.linux.org') and no workaround is available.
 
-Problem:  You want to use your computer as a router between
-          multiple IP subnetworks (using multiple adapters), but
+Problem:
+	  You want to use your computer as a router between
+	  multiple IP subnetworks (using multiple adapters), but
 	  you cannot reach computers in other subnetworks.
-Reason:   Either the router's kernel is not configured for IP
+
+Reason:
+	  Either the router's kernel is not configured for IP
 	  forwarding or there is a problem with the routing table
 	  and gateway configuration in at least one of the
 	  computers.
 
 If your problem is not listed here, please contact our
-technical support for help. 
-You can send email to:
-  linux@syskonnect.de
+technical support for help.
+
+You can send email to: linux@syskonnect.de
+
 When contacting our technical support,
 please ensure that the following information is available:
+
 - System Manufacturer and Model
 - Boards in your system
 - Distribution
 - Kernel version
 
-***
 
+5. Function of the Adapter LEDs
+===============================
 
-(5) FUNCTION OF THE ADAPTER LEDS
-================================
+	The functionality of the LED's on the FDDI network adapters was
+	changed in SMT version v2.82. With this new SMT version, the yellow
+	LED works as a ring operational indicator. An active yellow LED
+	indicates that the ring is down. The green LED on the adapter now
+	works as a link indicator where an active GREEN LED indicates that
+	the respective port has a physical connection.
 
-        The functionality of the LED's on the FDDI network adapters was
-        changed in SMT version v2.82. With this new SMT version, the yellow
-        LED works as a ring operational indicator. An active yellow LED
-        indicates that the ring is down. The green LED on the adapter now
-        works as a link indicator where an active GREEN LED indicates that
-        the respective port has a physical connection.
+	With versions of SMT prior to v2.82 a ring up was indicated if the
+	yellow LED was off while the green LED(s) showed the connection
+	status of the adapter. During a ring down the green LED was off and
+	the yellow LED was on.
 
-        With versions of SMT prior to v2.82 a ring up was indicated if the
-        yellow LED was off while the green LED(s) showed the connection
-        status of the adapter. During a ring down the green LED was off and
-        the yellow LED was on.
+	All implementations indicate that a driver is not loaded if
+	all LEDs are off.
 
-        All implementations indicate that a driver is not loaded if
-        all LEDs are off.
 
-***
-
-
-(6) HISTORY
-===========
+6. History
+==========
 
 v2.06 (20000511) (In-Kernel version)
     New features:
+
 	- 64 bit support
 	- new pci dma interface
 	- in kernel 2.3.99
 
 v2.05 (20000217) (In-Kernel version)
     New features:
+
 	- Changes for 2.3.45 kernel
 
 v2.04 (20000207) (Standalone version)
     New features:
+
 	- Added rx/tx byte counter
 
 v2.03 (20000111) (Standalone version)
     Problems fixed:
+
 	- Fixed printk statements from v2.02
 
 v2.02 (991215) (Standalone version)
     Problems fixed:
+
 	- Removed unnecessary output
 	- Fixed path for "printver.sh" in makefile
 
 v2.01 (991122) (In-Kernel version)
     New features:
+
 	- Integration in Linux kernel sources
 	- Support for memory mapped I/O.
 
 v2.00 (991112)
     New features:
+
 	- Full source released under GPL
 
 v1.05 (991023)
     Problems fixed:
+
 	- Compilation with kernel version 2.2.13 failed
 
 v1.04 (990427)
     Changes:
+
 	- New SMT module included, changing LED functionality
+
     Problems fixed:
+
 	- Synchronization on SMP machines was buggy
 
 v1.03 (990325)
     Problems fixed:
+
 	- Interrupt routing on SMP machines could be incorrect
 
 v1.02 (990310)
     New features:
+
 	- Support for kernel versions 2.2.x added
 	- Kernel patch instead of private duplicate of kernel functions
 
 v1.01 (980812)
     Problems fixed:
+
 	Connection hangup with telnet
 	Slow telnet connection
 
 v1.00 beta 01 (980507)
     New features:
+
 	None.
+
     Problems fixed:
+
 	None.
+
     Known limitations:
-        - tar archive instead of standard package format (rpm).
+
+	- tar archive instead of standard package format (rpm).
 	- FDDI statistic is empty.
 	- not tested with 2.1.xx kernels
 	- integration in kernel not tested
@@ -216,5 +251,3 @@ v1.00 beta 01 (980507)
 	- does not work on some COMPAQ machines. See the PCI howto
 	  document for details about this problem.
 	- data corruption with kernel versions below 2.0.33.
-
-*** End of information file ***
diff --git a/drivers/net/fddi/Kconfig b/drivers/net/fddi/Kconfig
index 3b412a56f2cb..da4f58eed08f 100644
--- a/drivers/net/fddi/Kconfig
+++ b/drivers/net/fddi/Kconfig
@@ -77,7 +77,7 @@ config SKFP
 	  - Netelligent 100 FDDI SAS UTP
 	  - Netelligent 100 FDDI SAS Fibre MIC
 
-	  Read <file:Documentation/networking/skfp.txt> for information about
+	  Read <file:Documentation/networking/skfp.rst> for information about
 	  the driver.
 
 	  Questions concerning this driver can be addressed to:
-- 
2.25.4

