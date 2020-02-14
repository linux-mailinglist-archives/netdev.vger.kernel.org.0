Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B6C15D941
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 15:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbgBNOR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 09:17:56 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44421 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgBNOR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 09:17:56 -0500
X-Originating-IP: 90.65.102.129
Received: from localhost (lfbn-lyo-1-1670-129.w90-65.abo.wanadoo.fr [90.65.102.129])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id B02B8E0007;
        Fri, 14 Feb 2020 14:17:53 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Wolfgang Grandegger <wg@grandegger.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH] can: flexcan: fix spelling mistake "reserverd" -> "reserved"
Date:   Fri, 14 Feb 2020 15:17:51 +0100
Message-Id: <20200214141751.21168-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a mistake in a register layout description.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 94d10ec954a0..19403e88daa3 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -230,7 +230,7 @@ struct flexcan_regs {
 	/* FIFO-mode:
 	 *			MB
 	 * 0x080...0x08f	0	RX message buffer
-	 * 0x090...0x0df	1-5	reserverd
+	 * 0x090...0x0df	1-5	reserved
 	 * 0x0e0...0x0ff	6-7	8 entry ID table
 	 *				(mx25, mx28, mx35, mx53)
 	 * 0x0e0...0x2df	6-7..37	8..128 entry ID table
-- 
2.24.1

