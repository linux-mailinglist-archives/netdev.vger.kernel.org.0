Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80291C1843
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgEAOp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:45:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729622AbgEAOpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:11 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0EB724960;
        Fri,  1 May 2020 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344308;
        bh=Ihf4waEHpA3haGlf5Lt8qjWzEpnfYn/7o8iz4wJrva4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tb8HFqrrjKSjU1QDyK7FPrwnrmwizo+bABPwhj7BRievEGxm49B6n1iNu0ioCdOZ9
         FSPzRjSOdJhDIPqz/QMZ8le58nZ6aPYfC7bvayB6o490rEh85TBw4aH6ZYfJhgANDJ
         v35fawDiejJem9TZAPjywe9NoFYwvdCgL2QVvsWc=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuU-00FCfL-52; Fri, 01 May 2020 16:45:02 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        netdev@vger.kernel.org
Subject: [PATCH 35/37] docs: networking: device drivers: convert toshiba/spider_net.txt to ReST
Date:   Fri,  1 May 2020 16:44:57 +0200
Message-Id: <65d11ee308138c3b294a73eaade99490d43e9329.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/device_drivers/index.rst       |  1 +
 .../{spider_net.txt => spider_net.rst}        | 58 +++++++++----------
 MAINTAINERS                                   |  2 +-
 3 files changed, 30 insertions(+), 31 deletions(-)
 rename Documentation/networking/device_drivers/toshiba/{spider_net.txt => spider_net.rst} (88%)

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
index adc0bf65fb02..e18dad11bc72 100644
--- a/Documentation/networking/device_drivers/index.rst
+++ b/Documentation/networking/device_drivers/index.rst
@@ -50,6 +50,7 @@ Contents:
    ti/cpsw_switchdev
    ti/cpsw
    ti/tlan
+   toshiba/spider_net
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/device_drivers/toshiba/spider_net.txt b/Documentation/networking/device_drivers/toshiba/spider_net.rst
similarity index 88%
rename from Documentation/networking/device_drivers/toshiba/spider_net.txt
rename to Documentation/networking/device_drivers/toshiba/spider_net.rst
index b0b75f8463b3..fe5b32be15cd 100644
--- a/Documentation/networking/device_drivers/toshiba/spider_net.txt
+++ b/Documentation/networking/device_drivers/toshiba/spider_net.rst
@@ -1,6 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
 
-            The Spidernet Device Driver
-            ===========================
+===========================
+The Spidernet Device Driver
+===========================
 
 Written by Linas Vepstas <linas@austin.ibm.com>
 
@@ -78,15 +80,15 @@ GDACTDPA, tail and head pointers. It will also summarize the contents
 of the ring, starting at the tail pointer, and listing the status
 of the descrs that follow.
 
-A typical example of the output, for a nearly idle system, might be
+A typical example of the output, for a nearly idle system, might be::
 
-net eth1: Total number of descrs=256
-net eth1: Chain tail located at descr=20
-net eth1: Chain head is at 20
-net eth1: HW curr desc (GDACTDPA) is at 21
-net eth1: Have 1 descrs with stat=x40800101
-net eth1: HW next desc (GDACNEXTDA) is at 22
-net eth1: Last 255 descrs with stat=xa0800000
+    net eth1: Total number of descrs=256
+    net eth1: Chain tail located at descr=20
+    net eth1: Chain head is at 20
+    net eth1: HW curr desc (GDACTDPA) is at 21
+    net eth1: Have 1 descrs with stat=x40800101
+    net eth1: HW next desc (GDACNEXTDA) is at 22
+    net eth1: Last 255 descrs with stat=xa0800000
 
 In the above, the hardware has filled in one descr, number 20. Both
 head and tail are pointing at 20, because it has not yet been emptied.
@@ -101,11 +103,11 @@ The status x4... corresponds to "full" and status xa... corresponds
 to "empty". The actual value printed is RXCOMST_A.
 
 In the device driver source code, a different set of names are
-used for these same concepts, so that
+used for these same concepts, so that::
 
-"empty" == SPIDER_NET_DESCR_CARDOWNED == 0xa
-"full"  == SPIDER_NET_DESCR_FRAME_END == 0x4
-"not in use" == SPIDER_NET_DESCR_NOT_IN_USE == 0xf
+    "empty" == SPIDER_NET_DESCR_CARDOWNED == 0xa
+    "full"  == SPIDER_NET_DESCR_FRAME_END == 0x4
+    "not in use" == SPIDER_NET_DESCR_NOT_IN_USE == 0xf
 
 
 The RX RAM full bug/feature
@@ -137,19 +139,19 @@ while the hardware is waiting for a different set of descrs to become
 empty.
 
 A call to show_rx_chain() at this point indicates the nature of the
-problem. A typical print when the network is hung shows the following:
+problem. A typical print when the network is hung shows the following::
 
-net eth1: Spider RX RAM full, incoming packets might be discarded!
-net eth1: Total number of descrs=256
-net eth1: Chain tail located at descr=255
-net eth1: Chain head is at 255
-net eth1: HW curr desc (GDACTDPA) is at 0
-net eth1: Have 1 descrs with stat=xa0800000
-net eth1: HW next desc (GDACNEXTDA) is at 1
-net eth1: Have 127 descrs with stat=x40800101
-net eth1: Have 1 descrs with stat=x40800001
-net eth1: Have 126 descrs with stat=x40800101
-net eth1: Last 1 descrs with stat=xa0800000
+    net eth1: Spider RX RAM full, incoming packets might be discarded!
+    net eth1: Total number of descrs=256
+    net eth1: Chain tail located at descr=255
+    net eth1: Chain head is at 255
+    net eth1: HW curr desc (GDACTDPA) is at 0
+    net eth1: Have 1 descrs with stat=xa0800000
+    net eth1: HW next desc (GDACNEXTDA) is at 1
+    net eth1: Have 127 descrs with stat=x40800101
+    net eth1: Have 1 descrs with stat=x40800001
+    net eth1: Have 126 descrs with stat=x40800101
+    net eth1: Last 1 descrs with stat=xa0800000
 
 Both the tail and head pointers are pointing at descr 255, which is
 marked xa... which is "empty". Thus, from the OS point of view, there
@@ -198,7 +200,3 @@ For large packets, this mechanism generates a relatively small number
 of interrupts, about 1K/sec. For smaller packets, this will drop to zero
 interrupts, as the hardware can empty the queue faster than the kernel
 can fill it.
-
-
- ======= END OF DOCUMENT ========
-
diff --git a/MAINTAINERS b/MAINTAINERS
index b0b352389d14..a580fc74ae95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15919,7 +15919,7 @@ SPIDERNET NETWORK DRIVER for CELL
 M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	Documentation/networking/device_drivers/toshiba/spider_net.txt
+F:	Documentation/networking/device_drivers/toshiba/spider_net.rst
 F:	drivers/net/ethernet/toshiba/spider_net*
 
 SPMI SUBSYSTEM
-- 
2.25.4

