Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD3D2F5843
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbhANCQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729042AbhAMVQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:16:25 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2F2C0617BB
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:14:32 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kznTK-0001o1-P0
        for netdev@vger.kernel.org; Wed, 13 Jan 2021 22:14:30 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B36BC5C305D
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 21:14:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D67775C3007;
        Wed, 13 Jan 2021 21:14:12 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 127120ad;
        Wed, 13 Jan 2021 21:14:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [net-next 08/17] can: length: convert to kernel coding style
Date:   Wed, 13 Jan 2021 22:14:01 +0100
Message-Id: <20210113211410.917108-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113211410.917108-1-mkl@pengutronix.de>
References: <20210113211410.917108-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the file into the kernel coding style.

Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210111141930.693847-8-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/length.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/can/dev/length.c b/drivers/net/can/dev/length.c
index 6fe18aa23ec9..5e7d481717ea 100644
--- a/drivers/net/can/dev/length.c
+++ b/drivers/net/can/dev/length.c
@@ -6,8 +6,10 @@
 
 /* CAN DLC to real data length conversion helpers */
 
-static const u8 dlc2len[] = {0, 1, 2, 3, 4, 5, 6, 7,
-			     8, 12, 16, 20, 24, 32, 48, 64};
+static const u8 dlc2len[] = {
+	0, 1, 2, 3, 4, 5, 6, 7,
+	8, 12, 16, 20, 24, 32, 48, 64
+};
 
 /* get data length from raw data length code (DLC) */
 u8 can_fd_dlc2len(u8 dlc)
@@ -16,16 +18,18 @@ u8 can_fd_dlc2len(u8 dlc)
 }
 EXPORT_SYMBOL_GPL(can_fd_dlc2len);
 
-static const u8 len2dlc[] = {0, 1, 2, 3, 4, 5, 6, 7, 8,		/* 0 - 8 */
-			     9, 9, 9, 9,			/* 9 - 12 */
-			     10, 10, 10, 10,			/* 13 - 16 */
-			     11, 11, 11, 11,			/* 17 - 20 */
-			     12, 12, 12, 12,			/* 21 - 24 */
-			     13, 13, 13, 13, 13, 13, 13, 13,	/* 25 - 32 */
-			     14, 14, 14, 14, 14, 14, 14, 14,	/* 33 - 40 */
-			     14, 14, 14, 14, 14, 14, 14, 14,	/* 41 - 48 */
-			     15, 15, 15, 15, 15, 15, 15, 15,	/* 49 - 56 */
-			     15, 15, 15, 15, 15, 15, 15, 15};	/* 57 - 64 */
+static const u8 len2dlc[] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 8,	/* 0 - 8 */
+	9, 9, 9, 9,			/* 9 - 12 */
+	10, 10, 10, 10,			/* 13 - 16 */
+	11, 11, 11, 11,			/* 17 - 20 */
+	12, 12, 12, 12,			/* 21 - 24 */
+	13, 13, 13, 13, 13, 13, 13, 13,	/* 25 - 32 */
+	14, 14, 14, 14, 14, 14, 14, 14,	/* 33 - 40 */
+	14, 14, 14, 14, 14, 14, 14, 14,	/* 41 - 48 */
+	15, 15, 15, 15, 15, 15, 15, 15,	/* 49 - 56 */
+	15, 15, 15, 15, 15, 15, 15, 15	/* 57 - 64 */
+};
 
 /* map the sanitized data length to an appropriate data length code */
 u8 can_fd_len2dlc(u8 len)
-- 
2.29.2


