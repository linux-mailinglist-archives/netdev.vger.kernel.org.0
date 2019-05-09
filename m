Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFD21875A
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 11:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfEIJBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 05:01:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:44092 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbfEIJBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 05:01:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C3FBB6A2;
        Thu,  9 May 2019 09:01:38 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     petkan@nucleusys.com, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] rtl8150: switch to BIT macro
Date:   Thu,  9 May 2019 11:01:06 +0200
Message-Id: <20190509090106.9065-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bit of housekeeping switching the driver to the BIT()
macro.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/rtl8150.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 59dbdbb5feff..1ed85fba1a7c 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -41,7 +41,7 @@
 #define	ANLP			0x0146
 #define	AER			0x0148
 #define CSCR			0x014C  /* This one has the link status */
-#define CSCR_LINK_STATUS	(1 << 3)
+#define CSCR_LINK_STATUS	BIT(3)
 
 #define	IDR_EEPROM		0x1202
 
@@ -59,20 +59,20 @@
 
 
 /* Transmit status register errors */
-#define TSR_ECOL		(1<<5)
-#define TSR_LCOL		(1<<4)
-#define TSR_LOSS_CRS		(1<<3)
-#define TSR_JBR			(1<<2)
+#define TSR_ECOL		BIT(5)
+#define TSR_LCOL		BIT(4)
+#define TSR_LOSS_CRS		BIT(3)
+#define TSR_JBR			BIT(2)
 #define TSR_ERRORS		(TSR_ECOL | TSR_LCOL | TSR_LOSS_CRS | TSR_JBR)
 /* Receive status register errors */
-#define RSR_CRC			(1<<2)
-#define RSR_FAE			(1<<1)
+#define RSR_CRC			BIT(2)
+#define RSR_FAE			BIT(1)
 #define RSR_ERRORS		(RSR_CRC | RSR_FAE)
 
 /* Media status register definitions */
-#define MSR_DUPLEX		(1<<4)
-#define MSR_SPEED		(1<<3)
-#define MSR_LINK		(1<<2)
+#define MSR_DUPLEX		BIT(4)
+#define MSR_SPEED		BIT(3)
+#define MSR_LINK		BIT(2)
 
 /* Interrupt pipe data */
 #define INT_TSR			0x00
-- 
2.16.4

