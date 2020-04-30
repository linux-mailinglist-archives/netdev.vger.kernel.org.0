Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5FF1C01AC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgD3QIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgD3QEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:37 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E360021775;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=qd7kn84OagFUysKXIXX2kLbZbPYWdZY7QoCvFH7ExWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zewLwoR5gpbg89jj3RBoyAkOKlKbBwaG78zDZhml4NmCTEad7J+eJD7if6juXweYC
         N5dIZO62A0PUXSOMPrR7EIRUS6aXDqrFJzt376vFrVybtHem9J2yi7RqO9xZPThPcD
         EuxIEz7n0UdctdfrFxfavc2DyKxoSfIQMaEngU1s=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEn-7O; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 09/37] docs: networking: convert netdevices.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:04 +0200
Message-Id: <bd505d26902d26d2a06601867cb576b27f47bff3.1588261997.git.mchehab+huawei@kernel.org>
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
- adjust title markup;
- mark lists as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/can.rst              |  2 +-
 Documentation/networking/index.rst            |  1 +
 .../{netdevices.txt => netdevices.rst}        | 21 ++++++++++++-------
 3 files changed, 16 insertions(+), 8 deletions(-)
 rename Documentation/networking/{netdevices.txt => netdevices.rst} (89%)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index 2fd0b51a8c52..ff05cbd05e0d 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -1058,7 +1058,7 @@ drivers you mainly have to deal with:
 - TX: Put the CAN frame from the socket buffer to the CAN controller.
 - RX: Put the CAN frame from the CAN controller to the socket buffer.
 
-See e.g. at Documentation/networking/netdevices.txt . The differences
+See e.g. at Documentation/networking/netdevices.rst . The differences
 for writing CAN network device driver are described below:
 
 
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4c6aa3db97d4..5a320553ffba 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -82,6 +82,7 @@ Contents:
    multiqueue
    netconsole
    netdev-features
+   netdevices
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/netdevices.txt b/Documentation/networking/netdevices.rst
similarity index 89%
rename from Documentation/networking/netdevices.txt
rename to Documentation/networking/netdevices.rst
index 7fec2061a334..5a85fcc80c76 100644
--- a/Documentation/networking/netdevices.txt
+++ b/Documentation/networking/netdevices.rst
@@ -1,5 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
 
+=====================================
 Network Devices, the Kernel, and You!
+=====================================
 
 
 Introduction
@@ -75,11 +78,12 @@ ndo_start_xmit:
 	Don't use it for new drivers.
 
 	Context: Process with BHs disabled or BH (timer),
-	         will be called with interrupts disabled by netconsole.
+		 will be called with interrupts disabled by netconsole.
 
-	Return codes: 
-	o NETDEV_TX_OK everything ok. 
-	o NETDEV_TX_BUSY Cannot transmit packet, try later 
+	Return codes:
+
+	* NETDEV_TX_OK everything ok.
+	* NETDEV_TX_BUSY Cannot transmit packet, try later
 	  Usually a bug, means queue start/stop flow control is broken in
 	  the driver. Note: the driver must NOT put the skb in its DMA ring.
 
@@ -95,10 +99,13 @@ ndo_set_rx_mode:
 struct napi_struct synchronization rules
 ========================================
 napi->poll:
-	Synchronization: NAPI_STATE_SCHED bit in napi->state.  Device
+	Synchronization:
+		NAPI_STATE_SCHED bit in napi->state.  Device
 		driver's ndo_stop method will invoke napi_disable() on
 		all NAPI instances which will do a sleeping poll on the
 		NAPI_STATE_SCHED napi->state bit, waiting for all pending
 		NAPI activity to cease.
-	Context: softirq
-	         will be called with interrupts disabled by netconsole.
+
+	Context:
+		 softirq
+		 will be called with interrupts disabled by netconsole.
-- 
2.25.4

