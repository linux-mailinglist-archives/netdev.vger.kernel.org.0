Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1E81BB0DE
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgD0WB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbgD0WB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:01:57 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F23206D9;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=pVA9OaErKP0hgBQz20FkuuYqF8blrIapVovuG1NtvWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOtIMLUvKEY22dD6c76ydVCKWImx+1neUg0wh1dzpLVcJMEOmIJZoAt+cy2f2gbyj
         yEJJvI1sQZlkJTv2fQQggxrSju0LP17EtRbD2X4NKrTv3TCONKR0mxUGQfC/DAm5LT
         phX0rsKlcgnm+d6mXydtNdXqDRFeCBSXU3WzpfxE=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp4-000Inm-HD; Tue, 28 Apr 2020 00:01:54 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 02/38] docs: networking: convert 6pack.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:17 +0200
Message-Id: <6122d960e575bcc5b51e87fcb354fbdb9f06d837.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- use title markups;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{6pack.txt => 6pack.rst}       | 46 +++++++++++++------
 Documentation/networking/index.rst            |  1 +
 drivers/net/hamradio/Kconfig                  |  2 +-
 3 files changed, 33 insertions(+), 16 deletions(-)
 rename Documentation/networking/{6pack.txt => 6pack.rst} (90%)

diff --git a/Documentation/networking/6pack.txt b/Documentation/networking/6pack.rst
similarity index 90%
rename from Documentation/networking/6pack.txt
rename to Documentation/networking/6pack.rst
index 8f339428fdf4..bc5bf1f1a98f 100644
--- a/Documentation/networking/6pack.txt
+++ b/Documentation/networking/6pack.rst
@@ -1,27 +1,36 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==============
+6pack Protocol
+==============
+
 This is the 6pack-mini-HOWTO, written by
 
 Andreas Könsgen DG3KQ
-Internet: ajk@comnets.uni-bremen.de
-AMPR-net: dg3kq@db0pra.ampr.org
-AX.25:    dg3kq@db0ach.#nrw.deu.eu
+
+:Internet: ajk@comnets.uni-bremen.de
+:AMPR-net: dg3kq@db0pra.ampr.org
+:AX.25:    dg3kq@db0ach.#nrw.deu.eu
 
 Last update: April 7, 1998
 
 1. What is 6pack, and what are the advantages to KISS?
+======================================================
 
 6pack is a transmission protocol for data exchange between the PC and
 the TNC over a serial line. It can be used as an alternative to KISS.
 
 6pack has two major advantages:
+
 - The PC is given full control over the radio
   channel. Special control data is exchanged between the PC and the TNC so
   that the PC knows at any time if the TNC is receiving data, if a TNC
   buffer underrun or overrun has occurred, if the PTT is
   set and so on. This control data is processed at a higher priority than
   normal data, so a data stream can be interrupted at any time to issue an
-  important event. This helps to improve the channel access and timing 
-  algorithms as everything is computed in the PC. It would even be possible 
-  to experiment with something completely different from the known CSMA and 
+  important event. This helps to improve the channel access and timing
+  algorithms as everything is computed in the PC. It would even be possible
+  to experiment with something completely different from the known CSMA and
   DAMA channel access methods.
   This kind of real-time control is especially important to supply several
   TNCs that are connected between each other and the PC by a daisy chain
@@ -36,6 +45,7 @@ More details about 6pack are described in the file 6pack.ps that is located
 in the doc directory of the AX.25 utilities package.
 
 2. Who has developed the 6pack protocol?
+========================================
 
 The 6pack protocol has been developed by Ekki Plicht DF4OR, Henning Rech
 DF9IC and Gunter Jost DK7WJ. A driver for 6pack, written by Gunter Jost and
@@ -44,12 +54,14 @@ They have also written a firmware for TNCs to perform the 6pack
 protocol (see section 4 below).
 
 3. Where can I get the latest version of 6pack for LinuX?
+=========================================================
 
 At the moment, the 6pack stuff can obtained via anonymous ftp from
 db0bm.automation.fh-aachen.de. In the directory /incoming/dg3kq,
 there is a file named 6pack.tgz.
 
 4. Preparing the TNC for 6pack operation
+========================================
 
 To be able to use 6pack, a special firmware for the TNC is needed. The EPROM
 of a newly bought TNC does not contain 6pack, so you will have to
@@ -75,12 +87,14 @@ and the status LED are lit for about a second if the firmware initialises
 the TNC correctly.
 
 5. Building and installing the 6pack driver
+===========================================
 
 The driver has been tested with kernel version 2.1.90. Use with older
 kernels may lead to a compilation error because the interface to a kernel
 function has been changed in the 2.1.8x kernels.
 
 How to turn on 6pack support:
+=============================
 
 - In the linux kernel configuration program, select the code maturity level
   options menu and turn on the prompting for development drivers.
@@ -94,27 +108,28 @@ To use the driver, the kissattach program delivered with the AX.25 utilities
 has to be modified.
 
 - Do a cd to the directory that holds the kissattach sources. Edit the
-  kissattach.c file. At the top, insert the following lines:
+  kissattach.c file. At the top, insert the following lines::
 
-  #ifndef N_6PACK
-  #define N_6PACK (N_AX25+1)
-  #endif
+    #ifndef N_6PACK
+    #define N_6PACK (N_AX25+1)
+    #endif
 
-  Then find the line
-   
-  int disc = N_AX25;
+  Then find the line:
+
+    int disc = N_AX25;
 
   and replace N_AX25 by N_6PACK.
 
 - Recompile kissattach. Rename it to spattach to avoid confusions.
 
 Installing the driver:
+----------------------
 
-- Do an insmod 6pack. Look at your /var/log/messages file to check if the 
+- Do an insmod 6pack. Look at your /var/log/messages file to check if the
   module has printed its initialization message.
 
 - Do a spattach as you would launch kissattach when starting a KISS port.
-  Check if the kernel prints the message '6pack: TNC found'. 
+  Check if the kernel prints the message '6pack: TNC found'.
 
 - From here, everything should work as if you were setting up a KISS port.
   The only difference is that the network device that represents
@@ -138,6 +153,7 @@ from the PC to the TNC over the serial line, the status LED if data is
 sent to the PC.
 
 6. Known problems
+=================
 
 When testing the driver with 2.0.3x kernels and
 operating with data rates on the radio channel of 9600 Baud or higher,
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 5b3421ec25ec..dc37fc8d5bee 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -37,6 +37,7 @@ Contents:
    tls-offload
    nfc
    6lowpan
+   6pack
 
 .. only::  subproject and html
 
diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index 8e05b5c31a77..bf306fed04cc 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -30,7 +30,7 @@ config 6PACK
 
 	  Note that this driver is still experimental and might cause
 	  problems. For details about the features and the usage of the
-	  driver, read <file:Documentation/networking/6pack.txt>.
+	  driver, read <file:Documentation/networking/6pack.rst>.
 
 	  To compile this driver as a module, choose M here: the module
 	  will be called 6pack.
-- 
2.25.4

