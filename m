Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1743C2753D5
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgIWIy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgIWIy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939EDC0613D3
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:26 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xg-0000uS-2m; Wed, 23 Sep 2020 10:54:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 04/20] can: flexcan: struct flexcan_regs: document registers not affected by soft reset
Date:   Wed, 23 Sep 2020 10:54:02 +0200
Message-Id: <20200923085418.2685858-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923085418.2685858-1-mkl@pengutronix.de>
References: <20200923085418.2685858-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch documents which registers are not affected by a soft reset of the
flexcan IP core.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20200922144429.2613631-5-mkl@pengutronix.de
---
 drivers/net/can/flexcan.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c24d7b63e1b9..224000f53a88 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -203,12 +203,12 @@ struct flexcan_mb {
 /* Structure of the hardware registers */
 struct flexcan_regs {
 	u32 mcr;		/* 0x00 */
-	u32 ctrl;		/* 0x04 */
+	u32 ctrl;		/* 0x04 - Not affected by Soft Reset */
 	u32 timer;		/* 0x08 */
 	u32 tcr;		/* 0x0c */
-	u32 rxgmask;		/* 0x10 */
-	u32 rx14mask;		/* 0x14 */
-	u32 rx15mask;		/* 0x18 */
+	u32 rxgmask;		/* 0x10 - Not affected by Soft Reset */
+	u32 rx14mask;		/* 0x14 - Not affected by Soft Reset */
+	u32 rx15mask;		/* 0x18 - Not affected by Soft Reset */
 	u32 ecr;		/* 0x1c */
 	u32 esr;		/* 0x20 */
 	u32 imask2;		/* 0x24 */
@@ -217,20 +217,20 @@ struct flexcan_regs {
 	u32 iflag1;		/* 0x30 */
 	union {			/* 0x34 */
 		u32 gfwr_mx28;	/* MX28, MX53 */
-		u32 ctrl2;	/* MX6, VF610 */
+		u32 ctrl2;	/* MX6, VF610 - Not affected by Soft Reset */
 	};
 	u32 esr2;		/* 0x38 */
 	u32 imeur;		/* 0x3c */
 	u32 lrfr;		/* 0x40 */
 	u32 crcr;		/* 0x44 */
 	u32 rxfgmask;		/* 0x48 */
-	u32 rxfir;		/* 0x4c */
-	u32 cbt;		/* 0x50 */
+	u32 rxfir;		/* 0x4c - Not affected by Soft Reset */
+	u32 cbt;		/* 0x50 - Not affected by Soft Reset */
 	u32 _reserved2;		/* 0x54 */
 	u32 dbg1;		/* 0x58 */
 	u32 dbg2;		/* 0x5c */
 	u32 _reserved3[8];	/* 0x60 */
-	u8 mb[2][512];		/* 0x80 */
+	u8 mb[2][512];		/* 0x80 - Not affected by Soft Reset */
 	/* FIFO-mode:
 	 *			MB
 	 * 0x080...0x08f	0	RX message buffer
@@ -242,7 +242,7 @@ struct flexcan_regs {
 	 *				(mx6, vf610)
 	 */
 	u32 _reserved4[256];	/* 0x480 */
-	u32 rximr[64];		/* 0x880 */
+	u32 rximr[64];		/* 0x880 - Not affected by Soft Reset */
 	u32 _reserved5[24];	/* 0x980 */
 	u32 gfwr_mx6;		/* 0x9e0 - MX6 */
 	u32 _reserved6[63];	/* 0x9e4 */
@@ -255,8 +255,8 @@ struct flexcan_regs {
 	u32 rerrsynr;		/* 0xaf8 */
 	u32 errsr;		/* 0xafc */
 	u32 _reserved7[64];	/* 0xb00 */
-	u32 fdctrl;		/* 0xc00 */
-	u32 fdcbt;		/* 0xc04 */
+	u32 fdctrl;		/* 0xc00 - Not affected by Soft Reset */
+	u32 fdcbt;		/* 0xc04 - Not affected by Soft Reset */
 	u32 fdcrc;		/* 0xc08 */
 };
 
-- 
2.28.0

