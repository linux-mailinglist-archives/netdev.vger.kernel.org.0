Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9332D1547C0
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgBFPTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38054 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=nnWg+8aH8ZOHODuRm5r6ALThw0WyVVTSxDI4IeVcmA8=; b=Wqr+twoyQB1AVUq905ouezfJKy
        jDmqD61YbBlTFM0BOBte7IwCudSMG+QSSinKk4Nz8bBXt0rKomwwi8MpXj8wwmUmphagTOZul7Q9B
        Cgj8EZrYSNvnYcSJBGvmLRj61KuBX4OS3w8DhjS6CuZTKqfoDSIZ3TDe3DPCWYQUdJ6mcMVjqqjJW
        cFULsIKe0uC/HZN6ZJz0Vba+kyNJ/XaLl/4NyO8E6DGqiZ73Y5nIvA1CIn9/SWfUKRf5i9/pNE3n/
        YiyIksxi0sO6XOkOZ7Qyr0WF1ES9//F6zmBE4PyE4WH2dQtYW1VTrmd3NANR1TMSdscQVAC506cr+
        asYyLbiw==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jI-4E; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziuc-002oUv-KM; Thu, 06 Feb 2020 16:17:50 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 03/28] docs: networking: convert 6pack.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:23 +0100
Message-Id: <a3f4a0a45533b6182d69e6577be5fdc00548dac1.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
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
 2 files changed, 32 insertions(+), 15 deletions(-)
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
index cc34c06477eb..0b8b4848683d 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -35,6 +35,7 @@ Contents:
    tls-offload
    nfc
    6lowpan
+   6pack
 
 .. only::  subproject and html
 
-- 
2.24.1

