Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B791C01B2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgD3QIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbgD3QEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:37 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E160B2137B;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=xBaOvA6HtzXvTRzX0qB7Mk2jjhXinG2Aw/XAQw989vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wmnoe1ZCZDPowTaXBupFLU8m0sITPTVHmtR+qd3gZ5jYAiaawVp5P3/r7UX0So1SD
         nf1WYuVBn+rL0YoLOe4qFyUWoKEaeHDASPeIMBMqw5BOUhLy4pARCesjgP37rLlHro
         IxzUMsf19wjOWSA0bPSr1N+yWGABy7DlY4x4CKQw=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEY-4i; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 06/37] docs: networking: convert multiqueue.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:01 +0200
Message-Id: <d28a323c1d4d309d3dbf68d5d61f9b997fcc1773.1588261997.git.mchehab+huawei@kernel.org>
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
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- use :field: markup;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/bonding.rst          |  2 +-
 Documentation/networking/index.rst            |  1 +
 .../{multiqueue.txt => multiqueue.rst}        | 41 +++++++++----------
 3 files changed, 22 insertions(+), 22 deletions(-)
 rename Documentation/networking/{multiqueue.txt => multiqueue.rst} (76%)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index dd49f95d28d3..24168b0d16bd 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -1639,7 +1639,7 @@ can safely be sent over either interface.  Such configurations may be achieved
 using the traffic control utilities inherent in linux.
 
 By default the bonding driver is multiqueue aware and 16 queues are created
-when the driver initializes (see Documentation/networking/multiqueue.txt
+when the driver initializes (see Documentation/networking/multiqueue.rst
 for details).  If more or less queues are desired the module parameter
 tx_queues can be used to change this value.  There is no sysfs parameter
 available as the allocation is done at module init time.
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index a751cda83c3d..492658bf7c0d 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -79,6 +79,7 @@ Contents:
    ltpc
    mac80211-injection
    mpls-sysctl
+   multiqueue
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/multiqueue.txt b/Documentation/networking/multiqueue.rst
similarity index 76%
rename from Documentation/networking/multiqueue.txt
rename to Documentation/networking/multiqueue.rst
index 4caa0e314cc2..0a576166e9dd 100644
--- a/Documentation/networking/multiqueue.txt
+++ b/Documentation/networking/multiqueue.rst
@@ -1,17 +1,17 @@
+.. SPDX-License-Identifier: GPL-2.0
 
-		HOWTO for multiqueue network device support
-		===========================================
+===========================================
+HOWTO for multiqueue network device support
+===========================================
 
 Section 1: Base driver requirements for implementing multiqueue support
+=======================================================================
 
 Intro: Kernel support for multiqueue devices
 ---------------------------------------------------------
 
 Kernel support for multiqueue devices is always present.
 
-Section 1: Base driver requirements for implementing multiqueue support
------------------------------------------------------------------------
-
 Base drivers are required to use the new alloc_etherdev_mq() or
 alloc_netdev_mq() functions to allocate the subqueues for the device.  The
 underlying kernel API will take care of the allocation and deallocation of
@@ -26,8 +26,7 @@ comes online or when it's completely shut down (unregister_netdev(), etc.).
 
 
 Section 2: Qdisc support for multiqueue devices
-
------------------------------------------------
+===============================================
 
 Currently two qdiscs are optimized for multiqueue devices.  The first is the
 default pfifo_fast qdisc.  This qdisc supports one qdisc per hardware queue.
@@ -46,22 +45,22 @@ will be queued to the band associated with the hardware queue.
 
 
 Section 3: Brief howto using MULTIQ for multiqueue devices
----------------------------------------------------------------
+==========================================================
 
 The userspace command 'tc,' part of the iproute2 package, is used to configure
 qdiscs.  To add the MULTIQ qdisc to your network device, assuming the device
-is called eth0, run the following command:
+is called eth0, run the following command::
 
-# tc qdisc add dev eth0 root handle 1: multiq
+    # tc qdisc add dev eth0 root handle 1: multiq
 
 The qdisc will allocate the number of bands to equal the number of queues that
 the device reports, and bring the qdisc online.  Assuming eth0 has 4 Tx
-queues, the band mapping would look like:
+queues, the band mapping would look like::
 
-band 0 => queue 0
-band 1 => queue 1
-band 2 => queue 2
-band 3 => queue 3
+    band 0 => queue 0
+    band 1 => queue 1
+    band 2 => queue 2
+    band 3 => queue 3
 
 Traffic will begin flowing through each queue based on either the simple_tx_hash
 function or based on netdev->select_queue() if you have it defined.
@@ -69,11 +68,11 @@ function or based on netdev->select_queue() if you have it defined.
 The behavior of tc filters remains the same.  However a new tc action,
 skbedit, has been added.  Assuming you wanted to route all traffic to a
 specific host, for example 192.168.0.3, through a specific queue you could use
-this action and establish a filter such as:
+this action and establish a filter such as::
 
-tc filter add dev eth0 parent 1: protocol ip prio 1 u32 \
-	match ip dst 192.168.0.3 \
-	action skbedit queue_mapping 3
+    tc filter add dev eth0 parent 1: protocol ip prio 1 u32 \
+	    match ip dst 192.168.0.3 \
+	    action skbedit queue_mapping 3
 
-Author: Alexander Duyck <alexander.h.duyck@intel.com>
-Original Author: Peter P. Waskiewicz Jr. <peter.p.waskiewicz.jr@intel.com>
+:Author: Alexander Duyck <alexander.h.duyck@intel.com>
+:Original Author: Peter P. Waskiewicz Jr. <peter.p.waskiewicz.jr@intel.com>
-- 
2.25.4

