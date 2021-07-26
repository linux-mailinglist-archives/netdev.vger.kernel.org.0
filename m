Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCB13D5B45
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhGZNdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhGZNc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:32:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8144C0617BD
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81LL-0001x6-6M
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:31 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 05D14658269
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:12:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 45DE16581D3;
        Mon, 26 Jul 2021 14:11:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2ba9f4d7;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 26/46] net: at91_can: use BIT macro
Date:   Mon, 26 Jul 2021 16:11:24 +0200
Message-Id: <20210726141144.862529-27-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch uses the BIT macro for setting individual bits,
to fix the following checkpatch.pl issue:
CHECK: Prefer using the BIT macro.

Link: https://lore.kernel.org/r/1624096589-13452-5-git-send-email-huangguangbin2@huawei.com
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 20c67b8490d3..9052c7af0f23 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -87,19 +87,19 @@ enum at91_mb_mode {
 };
 
 /* Interrupt mask bits */
-#define AT91_IRQ_ERRA		(1 << 16)
-#define AT91_IRQ_WARN		(1 << 17)
-#define AT91_IRQ_ERRP		(1 << 18)
-#define AT91_IRQ_BOFF		(1 << 19)
-#define AT91_IRQ_SLEEP		(1 << 20)
-#define AT91_IRQ_WAKEUP		(1 << 21)
-#define AT91_IRQ_TOVF		(1 << 22)
-#define AT91_IRQ_TSTP		(1 << 23)
-#define AT91_IRQ_CERR		(1 << 24)
-#define AT91_IRQ_SERR		(1 << 25)
-#define AT91_IRQ_AERR		(1 << 26)
-#define AT91_IRQ_FERR		(1 << 27)
-#define AT91_IRQ_BERR		(1 << 28)
+#define AT91_IRQ_ERRA		BIT(16)
+#define AT91_IRQ_WARN		BIT(17)
+#define AT91_IRQ_ERRP		BIT(18)
+#define AT91_IRQ_BOFF		BIT(19)
+#define AT91_IRQ_SLEEP		BIT(20)
+#define AT91_IRQ_WAKEUP		BIT(21)
+#define AT91_IRQ_TOVF		BIT(22)
+#define AT91_IRQ_TSTP		BIT(23)
+#define AT91_IRQ_CERR		BIT(24)
+#define AT91_IRQ_SERR		BIT(25)
+#define AT91_IRQ_AERR		BIT(26)
+#define AT91_IRQ_FERR		BIT(27)
+#define AT91_IRQ_BERR		BIT(28)
 
 #define AT91_IRQ_ERR_ALL	(0x1fff0000)
 #define AT91_IRQ_ERR_FRAME	(AT91_IRQ_CERR | AT91_IRQ_SERR | \
-- 
2.30.2


